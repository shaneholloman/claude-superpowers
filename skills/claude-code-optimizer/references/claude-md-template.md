# CLAUDE.md Template

Use this template for each project:

```markdown
# Project: [Name]

## Quick Start
```bash
npm install      # Install dependencies
npm run dev      # Start development
npm test         # Run tests
npm run lint     # Check style
```

## Code Style
- Language: [TypeScript/Rust/etc.]
- Framework: [Next.js/React/etc.]
- Linter: [ESLint/Clippy/etc.]
- Formatter: [Prettier/rustfmt/etc.]

## Architecture
```
src/
├── components/   # Purpose
├── hooks/        # Purpose
├── lib/          # Purpose
├── api/          # Purpose
└── types/        # Purpose
```

## Key Patterns
- Pattern 1: How it's used
- Pattern 2: How it's used

## Testing
- Framework: [Jest/Vitest/Foundry/etc.]
- Run: `npm test`
- Coverage: X% minimum

## Common Tasks

### Add Feature
1. Create component
2. Add tests
3. Update types

### Fix Bug
1. Write failing test
2. Fix bug
3. Verify test passes

## Git Workflow
All git commands output for manual execution only.
Never auto-commit or auto-push.

Branch naming: feature/[name], fix/[name]
Commit style: feat:, fix:, chore:, docs:

## Known Issues
- Issue 1: Status/workaround
- Issue 2: Status/workaround
```

## Session Management

### Starting Session
```
Read CLAUDE.md.
Read progress-[project]-latest.md if exists.
What should we work on?
```

### Ending Session
```
Create progress-[project]-[date].md with:
- Session summary
- Completed work
- Next steps
- Git commands to run
```
