# Claude Superpowers

Production-ready tools for autonomous development with Claude Code.

---

## What's Inside

| Component | Count | Description |
|-----------|-------|-------------|
| [Agents](#agents) | 9 | Specialized AI agents for different tasks |
| [Skills](#skills) | 7 | Methodology guides and knowledge domains |
| [Commands](#commands) | 4 | Output style modes |
| [Hooks](#hooks) | 2 | Automation triggers |
| [Workflows](#workflows) | 1 | Ralph Loop autonomous iteration |

---

## Quick Start

### Option 1: Plugin Installation

```bash
# Clone the repo
git clone https://github.com/mjohnson518/claude_superpowers.git

# Install as a plugin (coming soon)
claude plugins install ./claude_superpowers
```

### Option 2: Manual Copy

```bash
# Clone the repo
git clone https://github.com/mjohnson518/claude_superpowers.git

# Copy to your project's .claude directory
cp -r claude_superpowers/skills/* /path/to/your/project/.claude/skills/
cp -r claude_superpowers/agents/* /path/to/your/project/.claude/agents/
cp -r claude_superpowers/commands/* /path/to/your/project/.claude/commands/
cp -r claude_superpowers/hooks/* /path/to/your/project/.claude/hooks/
```

---

## Agents

Nine specialized agents for different development tasks:

| Agent | Purpose | Trigger Keywords |
|-------|---------|------------------|
| **orchestrator** | Coordinate complex multi-step tasks | "improve", "refactor", large features |
| **code-reviewer** | Quality assessment (0-10 scoring) | "review", "check quality", before commit |
| **security-auditor** | OWASP-based vulnerability detection | "security scan", "audit", auth changes |
| **debugger** | Root cause analysis | "bug", "error", "not working" |
| **docs-writer** | Documentation generation | "document", "README", "API docs" |
| **test-runner** | Test/lint/build validation | "run tests", "validate", "CI" |
| **git-executor** | Git operations | "commit", "branch", "push" |
| **refactorer** | Code structure improvement | "clean up", "technical debt" |
| **test-architect** | Test strategy design | "test strategy", "coverage" |

### Git Executor Identity

The `git-executor` agent enforces commit standards. **Configure your identity:**

```bash
# Set your git identity (required before first use)
git config user.name "Your Name"
git config user.email "your-email@example.com"
```

See [agents/ORCHESTRATION.md](./agents/ORCHESTRATION.md) for workflow diagrams.

---

## Skills

Seven methodology guides and knowledge domains:

### Core Skills (Existing)

| Skill | Purpose |
|-------|---------|
| **production-readiness** | 15-dimension production audit with scoring |
| **claude-code-optimizer** | EPCC workflow (Explore → Plan → Code → Commit) |
| **sprint-orchestrator** | Multi-project sprint management |

### New Skills

| Skill | Purpose |
|-------|---------|
| **architecture-patterns** | Clean Architecture, DDD, microservices |
| **performance-optimization** | Profiling, caching, bottleneck identification |
| **api-design** | REST, GraphQL, and API best practices |
| **project-analysis** | Codebase analysis and onboarding |

---

## Commands

Four output style modes to adjust Claude's behavior:

| Command | Mode | Use Case |
|---------|------|----------|
| `/superpowers:architect` | System design | Architecture decisions, design docs |
| `/superpowers:rapid` | Fast development | Prototyping, getting things working |
| `/superpowers:mentor` | Teaching | Learning, explanations, tutorials |
| `/superpowers:review` | Code review | Quality assessment, PR reviews |

---

## Hooks

Automation triggers for security and file protection:

### Security Scan Hook
- **Trigger:** Before Write/Edit operations
- **Action:** Blocks commits containing secrets, API keys, credentials
- **Patterns:** AWS keys, GitHub tokens, private keys, passwords

### File Protection Hook
- **Trigger:** Before Write/Edit operations
- **Action:** Prevents modification of sensitive files
- **Protected:** `.env`, `.git/`, lock files, `*.pem`, `*.key`

### Configuration

Hooks are configured in `hooks/hooks.json`. To disable:

```json
{
  "hooks": [
    {
      "name": "security-scan",
      "enabled": false
    }
  ]
}
```

Logs are written to `.claude/logs/`.

---

## Workflows

### Ralph Loop

Autonomous iterative development loop - a working alternative to the broken `ralph-wiggum` plugin.

**Features:**
- Timing statistics
- CLAUDE.md integration
- Completion promise detection
- Works with Ctrl+C (unlike the plugin)

**Quick Start:**

```bash
# Copy files to your project
cp workflows/ralph-loop/ralph-loop.sh /path/to/your/project/
cp workflows/ralph-loop/PROMPT_TEMPLATE.md /path/to/your/project/.claude/RALPH_PROMPT.md

# Edit the prompt
nano .claude/RALPH_PROMPT.md

# Run (50 iterations max)
./ralph-loop.sh 50
```

See [workflows/ralph-loop/README.md](./workflows/ralph-loop/README.md) for complete documentation.

---

## Repository Structure

```
claude_superpowers/
├── .claude-plugin/
│   └── plugin.json              # Plugin manifest
├── agents/
│   ├── ORCHESTRATION.md         # Agent pipeline docs
│   ├── git-executor.md
│   ├── code-reviewer.md
│   ├── security-auditor.md
│   ├── debugger.md
│   ├── docs-writer.md
│   ├── test-runner.md
│   ├── orchestrator.md
│   ├── refactorer.md
│   └── test-architect.md
├── commands/
│   ├── architect.md
│   ├── rapid.md
│   ├── mentor.md
│   └── review.md
├── hooks/
│   ├── hooks.json
│   └── scripts/
│       ├── security-scan.py
│       └── file-protection.sh
├── skills/
│   ├── production-readiness/
│   ├── claude-code-optimizer/
│   ├── sprint-orchestrator/
│   ├── architecture-patterns/
│   ├── performance-optimization/
│   ├── api-design/
│   └── project-analysis/
├── workflows/
│   └── ralph-loop/
├── CHANGELOG.md
├── MIGRATION_PLAN.md
├── PERMISSIONS.md
└── README.md
```

---

## Documentation

| Document | Purpose |
|----------|---------|
| [ORCHESTRATION.md](./agents/ORCHESTRATION.md) | Agent pipelines and workflows |
| [PERMISSIONS.md](./PERMISSIONS.md) | Security model and hook permissions |
| [CHANGELOG.md](./CHANGELOG.md) | Version history |
| [skills/README.md](./skills/README.md) | Skills overview and usage |

---

## Contributing

Found a useful skill, agent, or workflow? PRs welcome!

1. Fork the repo
2. Add your contribution
3. Include appropriate documentation
4. Submit a PR

### File Formats

**Agents:** Markdown with YAML frontmatter
```markdown
---
name: agent-name
description: What it does
tools: [Read, Write, Edit, Bash]
model: sonnet
---
```

**Skills:** `SKILL.md` with YAML frontmatter
```markdown
---
name: skill-name
description: What it provides
---
```

**Commands:** Markdown with YAML frontmatter
```markdown
---
name: superpowers:command-name
description: What mode it enables
---
```

---

## Requirements

- Claude Code v1.0.33+
- Git (for version control features)
- Python 3 (for security-scan hook)
- Bash (for hooks and ralph-loop)

---

## License

MIT

---

## Credits

- **Ralph Wiggum Technique:** [Geoffrey Huntley](https://x.com/GeoffreyHuntley)
- **Claude Code:** [Anthropic](https://github.com/anthropics)
- **CloudAI-X:** Inspired by [claude-workflow](https://github.com/CloudAI-X/claude-workflow)
- Inspired by **[Boris Chern's X post](https://x.com/bcherny/status/2004887829252317325)**
