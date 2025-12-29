# Ralph Loop Workflow

> A bash script workaround for the broken `ralph-wiggum` Claude Code plugin.

---

## What is the Ralph Wiggum Technique?

The Ralph Wiggum technique, originally conceived by Geoffrey Huntley, is an autonomous AI development loop where Claude Code iteratively works on a task until completion criteria are met. Named after the Simpsons character (because "it keeps trying even when it probably shouldn't"), the technique works by:

1. Giving Claude a task with clear completion criteria
2. Re-feeding the same prompt after each response
3. Allowing Claude to see its previous work (modified files, git history)
4. Continuing until a "completion promise" is output or max iterations reached

**Real-world results:** YC hackathon teams have shipped 6+ repositories overnight using this technique.

---

## Why the Plugin Doesn't Work

Anthropic released an official `ralph-wiggum` plugin for Claude Code, but as of December 2025 (v2.0.76+), it's fundamentally broken:

| GitHub Issue | Problem |
|--------------|---------|
| [#50](https://github.com/anthropics/claude-plugins-official/issues/50), [#69](https://github.com/anthropics/claude-plugins-official/issues/69) | Multi-line bash blocked by security check |
| [#66](https://github.com/anthropics/claude-plugins-official/issues/66), [#67](https://github.com/anthropics/claude-plugins-official/issues/67) | Markdown backticks cause parse errors |
| [#65](https://github.com/anthropics/claude-plugins-official/issues/65) | `/cancel-ralph` acknowledged but ignored |
| [#64](https://github.com/anthropics/claude-plugins-official/issues/64) | Stop hook hijacks ALL sessions |

A fix exists (PR #58) but hasn't been merged.

---

## The Bash Solution

### Features

| Feature | Description |
|---------|-------------|
| **Timing Stats** | Elapsed time, avg per iteration, estimated remaining |
| **CLAUDE.md Integration** | Automatically includes project context if present |
| **Completion Detection** | Stops when `<promise>` tag detected |
| **Safety Checks** | Stops if prompt file gets deleted |
| **Pretty Output** | Clear iteration headers with timestamps |

### How It Works

```
┌─────────────────────────────────────────────────────────┐
│                    ralph-loop.sh                        │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   while iterations < max:                               │
│       1. Read CLAUDE.md (if exists)                     │
│       2. Read .claude/RALPH_PROMPT.md                   │
│       3. Combine and pass to Claude                     │
│       4. Capture output, show timing stats              │
│       5. Check for completion promise                   │
│       6. If found → exit success                        │
│       7. If not → loop again                            │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Sample Output

```
╔═══════════════════════════════════════════════════════════╗
║           RALPH LOOP - Autonomous Development             ║
╚═══════════════════════════════════════════════════════════╝

Max iterations: 50
Prompt file: .claude/RALPH_PROMPT.md
CLAUDE.md: Found ✓
Started at: 2025-12-29 11:45:00
Press Ctrl+C to stop

═══════════════════════════════════════════════════════════
  ITERATION 3 / 50  •  12:02:15
───────────────────────────────────────────────────────────
├─ Elapsed: 00:17:15
├─ Avg per iteration: 00:05:45
├─ Est. remaining: 04:30:15
└─ Est. total: 04:47:30
═══════════════════════════════════════════════════════════

[Claude's output here...]

───────────────────────────────────────────────────────────
  Iteration 3 completed in 00:06:12
───────────────────────────────────────────────────────────
```

### Key Discovery

```bash
# This does NOT work (stdin not supported)
cat PROMPT.md | claude --print
# ERROR: Raw mode is not supported

# This DOES work (prompt as argument)
claude -p "$(cat PROMPT.md)"

# With permissions bypass for autonomous operation
claude -p --dangerously-skip-permissions "$(cat PROMPT.md)"
```

---

## Quick Start

### 1. Copy Files to Your Project

```bash
cp ralph-loop.sh /path/to/your/project/
cp PROMPT_TEMPLATE.md /path/to/your/project/.claude/RALPH_PROMPT.md
```

### 2. (Optional) Create CLAUDE.md

Run `/init` in Claude Code to generate a `CLAUDE.md` file, or create one manually:

```bash
# In your project directory, start Claude Code and run:
/init
```

The script will automatically include `CLAUDE.md` content if it exists.

### 3. Edit the Prompt

Customize `.claude/RALPH_PROMPT.md` for your task. Key sections:

- **Completion promise:** What Claude outputs when done
- **Files to KEEP:** Prevent accidental deletion of deliverables
- **Critical rules:** Your constraints (e.g., no git execution)

### 4. Run

```bash
cd /path/to/your/project
chmod +x ralph-loop.sh
./ralph-loop.sh 50  # 50 iterations max
```

### 5. Monitor

```bash
# Check if Claude is running (in another terminal)
ps aux | grep claude

# Stop the loop
Ctrl+C
```

---

## Files in This Workflow

| File | Purpose |
|------|---------|
| `ralph-loop.sh` | The loop script with timing stats |
| `PROMPT_TEMPLATE.md` | Template for your task prompt |
| `README.md` | This documentation |

---

## Prompt Design Tips

### Use "Ultrathink"

Start your prompt with "Ultrathink" to trigger extended thinking mode:

```markdown
Ultrathink and assess the project for production readiness.
```

### Protect Deliverables

Add deliverable files to the "keep" list so they don't get deleted:

```markdown
Files to KEEP (do not delete):
- AUDIT_REPORT.md (deliverable - DO NOT DELETE)
- PROGRESS.md (deliverable - DO NOT DELETE)
- GIT_COMMANDS.md (deliverable - DO NOT DELETE)
- .claude/RALPH_PROMPT.md (this prompt file - DO NOT DELETE)
- CLAUDE.md (project context - DO NOT DELETE)
```

### Store Prompt Safely

Put your prompt in `.claude/RALPH_PROMPT.md` — files in `.claude/` are less likely to be caught in cleanup operations.

### GIT_COMMANDS.md Append Rule

**Critical:** Claude tends to overwrite files. Add this to your prompt:

```markdown
## Critical Rules
3. APPEND to GIT_COMMANDS.md - NEVER overwrite or replace existing content
   - Read existing GIT_COMMANDS.md first
   - Add new commands under "## Iteration N" header
   - Preserve all previous iteration commands
```

### Clear Completion Criteria

```markdown
COMPLETION CRITERIA
When production-readiness score >= 90:
Output: <promise>TASK_COMPLETE</promise>

IF STUCK
Output: <promise>TASK_NEEDS_HELP</promise>
```

---

## Integrating with Skills

The ralph loop works best with custom skills. Reference them in your prompt:

```markdown
REQUIRED SKILLS - You MUST use these throughout this task:
1. production-readiness skill - For conducting the audit
2. claude-code-optimizer skill - For EPCC workflow
3. sprint-orchestrator skill - For progress tracking

Read each skill's SKILL.md before starting.
```

Skills should be in your project's `.claude/skills/` directory. See the [skills folder](../../skills/) for available skills.

---

## Troubleshooting

### "Raw mode is not supported"

You're trying to pipe input. Use argument form instead:

```bash
# Wrong
cat PROMPT.md | claude

# Right
claude -p "$(cat PROMPT.md)"
```

### "RALPH_PROMPT.md: No such file or directory"

Claude deleted your prompt during cleanup. Move it to `.claude/RALPH_PROMPT.md` and add it to "Files to KEEP" in the prompt itself.

### Loop Hangs (No Output)

Claude is waiting for permission approval. Add `--dangerously-skip-permissions`:

```bash
claude -p --dangerously-skip-permissions "$(cat $PROMPT_FILE)"
```

### GIT_COMMANDS.md Gets Overwritten Each Iteration

Add the append rule to your prompt's Critical Rules section:

```markdown
3. APPEND to GIT_COMMANDS.md - NEVER overwrite existing content
```

### Verifying Skills Are Loaded

Add this to your prompt:

```markdown
BEFORE DOING ANYTHING ELSE:
1. List the skills you found in .claude/skills/
2. Confirm you read each SKILL.md file
```

---

## Cost Considerations

| Iterations | Estimated Cost |
|------------|----------------|
| 10 | $15-25 |
| 25 | $40-70 |
| 50 | $75-150+ |

Start with fewer iterations for testing.

---

## Comparison: Plugin vs Bash Script

| Feature | Broken Plugin | Bash Script |
|---------|---------------|-------------|
| Actually runs | ❌ | ✅ |
| Cancel command | Broken | Ctrl+C works |
| Session isolation | Hijacks all | One terminal |
| macOS/zsh support | Parse errors | Works |
| Timing stats | ❌ | ✅ |
| CLAUDE.md integration | ❌ | ✅ |
| Customization | Limited | Full control |

---

## Credits

- **Ralph Wiggum Technique:** Geoffrey Huntley ([ghuntley.com/ralph](https://ghuntley.com/ralph/))
- **Bash Workaround:** Developed December 2025
