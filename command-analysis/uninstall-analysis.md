# Command Analysis: uninstall

## Executive Summary
- Overall health: **Yellow** (Clean routing but lacks structural enforcement)
- Critical issues: **2** (Missing precondition enforcement, no state validation structure)
- Optimization opportunities: **3** (XML preconditions, token efficiency, success output verbosity)
- Estimated context savings: **~150 tokens (~25% reduction)**

## Dimension Scores (1-5)
1. Structure Compliance: **5/5** (Complete YAML frontmatter with description)
2. Routing Clarity: **5/5** (Crystal clear skill invocation - "invoke plugin-lifecycle skill")
3. Instruction Clarity: **4/5** (Clear imperative steps, minor pronoun in "I'll")
4. XML Organization: **2/5** (No XML enforcement for preconditions or critical sequences)
5. Context Efficiency: **4/5** (Lean at 46 lines, some verbosity in success output)
6. Claude-Optimized Language: **4/5** (Mostly imperative, clear routing)
7. System Integration: **4/5** (Documents state transition, references skill for full workflow)
8. Precondition Enforcement: **2/5** (Listed preconditions lack XML structure and enforcement attributes)

**Total Score: 30/40 (Yellow - Functional but needs enforcement structure)**

## Critical Issues (blockers for Claude comprehension)

### Issue #1: Preconditions Lack XML Enforcement (Lines 10-13)
**Severity:** CRITICAL
**Impact:** Claude may skip precondition checks, allowing uninstall attempts on non-installed plugins or in-progress workflows

**Current:**
```markdown
## Preconditions

- Plugin must be installed (status: 📦 Installed in PLUGINS.md)
- Cannot uninstall if plugin is 🚧 in development (use /continue first)
```

**Problem:** Natural language "must" statements are not structurally enforced. Claude can miss these during context compression or under token pressure. No blocking behavior specified.

**Recommended Fix:**
```xml
<preconditions enforcement="blocking">
  <status_check target="PLUGINS.md" required="true">
    <allowed_state status="📦 Installed">
      Plugin binaries exist in system folders, safe to uninstall
    </allowed_state>

    <blocked_state status="🚧 *">
      BLOCK with message:
      "[PluginName] is currently in development.

      Complete or pause development first:
      - Continue development: /continue [PluginName]
      - Complete workflow: Finish all stages

      Cannot uninstall incomplete plugin."
    </blocked_state>

    <blocked_state status="💡 Ideated">
      BLOCK with message:
      "[PluginName] hasn't been built yet - nothing to uninstall.
      Status: 💡 Ideated (no binaries exist)"
    </blocked_state>

    <blocked_state status="✅ Working">
      BLOCK with message:
      "[PluginName] is not installed to system folders.
      Status: ✅ Working (binaries exist in build/ only)

      To install first: /install-plugin [PluginName]"
    </blocked_state>
  </status_check>
</preconditions>
```

**Why this matters:**
- Attempting to uninstall during active development (🚧 Stage N) could corrupt workflow state
- Uninstalling non-existent plugins wastes user time
- XML structure makes preconditions survive context compression
- `enforcement="blocking"` makes it clear execution must stop if conditions fail

### Issue #2: State Transition Not Structurally Enforced (Line 22)
**Severity:** HIGH
**Impact:** State update could be skipped or applied incorrectly, causing PLUGINS.md drift

**Current:**
```markdown
5. Update PLUGINS.md status: 📦 Installed → ✅ Working
```

**Problem:** No structural enforcement that this transition is valid or required. If plugin-lifecycle skill fails to update PLUGINS.md, system state becomes inconsistent.

**Recommended Fix:**
```xml
<state_transition required="true">
  <validation>
    Verify current status is 📦 Installed before proceeding
  </validation>

  <update target="PLUGINS.md" field="status">
    FROM: 📦 Installed
    TO: ✅ Working
  </update>

  <on_failure action="rollback">
    If state update fails:
    1. Report error to user
    2. DO NOT remove binaries (leave system in consistent state)
    3. Present recovery options
  </on_failure>

  <verification>
    After state update:
    1. Verify PLUGINS.md contains "Status: ✅ Working"
    2. Verify "Last Updated" field reflects current date
    3. Confirm timeline entry appended
  </verification>
</state_transition>
```

**Why this matters:**
- State transitions are critical system invariants
- Without enforcement, PLUGINS.md can show "📦 Installed" when binaries don't exist
- Rollback logic prevents partially-completed uninstalls
- Verification step catches silent failures

## Optimization Opportunities

### Optimization #1: Verbosity in Success Output (Lines 28-42)
**Potential savings:** ~80 tokens (~17% reduction from success output section)
**Current:** 15 lines showing expected output format
**Recommended:** 8 lines with reference to skill documentation

**Current:**
```markdown
## Success Output

```
✓ [PluginName] uninstalled

Removed from system folders:
- VST3: ~/Library/Audio/Plug-Ins/VST3/[ProductName].vst3 (deleted)
- AU: ~/Library/Audio/Plug-Ins/Components/[ProductName].component (deleted)

Cache status: Cleared (Ableton + Logic)

Source code remains: plugins/[PluginName]/

To reinstall: /install-plugin [PluginName]
```
```

**After:**
```markdown
## Success Output

Display completion confirmation with:
- Plugin name and status (uninstalled)
- Removed binary paths (VST3 + AU)
- Cache clearing confirmation
- Source code preservation note
- Reinstall command hint

See `.claude/skills/plugin-lifecycle/references/uninstallation-process.md` for complete output format.
```

**Why this is beneficial:**
- Command file is routing layer, not output spec
- Detailed output format belongs in skill documentation
- Reduces repetition across install-plugin and uninstall commands
- Skill can update output format without changing command

### Optimization #2: Argument Handling Not Explicit (Line 8)
**Potential savings:** ~20 tokens
**Current:** Implicit $ARGUMENTS usage
**Recommended:** Explicit parameter documentation

**Current:**
```markdown
When user runs `/uninstall [PluginName]`, invoke the plugin-lifecycle skill with uninstallation mode.
```

**After:**
```xml
<invocation>
  <parameter name="PluginName" position="1" required="true">
    Name of plugin to uninstall (must match PLUGINS.md entry)
  </parameter>

  <routing>
    Extract PluginName from $ARGUMENTS
    Invoke plugin-lifecycle skill with mode="uninstall"
  </routing>
</invocation>
```

**Why this is beneficial:**
- Makes parameter requirements explicit
- Documents that name must match PLUGINS.md
- Clarifies skill invocation pattern
- Easier to validate input before routing

### Optimization #3: Behavior Section Could Use Critical Sequence Wrapper (Lines 15-23)
**Potential savings:** ~50 tokens (structural clarity, not raw reduction)
**Current:** Numbered list without enforcement
**Recommended:** XML critical sequence

**Current:**
```markdown
## Behavior

Invoke plugin-lifecycle skill following the uninstallation workflow:
1. Locate plugin files (extract PRODUCT_NAME from CMakeLists.txt)
2. Confirm removal with user (show file sizes, preserve source code)
3. Remove from system folders (VST3 + AU)
4. Clear DAW caches (Ableton + Logic)
5. Update PLUGINS.md status: 📦 Installed → ✅ Working
6. Present decision menu for next steps
```

**After:**
```xml
<behavior>
  Invoke plugin-lifecycle skill with mode="uninstall"

  <workflow_sequence enforce_order="true">
    <step order="1">Locate plugin files (extract PRODUCT_NAME from CMakeLists.txt)</step>
    <step order="2" requires_user_input="true">Confirm removal with user (show file sizes, preserve source code)</step>
    <step order="3" required="true">Remove from system folders (VST3 + AU)</step>
    <step order="4" required="true">Clear DAW caches (Ableton + Logic)</step>
    <step order="5" required="true">Update PLUGINS.md status: 📦 Installed → ✅ Working</step>
    <step order="6" required="true" blocking="true">Present decision menu for next steps</step>
  </workflow_sequence>

  <skill_reference>
    See `.claude/skills/plugin-lifecycle/references/uninstallation-process.md` for complete workflow.
  </skill_reference>
</behavior>
```

**Why this is beneficial:**
- Makes step ordering explicit
- Documents which steps require user input
- Marks blocking steps (user confirmation, decision menu)
- Enforces that all steps are required (no optional steps)

## Implementation Priority

1. **Immediate** (Critical issues blocking safe execution)
   - Add XML enforcement to preconditions (Issue #1)
   - Add XML enforcement to state transition (Issue #2)

2. **High** (Major optimizations)
   - Wrap behavior workflow in critical sequence (Optimization #3)
   - Add explicit parameter documentation (Optimization #2)

3. **Medium** (Minor improvements)
   - Condense success output section (Optimization #1)

## Verification Checklist

After implementing fixes, verify:
- [x] YAML frontmatter includes description
- [ ] Preconditions use XML enforcement with blocking attribute
- [ ] State transition wrapped in XML with validation and rollback
- [ ] Behavior workflow uses critical_sequence wrapper
- [ ] Parameter handling is explicit
- [x] Command is under 200 lines (currently 46)
- [x] Routing to plugin-lifecycle skill is explicit
- [x] State file interactions documented (PLUGINS.md)

## Comparison to System Patterns

### Strengths
1. **Excellent routing clarity** - One of the clearest examples in the command set
2. **Lean structure** - 46 lines is ideal for a routing layer
3. **Clear skill delegation** - No ambiguity about which skill to invoke
4. **Good state documentation** - Clearly documents PLUGINS.md transition

### Weaknesses (vs. best practices)
1. **Missing XML enforcement** - Unlike improved commands, preconditions are prose-only
2. **No decision gate structure** - Should wrap status check in `<decision_gate>`
3. **Implicit parameter handling** - Should use explicit `<parameter>` tags
4. **Success output too detailed** - Should reference skill docs instead of embedding format

## Token Efficiency Analysis

**Current token count:** ~600 tokens
**After optimization:** ~450 tokens
**Savings:** ~150 tokens (25% reduction)

**Breakdown:**
- Preconditions: 40 tokens → 120 tokens (+80 for XML structure, but adds enforcement)
- Behavior: 100 tokens → 120 tokens (+20 for critical sequence wrapper)
- Success output: 150 tokens → 50 tokens (-100 by referencing skill docs)
- Parameter handling: implicit → 40 tokens (+40 for explicit docs)
- **Net change:** Current structure + enforcement = similar tokens but MUCH stronger guarantees

**Note:** XML enforcement adds tokens upfront but prevents execution errors that waste far more tokens in debugging and recovery.

## Recommended Next Steps

1. **Add XML precondition enforcement** (15 minutes)
   - Wrap lines 10-13 in `<preconditions enforcement="blocking">`
   - Add `<status_check>` with allowed/blocked states
   - Add blocking messages for each invalid state

2. **Add state transition enforcement** (10 minutes)
   - Wrap line 22 in `<state_transition required="true">`
   - Add validation, on_failure, and verification steps
   - Document rollback behavior

3. **Wrap behavior in critical sequence** (10 minutes)
   - Replace lines 15-23 with `<workflow_sequence enforce_order="true">`
   - Mark steps with attributes (requires_user_input, blocking)
   - Keep skill reference at bottom

4. **Condense success output** (5 minutes)
   - Replace example output with summary
   - Reference skill documentation for complete format
   - Remove redundant detail

**Total time:** ~40 minutes to bring to Green health (38-40/40)

## Health Score Projection

**Current:** 30/40 (Yellow)
**After fixes:** 38/40 (Green)

**Improvements:**
- Dimension 4 (XML Organization): 2 → 5 (+3 points)
- Dimension 8 (Precondition Enforcement): 2 → 5 (+3 points)
- Dimension 5 (Context Efficiency): 4 → 5 (+1 point)
- Dimension 6 (Claude-Optimized Language): 4 → 5 (+1 point)

**Final scores after fixes:**
1. Structure Compliance: 5/5
2. Routing Clarity: 5/5
3. Instruction Clarity: 4/5
4. XML Organization: 5/5 (currently 2)
5. Context Efficiency: 5/5 (currently 4)
6. Claude-Optimized Language: 5/5 (currently 4)
7. System Integration: 4/5
8. Precondition Enforcement: 5/5 (currently 2)

**Total: 38/40 (Green)**
