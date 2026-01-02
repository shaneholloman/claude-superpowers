#!/bin/bash
# File Protection Hook
# Prevents modification of sensitive files like .env, .git, and lock files

set -euo pipefail

# Log directory
LOG_DIR="${PWD}/.claude/logs"
LOG_FILE="${LOG_DIR}/file-protection.log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Protected file patterns
PROTECTED_PATTERNS=(
    "^\.env$"
    "^\.env\."
    "\.pem$"
    "\.key$"
    "^\.git/"
    "package-lock\.json$"
    "yarn\.lock$"
    "pnpm-lock\.yaml$"
    "Cargo\.lock$"
    "poetry\.lock$"
    "Gemfile\.lock$"
    "composer\.lock$"
    "^credentials\.json$"
    "^secrets\.json$"
    "^\.npmrc$"
    "^\.pypirc$"
)

log_event() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

is_protected() {
    local file_path="$1"

    for pattern in "${PROTECTED_PATTERNS[@]}"; do
        if echo "$file_path" | grep -qE "$pattern"; then
            return 0
        fi
    done

    return 1
}

main() {
    # Read JSON input from stdin
    local input
    input=$(cat)

    # Extract file path using simple parsing (jq alternative)
    local file_path
    file_path=$(echo "$input" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/' || echo "")

    if [[ -z "$file_path" ]]; then
        # No file path, allow
        echo '{"decision": "allow"}'
        exit 0
    fi

    # Make path relative for pattern matching
    local relative_path
    relative_path=$(echo "$file_path" | sed "s|^${PWD}/||")

    if is_protected "$relative_path"; then
        log_event "BLOCKED" "Attempted modification of protected file: $relative_path"

        cat << EOF
{
  "decision": "block",
  "message": "
=====================================
FILE PROTECTION: BLOCKED
=====================================

Protected file: $relative_path

This file is protected from modification:
  - .env files contain secrets
  - .git/ contains repository internals
  - Lock files should be managed by package managers
  - Key/certificate files are sensitive

If you need to modify this file:
  1. Edit it manually outside of Claude
  2. Or remove protection in hooks.json

=====================================
"
}
EOF
        exit 0
    fi

    log_event "ALLOWED" "File modification permitted: $relative_path"
    echo '{"decision": "allow"}'
    exit 0
}

main
