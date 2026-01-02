#!/usr/bin/env python3
"""
Security Scanner Hook
Blocks commits containing secrets, API keys, or credentials.
"""

import json
import os
import re
import sys
from datetime import datetime
from pathlib import Path

# Secret patterns to detect
SECRET_PATTERNS = [
    # API Keys (generic)
    (r'(?i)(api[_-]?key|apikey)[\'"]?\s*[:=]\s*[\'"]?[a-zA-Z0-9]{20,}', 'API Key'),

    # AWS Keys
    (r'AKIA[0-9A-Z]{16}', 'AWS Access Key'),
    (r'(?i)aws[_-]?secret[_-]?access[_-]?key\s*[:=]\s*[\'"]?[a-zA-Z0-9/+=]{40}', 'AWS Secret Key'),

    # Private Keys
    (r'-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----', 'Private Key'),

    # GitHub Tokens
    (r'ghp_[a-zA-Z0-9]{36}', 'GitHub Personal Token'),
    (r'gho_[a-zA-Z0-9]{36}', 'GitHub OAuth Token'),
    (r'ghs_[a-zA-Z0-9]{36}', 'GitHub Server Token'),

    # OpenAI/Anthropic Keys
    (r'sk-[a-zA-Z0-9]{48}', 'OpenAI API Key'),
    (r'sk-ant-[a-zA-Z0-9-]{80,}', 'Anthropic API Key'),

    # Slack Tokens
    (r'xox[baprs]-[a-zA-Z0-9-]{10,}', 'Slack Token'),

    # Generic Passwords
    (r'(?i)(password|passwd|pwd)[\'"]?\s*[:=]\s*[\'"][^\'"\s]{8,}[\'"]', 'Hardcoded Password'),

    # JWT Tokens
    (r'eyJ[a-zA-Z0-9_-]*\.eyJ[a-zA-Z0-9_-]*\.[a-zA-Z0-9_-]*', 'JWT Token'),

    # Database URLs with credentials
    (r'(?i)(postgres|mysql|mongodb)://[^:]+:[^@]+@', 'Database Connection String'),
]

# Files to always skip (false positive prone)
SKIP_FILES = [
    '.git/',
    'node_modules/',
    '__pycache__/',
    '.pytest_cache/',
    'dist/',
    'build/',
    '.lock',
    '.md',  # Skip markdown (documentation)
]

def get_log_path():
    """Get the log file path."""
    log_dir = Path.cwd() / '.claude' / 'logs'
    log_dir.mkdir(parents=True, exist_ok=True)
    return log_dir / 'security-scan.log'

def log_event(message: str, level: str = 'INFO'):
    """Log an event to the security scan log."""
    log_path = get_log_path()
    timestamp = datetime.now().isoformat()
    with open(log_path, 'a') as f:
        f.write(f'[{timestamp}] [{level}] {message}\n')

def should_skip_file(file_path: str) -> bool:
    """Check if file should be skipped."""
    for pattern in SKIP_FILES:
        if pattern in file_path:
            return True
    return False

def scan_content(content: str, file_path: str) -> list:
    """Scan content for secrets."""
    findings = []

    for pattern, secret_type in SECRET_PATTERNS:
        matches = re.finditer(pattern, content)
        for match in matches:
            # Get line number
            line_num = content[:match.start()].count('\n') + 1
            findings.append({
                'type': secret_type,
                'file': file_path,
                'line': line_num,
                'match': match.group()[:50] + '...' if len(match.group()) > 50 else match.group()
            })

    return findings

def main():
    """Main entry point."""
    try:
        # Read hook input from stdin
        input_data = sys.stdin.read()

        if not input_data:
            sys.exit(0)

        hook_input = json.loads(input_data)

        # Get the file path and content being written
        tool_input = hook_input.get('tool_input', {})
        file_path = tool_input.get('file_path', '')
        content = tool_input.get('content', '') or tool_input.get('new_string', '')

        if not file_path or not content:
            sys.exit(0)

        # Skip certain files
        if should_skip_file(file_path):
            sys.exit(0)

        # Scan for secrets
        findings = scan_content(content, file_path)

        if findings:
            log_event(f'BLOCKED: Found {len(findings)} secret(s) in {file_path}', 'CRITICAL')

            # Output blocking message
            error_msg = f"\n{'='*60}\n"
            error_msg += "SECURITY SCAN: SECRETS DETECTED\n"
            error_msg += f"{'='*60}\n\n"
            error_msg += f"File: {file_path}\n\n"

            for finding in findings:
                error_msg += f"  [{finding['type']}] Line {finding['line']}\n"
                error_msg += f"  Match: {finding['match']}\n\n"

            error_msg += "ACTION REQUIRED:\n"
            error_msg += "  1. Remove secrets from code\n"
            error_msg += "  2. Use environment variables instead\n"
            error_msg += "  3. Add secrets to .env (gitignored)\n"
            error_msg += f"\n{'='*60}\n"

            print(json.dumps({
                'decision': 'block',
                'message': error_msg
            }))
            sys.exit(0)

        # No secrets found
        log_event(f'PASSED: {file_path}', 'INFO')
        print(json.dumps({'decision': 'allow'}))
        sys.exit(0)

    except json.JSONDecodeError:
        # Not valid JSON, allow
        sys.exit(0)
    except Exception as e:
        log_event(f'ERROR: {str(e)}', 'ERROR')
        # On error, allow to prevent blocking legitimate work
        sys.exit(0)

if __name__ == '__main__':
    main()
