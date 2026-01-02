# Permissions & Security

## Overview

This document describes the security model and permissions for claude-superpowers hooks and agents.

## Hook Permissions

### Security Scan Hook

**File:** `hooks/scripts/security-scan.py`

| Permission | Required | Purpose |
|------------|----------|---------|
| Read stdin | Yes | Receive hook input |
| Write stdout | Yes | Return decision |
| Read files | No | Scans content passed to it |
| Write files | Yes | Logs to `.claude/logs/` |
| Network | No | Runs locally only |

**What it blocks:**
- API keys and secrets
- Private keys (PEM, KEY)
- Hardcoded passwords
- JWT tokens
- Database connection strings with credentials

### File Protection Hook

**File:** `hooks/scripts/file-protection.sh`

| Permission | Required | Purpose |
|------------|----------|---------|
| Read stdin | Yes | Receive hook input |
| Write stdout | Yes | Return decision |
| Read files | No | Checks path only |
| Write files | Yes | Logs to `.claude/logs/` |
| Network | No | Runs locally only |

**What it blocks:**
- `.env` and `.env.*` files
- `.git/` directory contents
- Lock files (package-lock.json, yarn.lock, etc.)
- Key and certificate files (*.pem, *.key)
- Credentials files

## Agent Permissions

### Tool Access by Agent

| Agent | Read | Write | Edit | Bash | Grep | Glob | LSP | Task |
|-------|------|-------|------|------|------|------|-----|------|
| git-executor | ✓ | | | ✓ | ✓ | ✓ | | |
| code-reviewer | ✓ | | | | ✓ | ✓ | ✓ | |
| security-auditor | ✓ | | | ✓ | ✓ | ✓ | | |
| debugger | ✓ | | | ✓ | ✓ | ✓ | ✓ | |
| docs-writer | ✓ | ✓ | | | ✓ | ✓ | | |
| test-runner | ✓ | | | ✓ | ✓ | ✓ | | |
| orchestrator | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | | ✓ |
| refactorer | ✓ | ✓ | ✓ | | ✓ | ✓ | ✓ | |
| test-architect | ✓ | ✓ | | ✓ | ✓ | ✓ | | |

### Why These Permissions?

**git-executor:**
- Read: Check git status, log, diff
- Bash: Execute git commands (output only recommended)
- No Write/Edit: Should not modify code

**code-reviewer:**
- Read: Analyze code
- LSP: Get type information
- No Write: Should not modify, only review

**security-auditor:**
- Bash: Run security tools (npm audit, etc.)
- Grep/Glob: Search for patterns

**orchestrator:**
- All tools: Needs to coordinate other agents
- Task: Delegates to sub-agents

## File Access Patterns

### Sensitive Files (Blocked by Hooks)

```
.env                 # Environment variables
.env.local           # Local overrides
.env.production      # Production secrets
*.pem                # Certificates
*.key                # Private keys
.git/*               # Git internals
*lock.json           # Lock files
*lock.yaml           # Lock files
credentials.json     # Cloud credentials
secrets.json         # Application secrets
```

### Protected Directories

```
.git/                # Git repository data
node_modules/        # Dependencies (via .gitignore)
__pycache__/         # Python cache
.pytest_cache/       # Pytest cache
dist/                # Build output
build/               # Build output
```

## Security Best Practices

### For Users

1. **Review hook output:** Check `.claude/logs/` for blocked operations
2. **Never disable security hooks** without understanding why
3. **Keep secrets in .env:** And ensure .env is gitignored
4. **Review agent suggestions:** Especially for git operations

### For Contributors

1. **Test hooks locally:** Before pushing hook changes
2. **Don't expand permissions:** Without security review
3. **Log all blocks:** Security decisions should be auditable
4. **Fail closed:** On error, block rather than allow

## Customizing Permissions

### Disabling a Hook

Edit `hooks/hooks.json`:
```json
{
  "hooks": [
    {
      "name": "security-scan",
      "enabled": false  // Disable this hook
    }
  ]
}
```

### Adding Protected Patterns

Edit `hooks/hooks.json`:
```json
{
  "protectedPatterns": [
    ".env",
    "custom-secret-file.json"  // Add custom pattern
  ]
}
```

### Adding Secret Patterns

Edit `hooks/hooks.json`:
```json
{
  "secretPatterns": [
    "my_custom_api_[a-z0-9]{32}"  // Add custom regex
  ]
}
```

## Audit Log

Hook decisions are logged to `.claude/logs/`:

```
.claude/logs/
├── security-scan.log      # Secret detection events
└── file-protection.log    # File protection events
```

Log format:
```
[2024-01-15T10:30:00Z] [INFO] PASSED: src/utils/helpers.ts
[2024-01-15T10:30:05Z] [CRITICAL] BLOCKED: Found 1 secret(s) in src/config.ts
```

## Incident Response

### If a Secret is Committed

1. **Revoke the secret immediately**
2. **Remove from git history:**
   ```bash
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch path/to/secret" \
     --prune-empty --tag-name-filter cat -- --all
   ```
3. **Force push** (if already pushed)
4. **Rotate all credentials** that may have been exposed
5. **Review logs** for any unauthorized access

### If Hook is Bypassed

1. **Check how it was bypassed**
2. **Fix the bypass vector**
3. **Review all commits** made during bypass window
4. **Add regression test** for the bypass

## Contact

For security issues, please email the repository owner rather than opening a public issue.
