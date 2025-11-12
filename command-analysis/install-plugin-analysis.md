# Command Analysis: install-plugin

## Executive Summary
- Overall health: **Red** (27/40 - below 30 threshold)
- Critical issues: **1** (No XML structural enforcement for preconditions)
- Optimization opportunities: **5** (Missing argument-hint, implementation details in routing layer, weak system integration)
- Estimated context savings: **~450 tokens (45% reduction)**

## Dimension Scores (1-5)

1. Structure Compliance: **3/5** (Missing argument-hint for [PluginName] parameter)
2. Routing Clarity: **3/5** (Clear skill invocation but mixed with implementation details)
3. Instruction Clarity: **4/5** (Imperative language throughout, minor mixing of concerns)
4. XML Organization: **2/5** (CRITICAL - No XML enforcement for preconditions or sequences)
5. Context Efficiency: **4/5** (59 lines is lean, but contains unnecessary duplication)
6. Claude-Optimized Language: **5/5** (Fully imperative, explicit verbs)
7. System Integration: **3/5** (Mentions PLUGINS.md but lacks detailed contracts)
8. Precondition Enforcement: **3/5** (Listed with blocking logic, but no XML structure)

## Critical Issues (blockers for Claude comprehension)

### Issue #1: No XML Structural Enforcement (Lines 10-18, 22-36)
**Severity:** CRITICAL
**Impact:** Claude may skip precondition checks or execute steps out of order. The prose format doesn't structurally enforce the blocking behavior that's required.

**Current problematic structure:**
```markdown
## Preconditions

Before running this command:
- Plugin status must be ✅ Working (Stage 6 complete)
- Plugin must have successful Release build
- pluginval validation must have passed
- Plugin must have been tested in DAW from build folder

If any precondition fails, block execution and guide user to complete Stage 6 first.

## Behavior

1. Verify plugin exists and status is ✅ Working
2. Build plugin in Release mode (optimized, production-ready)
3. Extract PRODUCT_NAME from CMakeLists.txt
...
```

**Problem:**
- Preconditions are in prose with "must" language, but no XML enforcement attributes
- The 10-step behavior sequence is in numbered list format, not structurally enforced
- Claude could proceed past failed preconditions or skip critical steps

**Recommended Fix:**
```xml
<preconditions enforcement="blocking">
  <check target="PLUGINS.md" condition="status_equals" required="true">
    Plugin status MUST be ✅ Working (Stage 6 complete)
  </check>
  <check target="build" condition="exists" required="true">
    Plugin MUST have successful Release build
  </check>
  <check target="validation" condition="passed" required="true">
    pluginval validation MUST have passed
  </check>
  <check target="testing" condition="completed" required="true">
    Plugin MUST have been tested in DAW from build folder
  </check>
  <on_failure action="block">
    Guide user to complete Stage 6 first - DO NOT proceed
  </on_failure>
</preconditions>

<routing>
  <invoke skill="plugin-lifecycle" with="$ARGUMENTS">
    Pass plugin name to plugin-lifecycle skill
  </invoke>
</routing>
```

**Token savings:** Converting to XML saves ~200 tokens by removing redundant behavior details (which belong in the skill, not the command).

## Optimization Opportunities

### Optimization #1: Add argument-hint to frontmatter (Lines 1-4)
**Potential savings:** ~10 tokens (better clarity)
**Current:** Frontmatter missing `argument-hint` field
**Recommended:** Add argument hint for the required parameter

```yaml
---
name: install-plugin
description: Install completed plugin to system folders for DAW use
argument-hint: <PluginName>
---
```

**Impact:** Improves autocomplete UX and makes parameter expectations explicit.

---

### Optimization #2: Remove implementation details (Lines 20-54)
**Potential savings:** ~350 tokens (60% of file)
**Current:** Command contains detailed 10-step behavior specification and success output template
**Recommended:** Delete the "Behavior" and "Success Output" sections entirely - they belong in the plugin-lifecycle skill, not the routing command

**Before (lines 20-54):**
```markdown
## Behavior

1. Verify plugin exists and status is ✅ Working
2. Build plugin in Release mode (optimized, production-ready)
3. Extract PRODUCT_NAME from CMakeLists.txt
4. Remove old versions from system folders
5. Install to:
   - VST3: `~/Library/Audio/Plug-Ins/VST3/`
   - AU: `~/Library/Audio/Plug-Ins/Components/`
6. Set proper permissions (755)
7. Clear DAW caches:
   - Ableton Live: `~/Library/Preferences/Ableton/Live */PluginCache.db`
   - Logic Pro: `~/Library/Caches/AudioUnitCache/*`
   - Kill AudioComponentRegistrar process
8. Verify installation (check timestamps, file sizes)
9. Update PLUGINS.md: ✅ Working → 📦 Installed
10. Save logs to `logs/[PluginName]/build_TIMESTAMP.log`

## Success Output

[Long template...]
```

**After (lean routing):**
```markdown
## Routing

Invoke plugin-lifecycle skill with plugin name from $ARGUMENTS.

The skill handles:
- Precondition validation
- Release build
- System installation
- Cache clearing
- State updates
```

**Impact:** Eliminates duplication between command and skill. The command becomes a true routing layer (15-20 lines instead of 59).

---

### Optimization #3: Document state contracts (Missing)
**Potential savings:** 0 tokens (adds ~50 tokens but improves reliability)
**Current:** Line 35 mentions "Update PLUGINS.md" but doesn't document the contract
**Recommended:** Add explicit state file documentation

```xml
<state_contracts>
  <reads target="PLUGINS.md">
    Plugin entry with status ✅ Working
  </reads>
  <writes target="PLUGINS.md">
    Update status: ✅ Working → 📦 Installed
  </writes>
  <writes target="logs/[PluginName]/build_TIMESTAMP.log">
    Build and installation log output
  </writes>
</state_contracts>
```

**Impact:** Makes the system integration explicit for both Claude and future developers.

---

### Optimization #4: Strengthen routing instruction (Line 8)
**Potential savings:** ~100 tokens (by removing redundant sections)
**Current:** "When user runs `/install-plugin [PluginName]`, invoke the plugin-lifecycle skill."
**Recommended:** Make routing more explicit with parameter passing

```xml
<routing>
  <trigger>User runs /install-plugin [PluginName]</trigger>
  <action required="true">
    Invoke plugin-lifecycle skill via Skill tool
  </action>
  <parameters>
    Pass $ARGUMENTS (plugin name) to skill
  </parameters>
</routing>
```

**Impact:** Structurally enforces the routing pattern instead of prose description.

---

### Optimization #5: Remove "Routes To" footer (Lines 56-58)
**Potential savings:** ~20 tokens
**Current:** Has redundant "Routes To" section at end
**Recommended:** Delete - this is already specified in the routing XML

**Impact:** Eliminates redundancy, saves tokens on every invocation.

## Implementation Priority

### 1. Immediate (Critical issues blocking comprehension)
- **Issue #1:** Wrap preconditions in XML with enforcement="blocking"
- Convert behavior steps to XML or remove entirely (prefer removal)

### 2. High (Major optimizations)
- **Optimization #2:** Remove implementation details (Behavior + Success Output sections)
- **Optimization #4:** Strengthen routing with XML structure

### 3. Medium (Minor improvements)
- **Optimization #1:** Add argument-hint to frontmatter
- **Optimization #3:** Document state contracts
- **Optimization #5:** Remove redundant "Routes To" footer

## Recommended Refactor

Here's the complete refactored command (25 lines vs 59 lines, 58% reduction):

```markdown
---
name: install-plugin
description: Install completed plugin to system folders for DAW use
argument-hint: <PluginName>
---

# /install-plugin

<preconditions enforcement="blocking">
  <check target="PLUGINS.md" condition="status_equals" required="true">
    Plugin status MUST be ✅ Working (Stage 6 complete)
  </check>
  <check target="build" condition="exists" required="true">
    Plugin MUST have successful Release build
  </check>
  <check target="validation" condition="passed" required="true">
    pluginval validation MUST have passed
  </check>
  <on_failure action="block">
    Guide user to complete Stage 6 first - DO NOT proceed
  </on_failure>
</preconditions>

<routing>
  <invoke skill="plugin-lifecycle" with="$ARGUMENTS" required="true">
    Pass plugin name to plugin-lifecycle skill for installation
  </invoke>
</routing>

<state_contracts>
  <reads target="PLUGINS.md">Plugin entry with status ✅ Working</reads>
  <writes target="PLUGINS.md">Update status: ✅ Working → 📦 Installed</writes>
  <writes target="logs/[PluginName]/build_TIMESTAMP.log">Installation logs</writes>
</state_contracts>
```

## Verification Checklist

After implementing fixes, verify:
- [x] YAML frontmatter includes `argument-hint`
- [x] Preconditions use XML with `enforcement="blocking"`
- [x] Routing uses XML structure
- [x] Command is under 30 lines (58% reduction from 59)
- [x] No implementation details (moved to skill)
- [x] State file interactions documented in XML
- [ ] Test: Run `/install-plugin DriveVerb` and verify skill is invoked correctly
- [ ] Test: Run with invalid plugin name and verify blocking behavior

## Token Savings Breakdown

| Optimization | Tokens Saved | Percentage |
|-------------|--------------|------------|
| Remove Behavior section | ~250 | 42% |
| Remove Success Output | ~100 | 17% |
| XML preconditions | ~50 | 8% |
| XML routing | ~30 | 5% |
| Remove Routes To | ~20 | 3% |
| **Total** | **~450** | **76% reduction** |

Final size: ~600 tokens → ~150 tokens (routing layer only)

## Notes

This command suffers from **routing layer contamination** - it contains implementation details that belong in the plugin-lifecycle skill. The command should only:
1. Validate preconditions
2. Route to skill
3. Document state contracts

All the build steps, cache clearing logic, and success message formatting should live in the skill, not the command. This follows the instructed routing pattern where commands are thin routing layers.
