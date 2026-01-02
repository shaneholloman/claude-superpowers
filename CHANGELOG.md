# Changelog

All notable changes to claude-superpowers will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-01-02

### Added

#### Agents (9 total)
- **orchestrator** - Coordinate complex multi-step development tasks
- **code-reviewer** - Review code quality with 0-10 scoring system
- **security-auditor** - OWASP-based vulnerability detection
- **debugger** - Systematic bug investigation and root cause analysis
- **docs-writer** - Technical documentation generation
- **test-runner** - Test, lint, and build validation
- **git-executor** - Git operations with strict identity (Marc Johnson)
- **refactorer** - Code structure improvements without behavior changes
- **test-architect** - Comprehensive test strategy design

#### Commands (4 output styles)
- `/superpowers:architect` - System design and architecture mode
- `/superpowers:rapid` - Fast development mode
- `/superpowers:mentor` - Teaching and learning mode
- `/superpowers:review` - Code review mode

#### Skills (4 new, 7 total)
- **architecture-patterns** - Clean Architecture, DDD, microservices patterns
- **performance-optimization** - Profiling, caching, database optimization
- **api-design** - REST, GraphQL, and API best practices
- **project-analysis** - Codebase analysis and onboarding

#### Hooks (2 automation triggers)
- **security-scan** - Block secrets and credentials before commit
- **file-protection** - Protect .env, .git, and lock files

#### Documentation
- `ORCHESTRATION.md` - Agent pipeline and workflow documentation
- `PERMISSIONS.md` - Security model and hook permissions
- `MIGRATION_PLAN.md` - Integration planning document
- Updated `README.md` with all new features

#### Plugin Support
- `.claude-plugin/plugin.json` - Full plugin manifest for installation

### Changed
- Restructured repository for plugin compatibility
- Skills now use YAML frontmatter format for metadata

### Preserved
- **production-readiness** skill - 15-dimension audit (unchanged)
- **claude-code-optimizer** skill - EPCC workflow (unchanged)
- **sprint-orchestrator** skill - Task management (unchanged)
- **ralph-loop** workflow - Autonomous iteration (unchanged)

## [1.0.0] - 2025-12-29

### Added
- Initial release with 3 skills
- **production-readiness** - Comprehensive codebase audit
  - 15 critical dimensions
  - Python-based assessment scripts
  - 7 reference documents
- **claude-code-optimizer** - EPCC workflow pattern
  - Explore → Plan → Code → Commit methodology
  - Extended thinking triggers
  - Context management strategies
- **sprint-orchestrator** - Multi-project sprint management
  - Daily planning templates
  - Progress tracking
  - Project switch handoffs

### Added
- **ralph-loop** workflow
  - Bash script for autonomous iteration
  - Timing statistics
  - CLAUDE.md integration
  - Completion promise detection

---

## Versioning Notes

- **Major (X.0.0)**: Breaking changes, new major features
- **Minor (X.Y.0)**: New features, backward compatible
- **Patch (X.Y.Z)**: Bug fixes, documentation updates

## Migration Guides

### 1.x to 2.0

No breaking changes. Version 2.0 adds new components without modifying existing skills or workflows.

To use new features:
1. Reference new agents in your prompts
2. Use `/superpowers:mode` commands for output style
3. Enable hooks in `.claude/settings.json`
