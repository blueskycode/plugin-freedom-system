# Fix Plan: /reset-to-ideation

## Summary
- Critical fixes: **3** (precondition enforcement, frontmatter, routing XML)
- Extraction operations: **2** (confirmation example, success output)
- Total estimated changes: **5**
- Estimated time: **66 minutes**
- Token savings: **~300 tokens (30% reduction)**

## Phase 1: Critical Fixes (Blocking Issues)

### Fix 1.1: Add XML Precondition Enforcement (Missing)
**Location:** Insert after line 13 (before line 15)
**Operation:** INSERT
**Severity:** CRITICAL

**Before:**
```markdown
## Behavior

When user runs `/reset-to-ideation [PluginName]`, invoke the plugin-lifecycle skill with mode: 'reset'.
```

**After:**
```markdown
## Behavior

<preconditions enforcement="blocking">
  <check target="PLUGINS.md" condition="plugin_exists">
    Plugin entry MUST exist in PLUGINS.md

    <on_failure action="BLOCK">
      Display error: "[PluginName] not found in PLUGINS.md.

      Run /dream to create a new plugin idea first."
    </on_failure>
  </check>

  <check target="status" condition="has_implementation">
    Status MUST NOT be 💡 Ideated (nothing to reset)

    <valid_states>
      ✅ Working, 📦 Installed, 🚧 Stage N (N ≥ 2)
    </valid_states>

    <on_failure action="BLOCK">
      Display error: "[PluginName] is already at ideation stage (💡 Ideated).

      Nothing to reset - run /implement [PluginName] to start implementation."
    </on_failure>
  </check>

  <check target="ideation_artifacts" condition="preservable_content_exists" severity="warning">
    At least one ideation artifact MUST exist to preserve

    <required_files>
      - .ideas/creative-brief.md OR
      - .ideas/mockups/*.html OR
      - .ideas/parameter-spec.md
    </required_files>

    <on_failure action="WARN">
      Display warning: "⚠️  No ideation artifacts found to preserve.

      This will delete the plugin entirely. Consider /destroy instead."
    </on_failure>
  </check>
</preconditions>

When user runs `/reset-to-ideation [PluginName]`, invoke the plugin-lifecycle skill with mode: 'reset'.
```

**Verification:**
- [ ] Preconditions block execution if plugin doesn't exist
- [ ] Preconditions block if plugin already at ideation stage
- [ ] Warning displayed if no ideation artifacts exist
- [ ] XML structure is valid and properly nested

**Token impact:** +450 tokens (precondition enforcement)

### Fix 1.2: Frontmatter Correction (Line 4)
**Location:** Line 4
**Operation:** REPLACE
**Severity:** CRITICAL

**Before:**
```yaml
args: "[PluginName]"
```

**After:**
```yaml
argument-hint: "[PluginName]"
```

**Verification:**
- [ ] YAML frontmatter parses correctly
- [ ] `/help` displays command with description
- [ ] Autocomplete shows argument hint

**Token impact:** +5 tokens (frontmatter standard compliance)

### Fix 1.3: Wrap Routing Logic in XML (Line 15)
**Location:** Line 15
**Operation:** WRAP
**Severity:** MEDIUM

**Before:**
```markdown
When user runs `/reset-to-ideation [PluginName]`, invoke the plugin-lifecycle skill with mode: 'reset'.
```

**After:**
```markdown
<routing_logic>
  <trigger>User invokes /reset-to-ideation [PluginName]</trigger>

  <sequence>
    <step order="1">Verify preconditions (block if failed)</step>
    <step order="2" required="true">
      Invoke plugin-lifecycle skill via Skill tool:

      Parameters:
      - plugin_name: $ARGUMENTS
      - mode: 'reset'
    </step>
  </sequence>

  <skill_reference>
    Implementation: .claude/skills/plugin-lifecycle/references/mode-3-reset.md
  </skill_reference>
</routing_logic>
```

**Verification:**
- [ ] Routing sequence clearly defined
- [ ] Skill invocation parameters explicit
- [ ] Reference to skill implementation included
- [ ] XML structure survives context compression

**Token impact:** +80 tokens (routing clarity)

## Phase 2: Content Extraction (Token Reduction)

### Fix 2.1: Extract Confirmation Example (Lines 36-58)
**Location:** Lines 36-58
**Operation:** EXTRACT
**Severity:** HIGH (token efficiency)

**Extract to:** `.claude/skills/plugin-lifecycle/assets/reset-confirmation-example.txt`

**File content:**
```
⚠️  Rolling back to ideation stage

Will REMOVE:
- Source code: plugins/[PluginName]/Source/ (47 files)
- Build config: plugins/[PluginName]/CMakeLists.txt
- Implementation docs: architecture.md, plan.md
- Binaries: VST3 + AU (if installed)
- Build artifacts

Will PRESERVE:
- Idea: creative-brief.md
- Mockups: 2 versions (v1-ui, v2-ui)
- Parameters: parameter-spec.md

A backup will be created in backups/rollbacks/

Status will change: [Current] → 💡 Ideated

Continue? (y/N): _
```

**Replace with in command (Lines 36-58):**
```markdown
## User Confirmation

The plugin-lifecycle skill will present interactive confirmation showing:
- Files to be removed (Source/, CMakeLists.txt, implementation docs, binaries)
- Files to be preserved (creative-brief, mockups, parameter-spec)
- Backup location (backups/rollbacks/)
- Status transition ([Current] → 💡 Ideated)

See [plugin-lifecycle assets/reset-confirmation-example.txt](../.skills/plugin-lifecycle/assets/reset-confirmation-example.txt) for sample output.
```

**Verification:**
- [ ] Asset file created at correct path
- [ ] Command references asset file
- [ ] Line count reduced by ~15 lines
- [ ] Functionality preserved (progressive disclosure)

**Token impact:** -200 tokens

### Fix 2.2: Extract Success Output Example (Lines 60-86)
**Location:** Lines 60-86
**Operation:** EXTRACT
**Severity:** HIGH (token efficiency)

**Extract to:** `.claude/skills/plugin-lifecycle/assets/reset-success-example.txt`

**File content:**
```
✓ [PluginName] reset to ideation stage

Removed:
- Source code: 47 files
- Build configuration: CMakeLists.txt
- Implementation docs: architecture.md, plan.md
- Binaries: VST3 + AU (uninstalled)
- Build artifacts

Preserved:
- Creative brief: creative-brief.md ✓
- UI mockups: 2 versions ✓
- Parameters: parameter-spec.md ✓

Backup available at:
backups/rollbacks/[PluginName]_20251110_235612.tar.gz

Status changed: [Previous] → 💡 Ideated

Next steps:
1. Review mockups and parameter spec
2. Run /implement [PluginName] to start fresh from Stage 0
3. Or modify creative brief and re-run /dream
```

**Replace with in command (Lines 60-86):**
```markdown
## Success Output

On successful reset, plugin-lifecycle skill displays:
- Confirmation of removed files and directories
- Confirmation of preserved ideation artifacts
- Backup file path for recovery
- Status transition confirmation
- Suggested next steps

See [plugin-lifecycle assets/reset-success-example.txt](../.skills/plugin-lifecycle/assets/reset-success-example.txt) for sample output.
```

**Verification:**
- [ ] Asset file created at correct path
- [ ] Command references asset file
- [ ] Line count reduced by ~19 lines
- [ ] Functionality preserved (progressive disclosure)

**Token impact:** -220 tokens

## Phase 3: Polish (Clarity & Optimization)

### Fix 3.1: Add Related Commands Decision Matrix (Lines 92-96)
**Location:** Lines 92-96
**Operation:** REPLACE
**Severity:** MEDIUM

**Before:**
```markdown
## Related Commands

- `/destroy` - Complete removal with backup
- `/uninstall` - Remove binaries only, keep source
- `/clean` - Interactive menu to choose cleanup operation
```

**After:**
```markdown
## Related Commands

<related_commands>
  <decision_matrix>
    <scenario condition="want_to_start_over_but_keep_idea">
      Use: /reset-to-ideation (THIS COMMAND)
      Effect: Keep creative brief/mockups, delete implementation
    </scenario>

    <scenario condition="want_to_remove_binaries_only">
      Use: /uninstall
      Effect: Remove installed VST3/AU, keep source code
    </scenario>

    <scenario condition="want_to_delete_everything">
      Use: /destroy
      Effect: Remove plugin entirely (with backup)
    </scenario>

    <scenario condition="unsure_which_cleanup">
      Use: /clean
      Effect: Interactive menu to choose operation
    </scenario>
  </decision_matrix>
</related_commands>
```

**Verification:**
- [ ] Decision matrix provides clear guidance
- [ ] Each scenario has condition and effect
- [ ] XML structure is valid

**Token impact:** +50 tokens (improved clarity, minor increase)

### Fix 3.2: Convert Quick Reference to XML Preservation Contract (Lines 17-30)
**Location:** Lines 17-30
**Operation:** WRAP
**Severity:** MEDIUM

**Before:**
```markdown
## Quick Reference

**What gets preserved:**
- Creative brief (`.ideas/creative-brief.md`)
- UI mockups (`.ideas/mockups/`)
- Parameter specifications (`.ideas/parameter-spec.md`)

**What gets removed:**
- Source code (`Source/` directory)
- Build configuration (`CMakeLists.txt`)
- Implementation docs (`.ideas/architecture.md`, `.ideas/plan.md`)
- Build artifacts and installed binaries

**Status change:** [Any] → 💡 Ideated
```

**After:**
```markdown
## What Gets Preserved/Removed

<preservation_contract>
  <preserved>
    - Creative brief (.ideas/creative-brief.md)
    - UI mockups (.ideas/mockups/)
    - Parameter specifications (.ideas/parameter-spec.md)
  </preserved>

  <removed>
    - Source code (Source/ directory)
    - Build configuration (CMakeLists.txt)
    - Implementation docs (.ideas/architecture.md, .ideas/plan.md)
    - Build artifacts and installed binaries
  </removed>

  <state_change>
    Status: [Any] → 💡 Ideated
  </state_change>
</preservation_contract>
```

**Verification:**
- [ ] Contract clearly defines preserved vs removed items
- [ ] State change explicitly documented
- [ ] XML structure improves context survival

**Token impact:** -20 tokens (removal of markdown bold formatting)

## File Operations Manifest

**Files to create:**
1. `.claude/skills/plugin-lifecycle/assets/reset-confirmation-example.txt` - Confirmation prompt example
2. `.claude/skills/plugin-lifecycle/assets/reset-success-example.txt` - Success output example

**Files to modify:**
1. `.claude/commands/reset-to-ideation.md` - All fixes above

**Files to archive:**
None

## Execution Checklist

**Phase 1 (Critical):**
- [ ] YAML frontmatter corrected (`args` → `argument-hint`)
- [ ] XML preconditions added with blocking enforcement
- [ ] Preconditions check plugin existence in PLUGINS.md
- [ ] Preconditions verify plugin has implementation to reset
- [ ] Preconditions warn if no ideation artifacts exist
- [ ] Routing logic wrapped in `<routing_logic>` XML
- [ ] Skill invocation parameters explicit
- [ ] Skill reference path included

**Phase 2 (Extraction):**
- [ ] Confirmation example extracted to plugin-lifecycle assets/
- [ ] Success output example extracted to plugin-lifecycle assets/
- [ ] Command file references asset files with correct paths
- [ ] Progressive disclosure maintained (examples only when needed)

**Phase 3 (Polish):**
- [ ] Related commands converted to decision matrix
- [ ] Preservation contract wrapped in XML
- [ ] All sections use structured XML where appropriate
- [ ] Language is imperative and explicit

**Final Verification:**
- [ ] Command loads without errors
- [ ] Command appears in `/help` with correct description
- [ ] Autocomplete shows argument hint
- [ ] Preconditions block invalid invocations
- [ ] Routing to plugin-lifecycle skill succeeds
- [ ] Asset files accessible from skill context

## Estimated Impact

**Before:**
- Health score: 24/40 (Red)
- Line count: 97 lines
- Token count: ~1000 tokens
- Critical issues: 3
- Embedded examples: 48 lines (50% of file)

**After:**
- Health score: 35/40 (Yellow) - target
- Line count: ~75 lines
- Token count: ~700 tokens
- Critical issues: 0
- Embedded examples: 0 lines (moved to assets/)

**Improvement:** +11 health points, -30% tokens

## Implementation Notes

### Precondition Logic
The precondition checks enforce three critical validations:

1. **Plugin Existence** - Prevents command from running on non-existent plugins
   - Check: grep for plugin name in PLUGINS.md
   - Failure: Block with error message directing user to /dream

2. **Implementation Status** - Prevents resetting a plugin already at ideation stage
   - Check: Plugin status is not "💡 Ideated"
   - Valid states: ✅ Working, 📦 Installed, 🚧 Stage N (N ≥ 2)
   - Failure: Block with error message directing user to /implement

3. **Ideation Artifacts** - Warns if nothing will be preserved
   - Check: At least one of creative-brief.md, mockups/*.html, parameter-spec.md exists
   - Failure: Warn user (non-blocking) suggesting /destroy as alternative

### Progressive Disclosure
Examples moved to assets/ follow progressive disclosure pattern:
- Command file contains only summary of what skill will display
- Full examples available in skill's asset directory
- Reduces token usage when command executes normally
- Examples still accessible when debugging or learning workflow

### XML Enforcement
Three types of XML added:

1. **`<preconditions enforcement="blocking">`** - Hard requirements that stop execution
2. **`<routing_logic>`** - Structured skill invocation with explicit parameters
3. **`<preservation_contract>`** - Clear contract of what changes

These structures improve context survival during compression and make critical logic explicit.
