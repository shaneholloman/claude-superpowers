# Sprint Orchestrator Templates

## Sprint Configuration

```yaml
# sprint-config.yaml
sprint:
  name: "Sprint Name"
  start_date: "2025-01-01"
  end_date: "2025-01-15"
  daily_hours: 6

projects:
  - name: project-name
    repo: ~/projects/repo
    priority: 1
    tier: 1
    current_completion: 90
    target_completion: 100
    definition_of_done: "Criteria for completion"
```

## Full Context Handoff Template

```markdown
# Context Handoff: [From Project] → [To Project]

## Exiting: [From Project]

### Session Summary
- **Duration:** X hours
- **Focus:** What was worked on
- **Commits:** Number ready to push

### Current State
- Feature A: COMPLETE
- Feature B: IN PROGRESS (X%)
- Feature C: NOT STARTED

### Blockers
- Waiting for X

### Resume Instructions
1. Read progress-[project]-[date].md
2. Run test suite
3. Continue with [next task]

### Git Commands to Run
```bash
git add .
git commit -m "wip: description"
```

---

## Entering: [To Project]

### Last Session
- **Date:** When last worked
- **State:** Summary of status

### Today's Priorities
1. First priority task
2. Second priority task

### Setup Commands
```bash
cd ~/projects/[project]
git pull origin main
npm install
```
```

## Sprint Dashboard Template

```markdown
# Sprint Dashboard

## Overview
- **Day:** X of Y (Z% elapsed)
- **Projects:** A active, B complete, C blocked

## Status

| Project | Start | Current | Target | Status |
|---------|-------|---------|--------|--------|
| name    | X%    | Y%      | Z%     | ✅/⚠️/❌ |

## Risks
1. [Risk description]

## Decisions Needed
1. [Decision needed]
```
