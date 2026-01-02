# Agent Orchestration Guide

## Overview

This document describes how the 9 agents in claude-superpowers work together to handle complex development tasks.

## Agent Summary

| Agent | Purpose | Primary Trigger |
|-------|---------|-----------------|
| `orchestrator` | Coordinate multi-step tasks | Complex features, "improve" |
| `git-executor` | Git operations | Commits, branches |
| `code-reviewer` | Quality assessment | Code changes, PRs |
| `security-auditor` | Vulnerability detection | Auth, data handling |
| `debugger` | Bug investigation | Errors, failures |
| `docs-writer` | Documentation | READMEs, API docs |
| `test-runner` | Test execution | Validation, CI |
| `refactorer` | Code improvement | Technical debt |
| `test-architect` | Test strategy | Coverage gaps |

## Agent Pipeline Flows

### Feature Implementation Flow

```
User Request
     │
     ▼
┌─────────────────┐
│  orchestrator   │  Plans the feature implementation
└────────┬────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌───────┐ ┌───────────────┐
│ Write │ │ test-architect│  Design tests
│ Code  │ └───────┬───────┘
└───┬───┘         │
    │             ▼
    │      ┌─────────────┐
    │      │ test-runner │  Run initial tests
    │      └──────┬──────┘
    │             │
    └──────┬──────┘
           ▼
    ┌─────────────────┐
    │  code-reviewer  │  Quality check
    └────────┬────────┘
             │
    ┌────────┴────────┐
    ▼                 ▼
┌───────────────┐ ┌─────────────────┐
│security-auditor│ │   docs-writer   │
└───────┬───────┘ └────────┬────────┘
        │                  │
        └────────┬─────────┘
                 ▼
         ┌─────────────┐
         │ git-executor│  Commit changes
         └─────────────┘
```

### Bug Fix Flow

```
Bug Report
     │
     ▼
┌─────────────┐
│  debugger   │  Investigate root cause
└──────┬──────┘
       │
       ▼
┌──────────────┐
│  Fix Code    │
└──────┬───────┘
       │
       ▼
┌─────────────┐
│ test-runner │  Verify fix
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│  code-reviewer  │  Review fix
└────────┬────────┘
         │
         ▼
┌─────────────┐
│ git-executor│  Commit
└─────────────┘
```

### Security Audit Flow

```
Audit Request
      │
      ▼
┌───────────────────┐
│  security-auditor │  Scan for vulnerabilities
└─────────┬─────────┘
          │
    ┌─────┴─────┐
    │ Findings? │
    └─────┬─────┘
          │ Yes
          ▼
    ┌───────────┐
    │  debugger │  Investigate each finding
    └─────┬─────┘
          │
          ▼
    ┌───────────────┐
    │ Fix Critical  │
    └───────┬───────┘
            │
            ▼
    ┌─────────────┐
    │ test-runner │  Verify fixes
    └──────┬──────┘
           │
           ▼
    ┌─────────────┐
    │ docs-writer │  Document security changes
    └──────┬──────┘
           │
           ▼
    ┌─────────────┐
    │ git-executor│  Commit
    └─────────────┘
```

### Refactoring Flow

```
Refactor Request
       │
       ▼
┌─────────────┐
│ test-runner │  Establish baseline
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  refactorer │  Improve code structure
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ test-runner │  Verify no regression
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│  code-reviewer  │  Review changes
└────────┬────────┘
         │
         ▼
┌─────────────┐
│ docs-writer │  Update documentation
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ git-executor│  Commit
└─────────────┘
```

## Agent Handoff Rules

### Always Before `git-executor`
- `test-runner` - Tests must pass
- `code-reviewer` - For significant changes
- `security-auditor` - For auth/data changes

### Quality Gates

| Gate | Required Agent | Blocking? |
|------|----------------|-----------|
| Pre-commit | `test-runner` | Yes |
| Security check | `security-auditor` | Yes for critical |
| Code review | `code-reviewer` | Yes if score < 7 |
| Documentation | `docs-writer` | No |

### Parallel Execution

These agents can run in parallel:
- `security-auditor` + `code-reviewer`
- `docs-writer` + `test-runner` (after implementation)
- `test-architect` + initial exploration

## Git Identity Configuration

**IMPORTANT**: The `git-executor` agent uses your locally configured git identity.

Configure before use:
```bash
git config user.name "Your Name"
git config user.email "your-email@example.com"
```

Commit message rules:
- Maximum 3 words
- Never mention Claude, AI, automated, generated

## Integration with Ralph Loop

When using `ralph-loop` workflow, agents are typically:
1. Referenced in the prompt template
2. Used by the orchestrator to delegate tasks
3. Called automatically based on trigger keywords

Example ralph-loop integration:
```markdown
REQUIRED AGENTS:
- Use orchestrator for task planning
- Use code-reviewer before committing
- Use security-auditor for any auth changes
```

## Agent Activation Keywords

| Agent | Trigger Phrases |
|-------|-----------------|
| orchestrator | "improve", "refactor codebase", "implement feature" |
| code-reviewer | "review code", "check quality", "before commit" |
| security-auditor | "security scan", "check vulnerabilities", "audit" |
| debugger | "bug", "error", "not working", "fix" |
| docs-writer | "document", "README", "API docs" |
| test-runner | "run tests", "validate", "check CI" |
| refactorer | "clean up", "technical debt", "simplify" |
| test-architect | "test strategy", "coverage", "what tests" |
| git-executor | "commit", "push", "create branch" |

## Troubleshooting

### Agent Not Triggering
1. Check if keywords match
2. Verify agent file exists in `agents/`
3. Check YAML frontmatter is valid

### Pipeline Stuck
1. Check for blocking failures
2. Review agent output for errors
3. Run `test-runner` to verify state

### Wrong Agent Activated
1. Be more specific in request
2. Mention agent by name
3. Use orchestrator for complex tasks
