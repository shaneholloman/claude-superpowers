# Claude Code Skills

Custom skills that extend Claude Code's capabilities with specialized methodologies.

---

## What Are Skills?

Skills are instruction sets that Claude Code reads and follows. Each skill contains:

- **SKILL.md** - The main instruction file (required)
- **references/** - Supporting documentation (optional)

When you tell Claude to "use the production-readiness skill," it reads the SKILL.md file and applies that methodology.

---

## Available Skills

| Skill | Description |
|-------|-------------|
| [production-readiness](./production-readiness/) | Comprehensive codebase auditing with standardized 0-100 scoring |
| [claude-code-optimizer](./claude-code-optimizer/) | EPCC workflow pattern (Explore → Plan → Code → Commit) |
| [sprint-orchestrator](./sprint-orchestrator/) | Task management and iteration progress tracking |

---

## Installing Skills

### To Your Project

Copy the skill folders to your project's `.claude/skills/` directory:

```bash
# All skills
cp -r * /path/to/your/project/.claude/skills/

# Single skill
cp -r production-readiness /path/to/your/project/.claude/skills/
```

### Verify Installation

```bash
ls /path/to/your/project/.claude/skills/
# Should show: production-readiness/  claude-code-optimizer/  sprint-orchestrator/
```

---

## Using Skills in Prompts

Reference skills in your Claude Code prompts:

```markdown
You MUST use these skills throughout this task:
1. production-readiness skill - For conducting the audit
2. claude-code-optimizer skill - For EPCC workflow

Read each skill's SKILL.md before starting.
```

---

## Creating Your Own Skills

1. Create a folder: `skills/your-skill-name/`
2. Add `SKILL.md` with your instructions
3. Optionally add `references/` for supporting docs

### SKILL.md Template

```markdown
---
name: your-skill-name
version: 1.0.0
description: "What this skill does"
---

# Your Skill Name

## Overview
[What this skill provides]

## Methodology
[Step-by-step approach]

## Output Format
[What deliverables to create]
```

---

## Contributing

Have a useful skill? Submit a PR!

1. Create your skill folder with SKILL.md
2. Test it in a real project
3. Add to this repo
