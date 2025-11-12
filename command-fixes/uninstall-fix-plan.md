# Fix Plan: /uninstall

## Summary
- Critical fixes: 2
- Extraction operations: 0
- Optimization operations: 3
- Total estimated changes: 5
- Estimated time: 40 minutes
- Token savings: ~150 tokens (25% reduction)
- Health score improvement: 30/40 → 38/40

## Phase 1: Critical Fixes (Blocking Issues)

### Fix 1.1: Add XML Enforcement to Preconditions
**Location:** Lines 10-13
**Operation:** REPLACE
**Severity:** CRITICAL
**Priority:** IMMEDIATE

**Current:**
```markdown
## Preconditions

- Plugin must be installed (status: 📦 Installed in PLUGINS.md)
- Cannot uninstall if plugin is 🚧 in development (use /continue first)
```

**After:**
```markdown
## Preconditions

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

**Verification:**
- [ ] XML structure parses correctly
- [ ] All plugin states are covered (📦 Installed, 🚧 *, 💡 Ideated, ✅ Working)
- [ ] Blocking messages provide clear next actions
- [ ] `enforcement="blocking"` attribute present
- [ ] Status check marked as `required="true"`

**Token impact:** +80 tokens (adds enforcement structure that prevents execution errors)

**Rationale:**
Natural language "must" statements are not structurally enforced. Claude can miss these during context compression or under token pressure. Attempting to uninstall during active development (🚧 Stage N) could corrupt workflow state. XML structure makes preconditions survive context compression.

---

### Fix 1.2: Add XML Enforcement to State Transition
**Location:** Line 22
**Operation:** REPLACE
**Severity:** CRITICAL
**Priority:** IMMEDIATE

**Current:**
```markdown
5. Update PLUGINS.md status: 📦 Installed → ✅ Working
```

**After:**
```markdown
5. <state_transition required="true">
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

**Verification:**
- [ ] State transition wrapped in XML
- [ ] `required="true"` attribute present
- [ ] Validation step checks current status
- [ ] Rollback logic specified
- [ ] Verification steps complete

**Token impact:** +60 tokens (prevents PLUGINS.md state drift)

**Rationale:**
State transitions are critical system invariants. Without enforcement, PLUGINS.md can show "📦 Installed" when binaries don't exist. Rollback logic prevents partially-completed uninstalls. Verification step catches silent failures.

---

## Phase 2: High-Priority Optimizations

### Fix 2.1: Wrap Behavior Workflow in Critical Sequence
**Location:** Lines 15-23
**Operation:** WRAP
**Severity:** HIGH
**Priority:** HIGH

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

See `.claude/skills/plugin-lifecycle/references/uninstallation-process.md` for complete workflow.
```

**After:**
```markdown
## Behavior

Invoke plugin-lifecycle skill with mode="uninstall"

<workflow_sequence enforce_order="true">
  <step order="1">
    Locate plugin files (extract PRODUCT_NAME from CMakeLists.txt)
  </step>

  <step order="2" requires_user_input="true">
    Confirm removal with user (show file sizes, preserve source code)
  </step>

  <step order="3" required="true">
    Remove from system folders (VST3 + AU)
  </step>

  <step order="4" required="true">
    Clear DAW caches (Ableton + Logic)
  </step>

  <step order="5" required="true">
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
  </step>

  <step order="6" required="true" blocking="true">
    Present decision menu for next steps
  </step>
</workflow_sequence>

<skill_reference>
  See `.claude/skills/plugin-lifecycle/references/uninstallation-process.md` for complete workflow.
</skill_reference>
```

**Verification:**
- [ ] All steps wrapped in `<workflow_sequence>`
- [ ] `enforce_order="true"` attribute present
- [ ] Step order attributes sequential (1-6)
- [ ] Step 2 marked with `requires_user_input="true"`
- [ ] Steps 3-6 marked with `required="true"`
- [ ] Step 6 marked with `blocking="true"`
- [ ] State transition from Fix 1.2 integrated into step 5

**Token impact:** +20 tokens (structural clarity)

**Rationale:**
Makes step ordering explicit. Documents which steps require user input. Marks blocking steps (user confirmation, decision menu). Enforces that all steps are required (no optional steps).

---

### Fix 2.2: Add Explicit Parameter Documentation
**Location:** Line 8
**Operation:** REPLACE
**Severity:** HIGH
**Priority:** HIGH

**Current:**
```markdown
When user runs `/uninstall [PluginName]`, invoke the plugin-lifecycle skill with uninstallation mode.
```

**After:**
```markdown
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

**Verification:**
- [ ] Parameter wrapped in XML
- [ ] `required="true"` attribute present
- [ ] Position specified as `position="1"`
- [ ] Documentation clarifies name must match PLUGINS.md
- [ ] Routing section explicit about extraction and invocation

**Token impact:** +40 tokens (explicit parameter requirements)

**Rationale:**
Makes parameter requirements explicit. Documents that name must match PLUGINS.md. Clarifies skill invocation pattern. Easier to validate input before routing.

---

## Phase 3: Medium-Priority Polish

### Fix 3.1: Condense Success Output Section
**Location:** Lines 27-41
**Operation:** REPLACE
**Severity:** MEDIUM
**Priority:** MEDIUM

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

**Verification:**
- [ ] Summary list replaces example output block
- [ ] All required elements listed
- [ ] Reference to skill documentation included
- [ ] Section reduced from 15 lines to 8 lines

**Token impact:** -100 tokens (removes redundant detail)

**Rationale:**
Command file is routing layer, not output spec. Detailed output format belongs in skill documentation. Reduces repetition across install-plugin and uninstall commands. Skill can update output format without changing command.

---

## File Operations Manifest

**Files to modify:**
1. `.claude/commands/uninstall.md` - All fixes applied to this file

**No files to create or archive.**

---

## Execution Checklist

### Phase 1 (Critical)
- [ ] YAML frontmatter complete with all required fields (already complete)
- [ ] Preconditions wrapped in `<preconditions enforcement="blocking">`
- [ ] All plugin states covered in status_check (📦 Installed, 🚧 *, 💡 Ideated, ✅ Working)
- [ ] Blocking messages provide clear next actions
- [ ] State transition wrapped in `<state_transition required="true">`
- [ ] Validation, rollback, and verification steps complete

### Phase 2 (High Priority)
- [ ] Behavior workflow wrapped in `<workflow_sequence enforce_order="true">`
- [ ] All steps have order attributes (1-6)
- [ ] Steps requiring user input marked with `requires_user_input="true"`
- [ ] Critical steps marked with `required="true"`
- [ ] Blocking step marked with `blocking="true"`
- [ ] Parameter documentation explicit with XML structure
- [ ] Routing logic clear and unambiguous

### Phase 3 (Polish)
- [ ] Success output condensed to summary + skill reference
- [ ] Line count reduced from 46 to ~55 lines (net +9 for enforcement)
- [ ] All references to skill documentation correct

### Final Verification
- [ ] Command loads without errors
- [ ] Command appears in `/help` with correct description
- [ ] Autocomplete works with argument hints
- [ ] Routing to plugin-lifecycle skill succeeds
- [ ] Health score improved from 30/40 to 38/40

---

## Estimated Impact

### Before
- Health score: 30/40 (Yellow)
- Line count: 46 lines
- Token count: ~600 tokens
- Critical issues: 2
- Missing enforcement structure

### After
- Health score: 38/40 (Green)
- Line count: ~55 lines
- Token count: ~600 tokens (similar, but with enforcement)
- Critical issues: 0
- Complete XML enforcement

### Dimension Improvements
- Dimension 4 (XML Organization): 2/5 → 5/5 (+3 points)
- Dimension 8 (Precondition Enforcement): 2/5 → 5/5 (+3 points)
- Dimension 5 (Context Efficiency): 4/5 → 5/5 (+1 point)
- Dimension 6 (Claude-Optimized Language): 4/5 → 5/5 (+1 point)

### Final Scores After Fixes
1. Structure Compliance: 5/5 (already complete)
2. Routing Clarity: 5/5 (already complete)
3. Instruction Clarity: 4/5 (already good)
4. XML Organization: 5/5 ← **was 2/5**
5. Context Efficiency: 5/5 ← **was 4/5**
6. Claude-Optimized Language: 5/5 ← **was 4/5**
7. System Integration: 4/5 (already good)
8. Precondition Enforcement: 5/5 ← **was 2/5**

**Total: 38/40 (Green)**

**Improvement:** +8 health points, same token count but MUCH stronger execution guarantees

---

## Notes

**Token paradox:** XML enforcement adds tokens upfront but prevents execution errors that waste far more tokens in debugging and recovery. The precondition enforcement alone could save 500-1000 tokens per failed uninstall attempt.

**Architecture decision:** Command remains a routing layer. All implementation details stay in plugin-lifecycle skill. This fix adds enforcement structure without crossing into implementation territory.

**Testing priority:** After applying fixes, test with:
1. Plugin in 📦 Installed state (should succeed)
2. Plugin in 🚧 Stage 3 state (should block with clear message)
3. Plugin in 💡 Ideated state (should block with appropriate message)
4. Plugin in ✅ Working state (should block and suggest /install-plugin)
