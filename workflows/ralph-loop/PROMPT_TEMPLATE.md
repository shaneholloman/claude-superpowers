# Ralph Loop Prompt Template

> Copy this file to your project as `.claude/RALPH_PROMPT.md` and customize for your task.

---

Ultrathink and [DESCRIBE YOUR TASK HERE].

## Skills Check (Optional)
BEFORE DOING ANYTHING ELSE:
1. List the skills you found in .claude/skills/
2. Confirm you read each SKILL.md file
3. Summarize the key methodology from each skill in 1-2 sentences

## Required Skills (Optional)
If using custom skills, list them here:
1. production-readiness skill - For conducting audits and scoring
2. claude-code-optimizer skill - For EPCC workflow and context management
3. sprint-orchestrator skill - For task planning and progress tracking

Read each skill's SKILL.md before starting.

---

## Phase 0 - Setup/Cleanup (If Needed)

[Describe any initial setup or cleanup tasks]

### Files to KEEP (do not delete):
- AUDIT_REPORT.md (deliverable - DO NOT DELETE)
- PROGRESS.md (deliverable - DO NOT DELETE)
- GIT_COMMANDS.md (deliverable - DO NOT DELETE)
- .claude/RALPH_PROMPT.md (this prompt file - DO NOT DELETE)
- README.md
- [Add other important files]

### Files to DELETE (if doing cleanup):
- [List specific files or patterns]

---

## Phase 1 - Main Task

[Describe your main task in detail]

1. Step one
2. Step two
3. Step three

---

## Phase 2 - Iteration Work

For each iteration:
- Explore: [What to examine]
- Plan: [How to approach]
- Code: [What to implement]
- Commit: Add git commands to GIT_COMMANDS.md

After each fix:
1. Update PROGRESS.md with what was done
2. Update AUDIT_REPORT.md if tracking issues
3. Re-calculate any scores

---

## Deliverables

Update these files throughout:
- **AUDIT_REPORT.md**: [Purpose]
- **PROGRESS.md**: Running log of work done each iteration
- **GIT_COMMANDS.md**: All git commands for human to run locally
- **[Other files]**: [Purpose]

---

## Critical Rules

1. NEVER execute git commands - only write them to GIT_COMMANDS.md
2. ALL commit messages MUST be 3 words or less
3. [Add your own rules]

---

## Completion Criteria

When [YOUR SUCCESS CONDITION]:
1. Finalize all documentation
2. Ensure GIT_COMMANDS.md has all commits organized
3. Output: <promise>TASK_COMPLETE</promise>

## If Stuck

If you cannot make progress after multiple attempts:
- Document blockers in BLOCKERS.md
- List what was attempted
- Suggest what human needs to do
- Output: <promise>TASK_NEEDS_HELP</promise>
