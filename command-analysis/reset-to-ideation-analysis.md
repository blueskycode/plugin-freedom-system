# Command Analysis: reset-to-ideation

## Executive Summary
- Overall health: **Red** (Lacks critical precondition enforcement and routing structure)
- Critical issues: **3** (Missing XML enforcement for preconditions, no routing logic, lacks frontmatter fields)
- Optimization opportunities: **4** (Add XML preconditions, clarify skill invocation, extract examples, improve structure)
- Estimated context savings: **~300 tokens (30% reduction)**

## Dimension Scores (1-5)
1. Structure Compliance: **3/5** (Has basic frontmatter with description and args, missing `argument-hint` field)
2. Routing Clarity: **4/5** (Clear skill invocation specified, but missing routing logic)
3. Instruction Clarity: **4/5** (Clear imperative instruction "invoke the plugin-lifecycle skill", but lacks explicit routing protocol)
4. XML Organization: **1/5** (No XML - all prose, no structural enforcement of critical logic)
5. Context Efficiency: **4/5** (Lean at 97 lines, but examples consume unnecessary space)
6. Claude-Optimized Language: **4/5** (Clear imperative language, minimal pronouns)
7. System Integration: **3/5** (Documents state changes and file operations, but lacks contracts)
8. Precondition Enforcement: **1/5** (No preconditions defined - plugin existence not verified)

**Overall Score: 24/40** (Red - Critical deficiencies in enforcement)

## Critical Issues (blockers for Claude comprehension)

### Issue #1: No Precondition Verification (Missing)
**Severity:** CRITICAL
**Impact:** Command can be invoked on non-existent plugins, causing skill to fail

**Problem:** The command immediately routes to plugin-lifecycle skill without verifying:
- Plugin exists in PLUGINS.md
- Plugin has any implementation to reset (not already at 💡 Ideated)
- Plugin has ideation artifacts to preserve (creative-brief.md, mockups)

**Current (Lines 14-15):**
```markdown
When user runs `/reset-to-ideation [PluginName]`, invoke the plugin-lifecycle skill with mode: 'reset'.
```

**Recommended Fix:** Add XML-wrapped preconditions before routing
```xml
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

  <check target="ideation_artifacts" condition="preservable_content_exists">
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

<routing>
  After preconditions pass, invoke plugin-lifecycle skill with mode: 'reset'
</routing>
```

### Issue #2: Missing YAML argument-hint Field (Line 4)
**Severity:** HIGH
**Impact:** Reduces discoverability via autocomplete, unclear parameter format

**Current:**
```yaml
---
name: reset-to-ideation
description: Roll back plugin to ideation stage - keep idea/mockups, remove all implementation
args: "[PluginName]"
---
```

**Problem:** The `args` field is not standard - should be `argument-hint` per Claude Code conventions.

**Recommended Fix:**
```yaml
---
name: reset-to-ideation
description: Roll back plugin to ideation stage - keep idea/mockups, remove all implementation
argument-hint: "[PluginName]"
---
```

### Issue #3: Routing Logic Not Wrapped in XML (Line 15)
**Severity:** MEDIUM
**Impact:** Routing instruction could be missed during context compression

**Current:**
```markdown
When user runs `/reset-to-ideation [PluginName]`, invoke the plugin-lifecycle skill with mode: 'reset'.
```

**Recommended Fix:** Wrap routing in structured XML
```xml
<routing_logic>
  <trigger>User invokes /reset-to-ideation [PluginName]</trigger>

  <sequence>
    <step order="1">Verify preconditions (see above)</step>
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

## Optimization Opportunities

### Optimization #1: Extract Confirmation Example to assets/ (Lines 36-58)
**Potential savings:** ~200 tokens (20% reduction)
**Current:** 23-line confirmation example embedded in command file
**Recommended:** Move to `assets/confirmation-example.txt` and reference it

**Before:**
```markdown
## Example Confirmation

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
```

**After:**
```markdown
## User Confirmation

The plugin-lifecycle skill will present an interactive confirmation showing:
- Files to be removed (Source/, CMakeLists.txt, implementation docs, binaries)
- Files to be preserved (creative-brief, mockups, parameter-spec)
- Backup location (backups/rollbacks/)
- Status transition ([Current] → 💡 Ideated)

See [assets/confirmation-example.txt](assets/confirmation-example.txt) for sample output.
```

**Why:** Progressive disclosure - only load example if user needs to understand format. Reduces token usage when command executes normally.

### Optimization #2: Extract Success Output to assets/ (Lines 62-86)
**Potential savings:** ~220 tokens (22% reduction)
**Current:** 25-line success example embedded in command file
**Recommended:** Move to `assets/success-example.txt` and reference it

**Before:**
```markdown
## Success Output

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
```

**After:**
```markdown
## Success Output

On successful reset, plugin-lifecycle skill displays:
- Confirmation of removed files and directories
- Confirmation of preserved ideation artifacts
- Backup file path for recovery
- Status transition confirmation
- Suggested next steps

See [assets/success-example.txt](assets/success-example.txt) for sample output.
```

### Optimization #3: Document Preconditions Contracts (Missing)
**Potential savings:** None (adds tokens, but improves reliability)
**Current:** No precondition checks documented
**Recommended:** Add XML-wrapped preconditions section

```xml
<preconditions enforcement="blocking">
  <state_checks>
    <check id="plugin_exists" target="PLUGINS.md">
      Plugin entry MUST exist in PLUGINS.md

      Verification:
      ```bash
      grep "^### $ARGUMENTS$" PLUGINS.md
      ```

      <on_failure>
        BLOCK with error: "[PluginName] not found. Run /dream to create plugin."
      </on_failure>
    </check>

    <check id="has_implementation" target="status">
      Status MUST indicate implementation exists (not 💡 Ideated)

      Valid states: ✅ Working, 📦 Installed, 🚧 Stage N (N ≥ 2)

      <on_failure>
        BLOCK with error: "[PluginName] already at ideation stage. Run /implement instead."
      </on_failure>
    </check>

    <check id="ideation_artifacts_exist" target="filesystem" severity="warning">
      At least one ideation artifact SHOULD exist

      <required_files>
        - plugins/$ARGUMENTS/.ideas/creative-brief.md OR
        - plugins/$ARGUMENTS/.ideas/mockups/*.html OR
        - plugins/$ARGUMENTS/.ideas/parameter-spec.md
      </required_files>

      <on_failure>
        WARN: "No ideation artifacts found. Consider /destroy instead."
      </on_failure>
    </check>
  </state_checks>
</preconditions>
```

### Optimization #4: Clarify Relationship with Related Commands (Lines 92-96)
**Potential savings:** ~50 tokens (5% reduction)
**Current:** Simple list of related commands without context
**Recommended:** Add decision matrix

**Before:**
```markdown
## Related Commands

- `/destroy` - Complete removal with backup
- `/uninstall` - Remove binaries only, keep source
- `/clean` - Interactive menu to choose cleanup operation
```

**After:**
```xml
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

## Implementation Priority

### 1. **Immediate** (Critical issues blocking comprehension)
   - Add XML preconditions wrapper (Issue #1) - **30 minutes**
   - Fix frontmatter `args` → `argument-hint` (Issue #2) - **1 minute**
   - Wrap routing logic in XML (Issue #3) - **5 minutes**

### 2. **High** (Major optimizations)
   - Extract confirmation example to assets/ (Optimization #1) - **10 minutes**
   - Extract success example to assets/ (Optimization #2) - **10 minutes**

### 3. **Medium** (Minor improvements)
   - Add related commands decision matrix (Optimization #4) - **10 minutes**

**Total implementation time:** ~66 minutes

## Recommended Structure (After Fixes)

```markdown
---
name: reset-to-ideation
description: Roll back plugin to ideation stage - keep idea/mockups, remove all implementation
argument-hint: "[PluginName]"
---

# /reset-to-ideation - Surgical Rollback

<purpose>
  Direct shortcut to reset plugin to ideation stage.
  Routes to plugin-lifecycle skill with mode: 'reset'.
</purpose>

<use_case>
  Implementation went wrong, but concept and UI design are solid.
  Start fresh from Stage 0 without losing creative work.
</use_case>

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

## User Confirmation

The plugin-lifecycle skill will present interactive confirmation showing:
- Files to be removed (Source/, CMakeLists.txt, implementation docs, binaries)
- Files to be preserved (creative-brief, mockups, parameter-spec)
- Backup location (backups/rollbacks/)
- Status transition ([Current] → 💡 Ideated)

See [assets/confirmation-example.txt](assets/confirmation-example.txt) for sample output.

## Success Output

On successful reset, plugin-lifecycle skill displays:
- Confirmation of removed files and directories
- Confirmation of preserved ideation artifacts
- Backup file path for recovery
- Status transition confirmation
- Suggested next steps

See [assets/success-example.txt](assets/success-example.txt) for sample output.

## Routes To

`plugin-lifecycle` skill (mode: 'reset')

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

## Verification Checklist

After implementing fixes, verify:
- [x] YAML frontmatter uses `argument-hint` (not `args`)
- [ ] Preconditions use XML enforcement with blocking attributes
- [ ] Routing logic wrapped in `<routing_logic>` with sequence
- [ ] Confirmation example extracted to assets/
- [ ] Success example extracted to assets/
- [ ] Related commands include decision matrix
- [ ] Command is lean (under 150 lines after extractions)
- [ ] State file interactions documented
- [ ] Skill invocation is explicit (plugin-lifecycle with mode: 'reset')

## Token Analysis

**Current:**
- Total lines: 97
- Embedded examples: 48 lines (50% of file)
- Estimated tokens: ~1000

**After optimizations:**
- Total lines: ~75 (with XML, minus extractions)
- Embedded examples: 0 lines (moved to assets/)
- Estimated tokens: ~700

**Net savings: ~300 tokens (30% reduction)**

**Context efficiency improvement:**
- Progressive disclosure: Examples only loaded when needed
- Structural enforcement: Preconditions survive context compression
- Reduced duplication: Single source of truth for file operations
