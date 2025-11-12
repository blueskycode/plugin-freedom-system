# Fix Plan: /troubleshoot-juce

## Summary
- Critical fixes: **0** (Command is deprecated - archival only)
- Extraction operations: **0**
- Total estimated changes: **3 file operations**
- Estimated time: **5 minutes**
- Token savings: **400 tokens (100% reduction from command context)**

## Phase 1: Archival (Primary Recommendation)

### Fix 1.1: Archive Deprecated Command
**Location:** `.claude/commands/troubleshoot-juce.md` (entire file)
**Operation:** MOVE to archive directory
**Severity:** HIGH (token efficiency + user experience)

**Rationale:**
- Command is officially deprecated and replaced by `deep-research` skill
- Adds 400 tokens to every session despite zero functional value
- Appears in autocomplete, causing user confusion
- Migration path is complete and documented in deep-research skill

**File Operations:**

**Step 1: Create archive directory**
```bash
mkdir -p /Users/lexchristopherson/Developer/plugin-freedom-system/.claude/commands/.archive
```

**Step 2: Move deprecated command**
```bash
mv /Users/lexchristopherson/Developer/plugin-freedom-system/.claude/commands/troubleshoot-juce.md \
   /Users/lexchristopherson/Developer/plugin-freedom-system/.claude/commands/.archive/
```

**Step 3: Create archive README**
Create: `/Users/lexchristopherson/Developer/plugin-freedom-system/.claude/commands/.archive/README.md`

```markdown
# Archived Commands

Commands that have been deprecated and replaced by skills.

## troubleshoot-juce.md
**Replaced by:** deep-research skill (automatic invocation)
**Deprecated:** Phase 7 (2025-11)
**Reason:** Skills provide better integration with build-automation failure protocols

The troubleshooting workflow transitioned from user-initiated command to Claude-initiated skill because:
1. **Automatic activation** - Claude can invoke during build failures without user knowing the command
2. **Contextual awareness** - Skill has access to current plugin, build output, error context
3. **Seamless integration** - Directly integrates with build-automation and troubleshooting-docs skills
4. **Discovery through use** - Users don't need to remember command syntax

To troubleshoot JUCE build issues:
- Say "investigate this error" or "research this problem"
- Choose "Investigate" option in build failure decision menus
- Claude will automatically invoke the deep-research skill
```

**Verification:**
- [ ] Command removed from `.claude/commands/` directory
- [ ] Archive directory created at `.claude/commands/.archive/`
- [ ] Archive README documents replacement and migration path
- [ ] `/troubleshoot-juce` no longer appears in command autocomplete
- [ ] Token count reduced by ~400 tokens in command context

**Token impact:** -400 tokens (100% reduction)

### Fix 1.2: Remove Command from CLAUDE.md Reference List
**Location:** `.claude/CLAUDE.md` (exact line TBD - search for "troubleshoot-juce")
**Operation:** DELETE
**Severity:** HIGH (documentation accuracy)

**Find and remove this line:**
```markdown
- /troubleshoot-juce: DEPRECATED - Use deep-research skill instead (project)
```

**Or update to reference archive:**
```markdown
- /research [topic]: Deep investigation (3-level protocol) (project)
```

**Verification:**
- [ ] No references to `/troubleshoot-juce` in `.claude/CLAUDE.md`
- [ ] `deep-research` skill is documented as the replacement
- [ ] No broken links or outdated instructions

**Token impact:** -30 tokens (documentation cleanup)

### Fix 1.3: Verify No Other References
**Location:** Project-wide
**Operation:** SEARCH and UPDATE/REMOVE
**Severity:** MEDIUM (prevent broken references)

**Search command:**
```bash
cd /Users/lexchristopherson/Developer/plugin-freedom-system
grep -r "troubleshoot-juce" .claude/ plugins/ prompts/ scripts/ --include="*.md" --include="*.sh"
```

**Expected results:**
- `.claude/CLAUDE.md` - Should be removed (see Fix 1.2)
- `.claude/commands/.archive/troubleshoot-juce.md` - Archived file (expected)
- `.claude/skills/deep-research/SKILL.md` - May reference replacement (OK to keep)

**Action for each match:**
- If instructing users to run `/troubleshoot-juce` → Update to reference `deep-research` skill
- If mentioning command in historical context → Add "(deprecated, archived)" note
- If linking to command file → Remove link or redirect to archive

**Verification:**
- [ ] All references searched and catalogued
- [ ] User-facing instructions updated to reference skill instead
- [ ] No broken links or outdated workflows
- [ ] Historical references clearly marked as deprecated

**Token impact:** Variable (depends on references found)

## Phase 2: Alternative Approach (If Archival Not Possible)

**Note:** Only implement if backwards compatibility or user transition period requires keeping the file.

### Alternative Fix 2.1: Reduce to Minimal Stub
**Location:** `.claude/commands/troubleshoot-juce.md` (entire file)
**Operation:** REPLACE entire content
**Severity:** HIGH (token efficiency)

**Before:** 53 lines (~400 tokens)

**After:**
```yaml
---
name: troubleshoot-juce
description: DEPRECATED - Use deep-research skill instead
---

<deprecation_notice blocking="true">
  <status>DEPRECATED</status>
  <replacement>deep-research skill</replacement>
  <action>
STOP. Do not execute this command.

Instead:
1. Say "investigate this error" or "research this problem"
2. Choose "Investigate" option in build failure menus
3. Claude will automatically invoke the deep-research skill

See .claude/skills/deep-research/ for documentation.
  </action>
</deprecation_notice>
```

**Verification:**
- [ ] File reduced from 53 lines to 18 lines
- [ ] XML blocking structure prevents command execution
- [ ] Clear migration path provided
- [ ] Token count reduced by 325 tokens (81% reduction)

**Token impact:** -325 tokens (81% reduction)

## Special Instructions

### Architecture Context: Command → Skill Migration

This deprecation reflects a key architectural principle in the Plugin Freedom System:

**Commands = Routing layers** (user-initiated workflows)
- `/implement`, `/improve`, `/dream`, `/setup`
- User types the slash command to start a workflow
- Commands invoke skills for implementation

**Skills = Intelligence layers** (Claude-initiated logic)
- `deep-research`, `design-sync`, `plugin-workflow`
- Claude invokes when contextually appropriate
- No user knowledge of command syntax required

The troubleshooting workflow was migrated from command to skill because:
1. **Automatic activation** - Claude detects build failures and offers investigation
2. **Contextual awareness** - Skill reads error logs, plugin state, build output automatically
3. **Seamless integration** - Directly chains with `build-automation` and `troubleshooting-docs` skills
4. **Better UX** - Users say "investigate this" instead of remembering `/troubleshoot-juce`

This is the correct pattern. Commands should route to workflows; skills should contain the intelligence.

### Verification: Deep-Research Skill Coverage

Before archiving `/troubleshoot-juce`, verify the replacement skill provides complete coverage:

**Check:** `/Users/lexchristopherson/Developer/plugin-freedom-system/.claude/skills/deep-research/SKILL.md`

**Required capabilities:**
- [ ] 3-level graduated depth protocol (Quick → Moderate → Deep)
- [ ] Parallel sub-agent investigation
- [ ] Integration with troubleshooting knowledge base
- [ ] Automatic invocation from build failure protocols
- [ ] JUCE API search and documentation retrieval
- [ ] Pattern matching against juce8-critical-patterns.md

**If any capability is missing:** Update deep-research skill before archiving command.

### Migration Documentation

After archival, document the change:

**Location:** `/Users/lexchristopherson/Developer/plugin-freedom-system/CHANGELOG.md` or create `/Users/lexchristopherson/Developer/plugin-freedom-system/MIGRATIONS.md`

**Entry:**
```markdown
## 2025-11-12 - Command Deprecations

### /troubleshoot-juce → deep-research skill

**Reason:** Command-to-skill migration for better integration

**Breaking change:** `/troubleshoot-juce` command removed from autocomplete

**Migration path:**
- Old: User runs `/troubleshoot-juce` to investigate errors
- New: User says "investigate this error" or chooses "Investigate" in build failure menus
- Claude automatically invokes deep-research skill with full context

**Benefits:**
- Automatic activation during build failures
- No command syntax to remember
- Better integration with build-automation protocols
- 400 token reduction in command context

**Archived location:** `.claude/commands/.archive/troubleshoot-juce.md`
```

## File Operations Manifest

**Directories to create:**
1. `/Users/lexchristopherson/Developer/plugin-freedom-system/.claude/commands/.archive/` - Archive directory for deprecated commands

**Files to create:**
1. `/Users/lexchristopherson/Developer/plugin-freedom-system/.claude/commands/.archive/README.md` - Archive documentation (see Fix 1.1 Step 3)

**Files to move:**
1. `/Users/lexchristopherson/Developer/plugin-freedom-system/.claude/commands/troubleshoot-juce.md` → `/Users/lexchristopherson/Developer/plugin-freedom-system/.claude/commands/.archive/troubleshoot-juce.md`

**Files to modify:**
1. `/Users/lexchristopherson/Developer/plugin-freedom-system/.claude/CLAUDE.md` - Remove `/troubleshoot-juce` from command list (see Fix 1.2)
2. Any other files found by grep search (see Fix 1.3)

**Files to verify:**
1. `/Users/lexchristopherson/Developer/plugin-freedom-system/.claude/skills/deep-research/SKILL.md` - Verify complete coverage before archiving

## Execution Checklist

**Phase 1 (Archival - Primary Path):**
- [ ] Archive directory created: `.claude/commands/.archive/`
- [ ] Archive README created with migration documentation
- [ ] Command file moved to archive
- [ ] Command removed from `.claude/CLAUDE.md` reference list
- [ ] Project-wide search for references completed
- [ ] All references updated or removed
- [ ] Deep-research skill coverage verified
- [ ] Migration documented in CHANGELOG or MIGRATIONS.md

**Phase 2 (Stub - Alternative Path):**
- [ ] Command file reduced from 53 lines to 18 lines
- [ ] XML deprecation structure implemented
- [ ] Migration path clearly documented
- [ ] Token count reduced by 81%

**Final Verification:**
- [ ] `/troubleshoot-juce` no longer appears in autocomplete (if archived)
- [ ] OR `/troubleshoot-juce` shows deprecation notice (if stubbed)
- [ ] No broken references in any files
- [ ] Deep-research skill fully functional
- [ ] Users can successfully investigate issues via natural language
- [ ] Token savings confirmed in next session

## Estimated Impact

**Before:**
- Health score: N/A (deprecated)
- Line count: 53 lines
- Token count: ~400 tokens
- Functional value: 0 (deprecated)

**After (Primary Path - Archival):**
- Health score: N/A (removed from command context)
- Line count: 0 lines (archived)
- Token count: 0 tokens (removed from context)
- Functional value: 0 (replaced by skill)

**After (Alternative Path - Stub):**
- Health score: N/A (deprecated)
- Line count: 18 lines
- Token count: ~75 tokens
- Functional value: 0 (blocks execution, redirects to skill)

**Primary Path Improvement:** -400 tokens (100% reduction)
**Alternative Path Improvement:** -325 tokens (81% reduction)

## Recommendation

**Execute Phase 1 (Archival)** as the primary path.

The command is fully deprecated with a complete replacement. There is zero functional value in keeping it in the active command directory. Archival:
1. Reduces token load by 400 tokens per session
2. Prevents user confusion from deprecated autocomplete entries
3. Preserves historical documentation in archive
4. Aligns with command-to-skill migration architecture

Only implement Phase 2 (Stub) if backwards compatibility absolutely requires a transition period, but even then, schedule archival within 30 days.
