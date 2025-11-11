# Phase 7 Completion Checklist

## Core Deliverables

### /uninstall Command
- [ ] Command file exists: `.claude/commands/uninstall.md`
- [ ] Routes to plugin-lifecycle skill correctly
- [ ] CLAUDE.md references /uninstall

### troubleshooting-docs Skill
- [ ] Skill file exists with frontmatter
- [ ] Dual-index file system (by-plugin + by-symptom)
- [ ] YAML schema validation enforced
- [ ] Auto-invoke triggers functional
- [ ] Resolution template used
- [ ] Cross-referencing works
- [ ] Symlinks created correctly

### deep-research Skill
- [ ] 3-level graduated protocol implemented
- [ ] Level 1: Local docs + Context7
- [ ] Level 2: Forums + GitHub
- [ ] Level 3: Parallel subagents + extended thinking
- [ ] Structured report format (JSON template)
- [ ] Integration with troubleshooter Level 4
- [ ] Integration with troubleshooting-docs capture

### design-sync Skill
- [ ] Skill file exists with frontmatter
- [ ] Drift detection logic implemented (quantitative + semantic)
- [ ] Decision menus present at all checkpoints
- [ ] Integration with ui-mockup Phase 4.5
- [ ] Contract comparison (brief ↔ parameter-spec) works
- [ ] Evolution documentation updates brief
- [ ] Override tracking to `.validator-overrides.yaml`

### plugin-improve Enhancements
- [ ] Regression testing (Phase 5.5) implemented
- [ ] Enhanced changelog generation (Technical section)
- [ ] Backup verification (Phase 0.9) functional
- [ ] Rollback mechanism works
- [ ] verify-backup.sh script created and executable

## Integration Tests

- [ ] Complete feedback loop test passed (Build → Test → Research → Improve → Document → Deploy)
- [ ] /uninstall removes plugin from system folders
- [ ] design-sync drift detection test passed
- [ ] deep-research Level 3 parallel investigation test passed
- [ ] troubleshooting-docs dual-indexing test passed
- [ ] plugin-improve regression detection test passed

## Documentation

- [ ] CLAUDE.md updated with Phase 7 components
- [ ] All 4 new skills have SKILL.md with frontmatter
- [ ] All new commands have .md files
- [ ] troubleshooting/ directory structure created
- [ ] verification/phase-7-checklist.md created (this file)

## Success Criteria (from ROADMAP.md)

- [ ] plugin-lifecycle handles complex installation scenarios
- [ ] design-sync validates mockup ↔ brief alignment
- [ ] deep-research performs parallel investigation
- [ ] troubleshooting-docs captures resolutions
- [ ] plugin-improve handles all version management scenarios
- [ ] `/improve TestPlugin` creates v1.1 with backup
- [ ] Regression tests catch breaking changes
- [ ] Knowledge base searchable and organized

## Architectural Alignment

- [ ] All 4 new skills follow Anthropic pattern (SKILL.md, references/, assets/)
- [ ] Interactive decision menus at all checkpoints
- [ ] Progressive disclosure (features discovered through use)
- [ ] Contracts referenced where relevant (design-sync)
- [ ] State machine transitions respected
- [ ] Model selection appropriate (Opus for deep-research L3)
- [ ] Error recovery presents 4 options

## Performance Budgets

- [ ] /uninstall: < 3 min
- [ ] design-sync validation: < 5 min
- [ ] deep-research Level 1: < 10 min
- [ ] deep-research Level 2: < 20 min
- [ ] deep-research Level 3: < 65 min
- [ ] troubleshooting-docs capture: < 3 min
- [ ] plugin-improve regression tests: < 10 min

---

**Phase 7 Status:** [COMPLETE / IN PROGRESS / BLOCKED]
**Completion Date:** [YYYY-MM-DD]
**Verified By:** [Name]
