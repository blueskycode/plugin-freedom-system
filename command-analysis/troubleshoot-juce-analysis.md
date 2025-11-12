# Command Analysis: troubleshoot-juce

## Executive Summary
- Overall health: **N/A (DEPRECATED)** (Command is marked deprecated in favor of deep-research skill)
- Critical issues: **0** (Not applicable - deprecated)
- Optimization opportunities: **1** (Complete removal or archival)
- Estimated context savings: **~400 tokens (100% reduction if removed)**

**Note:** This command is officially deprecated and replaced by the `deep-research` skill. The analysis below evaluates the current state, but the primary recommendation is archival or removal.

## Dimension Scores (1-5)

1. **Structure Compliance: 3/5** (Has frontmatter with name + description, but no argument-hint for the expected parameter)
2. **Routing Clarity: N/A** (Deprecated - no routing logic present)
3. **Instruction Clarity: 4/5** (Deprecation notice is clear, migration path documented)
4. **XML Organization: 1/5** (No XML structure, pure markdown prose)
5. **Context Efficiency: 5/5** (Only 53 lines, very lean)
6. **Claude-Optimized Language: 3/5** (Clear but not imperative - descriptive instead)
7. **System Integration: 3/5** (Documents related skills/commands, but no state files)
8. **Precondition Enforcement: N/A** (Deprecated - no preconditions)

**Adjusted Score (excluding N/A dimensions): 19/30**

## Critical Issues (blockers for Claude comprehension)

### Issue #1: Deprecated Command Still Listed in System (Lines 1-53)
**Severity:** MEDIUM (not CRITICAL since it's intentionally deprecated)
**Impact:** Adds 400 tokens to command context window on every session; appears in autocomplete; confuses users about which approach to use

**Current State:**
```markdown
---
name: troubleshoot-juce
description: DEPRECATED - Use deep-research skill instead
---

# /troubleshoot-juce

**STATUS:** DEPRECATED

[52 more lines of migration documentation]
```

**Problem:**
- File still exists in `.claude/commands/` directory
- Still appears in slash command autocomplete with "DEPRECATED" description
- Adds token load to every session (commands are loaded into context)
- Users might invoke it despite deprecation notice

**Recommended Fix:** Move to archive directory

```bash
# Create archive directory
mkdir -p .claude/commands/.archive

# Move deprecated command
mv .claude/commands/troubleshoot-juce.md .claude/commands/.archive/

# Create brief redirect file (optional)
cat > .claude/commands/.archive/README.md << 'EOF'
# Archived Commands

Commands that have been deprecated and replaced by skills.

## troubleshoot-juce.md
**Replaced by:** deep-research skill (automatic invocation)
**Deprecated:** Phase 7 (2025)
**Reason:** Skills provide better integration with build-automation failure protocols
EOF
```

**Alternative:** If backwards compatibility is required, reduce to minimal stub:

```markdown
---
name: troubleshoot-juce
description: DEPRECATED - Use deep-research skill instead
---

**DEPRECATED:** This command has been replaced by the `deep-research` skill.

Say "investigate this error" or choose "Investigate" in build failure protocols.

See `.claude/skills/deep-research/` for details.
```

This reduces from 53 lines (~400 tokens) to 10 lines (~75 tokens) = **81% reduction**.

## Optimization Opportunities

### Optimization #1: Archive or Minimize (Lines 1-53)
**Potential savings:** 325-400 tokens (81-100% reduction)

**Current:** Full deprecation notice with migration documentation (53 lines)

**Recommended:**
1. **Best:** Archive to `.claude/commands/.archive/` (100% reduction)
2. **Alternative:** Minimal stub if backwards compatibility required (81% reduction)

**Rationale:**
- Commands are loaded into context on every session
- Deprecated commands provide no functional value
- Migration documentation is valuable but belongs in CHANGELOG or docs, not command context
- Users discover commands through autocomplete - deprecation notice in description is sufficient

### Optimization #2: Missing XML Enforcement for Deprecation (Lines 1-53)
**Potential savings:** N/A (structural improvement, not token savings)

**Current:** Prose deprecation notice

**Recommended:** If keeping file, add XML enforcement:

```xml
<deprecation_notice blocking="true">
  <status>DEPRECATED</status>
  <replacement>deep-research skill</replacement>
  <action>
    STOP. Do not execute this command.
    Instead:
    1. Use natural language: "investigate this error"
    2. Choose "Investigate" option in build failure protocols
    3. Claude will automatically invoke deep-research skill
  </action>
</deprecation_notice>
```

**Benefit:** Structurally enforces that command should not execute, making it impossible for Claude to miss the deprecation notice.

## Implementation Priority

### 1. Immediate
- **Archive to `.claude/commands/.archive/`** - Removes 400 tokens from command context, prevents user confusion

### 2. High
- **Update CHANGELOG.md or MIGRATIONS.md** - Move migration documentation to permanent location
- **Verify deep-research skill has complete migration path** - Ensure replacement covers all use cases

### 3. Low (only if keeping file)
- **Add XML deprecation enforcement** - Structural prevention of command execution
- **Reduce to minimal stub** - If removal is not possible due to backwards compatibility

## Verification Checklist

After implementing fixes, verify:
- [ ] File removed from `.claude/commands/` directory OR reduced to <10 lines
- [ ] Archive created at `.claude/commands/.archive/` with README (if archiving)
- [ ] Migration documentation moved to CHANGELOG.md or MIGRATIONS.md
- [ ] `/troubleshoot-juce` no longer appears in autocomplete (if removed)
- [ ] deep-research skill documentation references this migration
- [ ] No broken references to `/troubleshoot-juce` in other files

## Additional Notes

### Why This Command Was Replaced

The command → skill migration reflects a key architectural principle:

**Commands** = Routing layers (user initiates)
**Skills** = Logic layers (Claude initiates when appropriate)

The troubleshooting workflow is better as a skill because:
1. **Automatic activation** - Claude can invoke during build failures without user knowing the command
2. **Contextual awareness** - Skill has access to current plugin, build output, error context
3. **Seamless integration** - Directly integrates with build-automation and troubleshooting-docs skills
4. **Discovery through use** - Users don't need to remember command syntax

This is the correct pattern: commands for user-initiated workflows (e.g., `/implement`, `/improve`), skills for Claude-initiated intelligence (e.g., deep-research, design-sync).

### Search for References

Before removing, verify no other files reference this command:

```bash
grep -r "troubleshoot-juce" .claude/ plugins/ prompts/ --include="*.md"
```

Expected results:
- `.claude/CLAUDE.md` - Lists command (should be removed from list)
- `.claude/commands/troubleshoot-juce.md` - This file
- Potentially skill documentation mentioning replacement

Update all references before archiving.

## Recommendation

**Primary action:** Archive the file immediately. Deprecated commands add token load with zero functional value.

**Secondary action:** Verify the deep-research skill provides complete coverage of the original troubleshooting protocol (3-level graduated depth search).

**Tertiary action:** Document the migration in project CHANGELOG for future reference.
