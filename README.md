# Claude Superpowers 🚀

A collection of custom skills, workflows, and techniques to supercharge Claude Code for autonomous development.

---

## What's Inside

### 📁 Skills
Custom Claude Code skills that provide specialized methodologies:

| Skill | Purpose |
|-------|---------|
| [production-readiness](./skills/production-readiness/) | Comprehensive codebase auditing with standardized scoring |
| [claude-code-optimizer](./skills/claude-code-optimizer/) | EPCC workflow pattern for structured development |
| [sprint-orchestrator](./skills/sprint-orchestrator/) | Task management and progress tracking |

### 📁 Workflows
Autonomous development patterns and scripts:

| Workflow | Purpose |
|----------|---------|
| [Ralph Loop](./workflows/ralph-loop/) | Autonomous iterative development loop (bash workaround for broken plugin) |

---

## Quick Start

### Installing Skills

Copy skills to your project's `.claude/skills/` directory:

```bash
# Clone this repo
git clone https://github.com/mjohnson518/claude_superpowers.git

# Copy skills to your project
cp -r claude_superpowers/skills/* /path/to/your/project/.claude/skills/
```

Or copy individual skills:

```bash
cp -r claude_superpowers/skills/production-readiness /path/to/your/project/.claude/skills/
```

### Using the Ralph Loop

```bash
# Copy the workflow files
cp claude_superpowers/workflows/ralph-loop/ralph-loop.sh /path/to/your/project/
cp claude_superpowers/workflows/ralph-loop/PROMPT_TEMPLATE.md /path/to/your/project/.claude/RALPH_PROMPT.md

# Edit the prompt for your task
nano /path/to/your/project/.claude/RALPH_PROMPT.md

# Run the loop
cd /path/to/your/project
chmod +x ralph-loop.sh
./ralph-loop.sh 50
```

---

## Skills Deep Dive

### production-readiness

A comprehensive audit framework that evaluates codebases across 15 dimensions:

- Security vulnerabilities
- Code quality
- Test coverage
- Documentation
- CI/CD maturity
- And more...

Produces a numerical score (0-100) and prioritized remediation plan.

### claude-code-optimizer

The EPCC (Explore → Plan → Code → Commit) workflow pattern:

- **Explore:** Understand current state
- **Plan:** Design the solution
- **Code:** Implement and test
- **Commit:** Document changes (without executing git)

Also includes context management strategies for long sessions.

### sprint-orchestrator

Task management for iterative development:

- Progress tracking format
- Blocker documentation
- Iteration state management
- Prioritization methodology

---

## Workflows Deep Dive

### Ralph Loop

The official `ralph-wiggum` Claude Code plugin is broken (see [documented issues](./workflows/ralph-loop/README.md#why-the-plugin-doesnt-work)). This bash script provides a working alternative.

**Key features:**
- Actually works (unlike the plugin)
- Ctrl+C to stop (unlike `/cancel-ralph`)
- No session hijacking
- Full visibility into what's happening

See [workflows/ralph-loop/README.md](./workflows/ralph-loop/README.md) for complete documentation.

---

## Contributing

Found a useful skill or workflow? PRs welcome!

1. Fork the repo
2. Add your skill to `skills/` or workflow to `workflows/`
3. Include a `SKILL.md` (for skills) or `README.md` (for workflows)
4. Submit a PR

---

## License

MIT

---

## Credits

- **Ralph Wiggum Technique:** [Geoffrey Huntley](https://x.com/GeoffreyHuntley)
- **Claude Code:** [Anthropic](https://github.com/anthropics)
- Inspired by **Boris Chern's X post**: https://x.com/bcherny/status/2004887829252317325
