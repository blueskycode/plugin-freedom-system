# Fix Plan: /install-plugin

## Summary
- Critical fixes: 1
- Extraction operations: 2
- Total estimated changes: 7
- Estimated time: 15 minutes
- Token savings: 450 tokens (76% reduction)

## Phase 1: Critical Fixes (Blocking Issues)

### Fix 1.1: Add XML structural enforcement for preconditions
**Location:** Lines 10-18
**Operation:** REPLACE
**Severity:** CRITICAL

**Before:**
```markdown
## Preconditions

Before running this command:
- Plugin status must be ✅ Working (Stage 6 complete)
- Plugin must have successful Release build
- pluginval validation must have passed
- Plugin must have been tested in DAW from build folder

If any precondition fails, block execution and guide user to complete Stage 6 first.
```

**After:**
```markdown
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
```

**Verification:**
- [ ] Preconditions block execution when status is not ✅ Working
- [ ] XML structure enforces sequential check evaluation
- [ ] on_failure block prevents command from proceeding

**Token impact:** -50 tokens (prose → structured XML)

### Fix 1.2: Add argument-hint to frontmatter
**Location:** Lines 1-4
**Operation:** REPLACE
**Severity:** CRITICAL

**Before:**
```yaml
---
name: install-plugin
description: Install completed plugin to system folders for DAW use
---
```

**After:**
```yaml
---
name: install-plugin
description: Install completed plugin to system folders for DAW use
argument-hint: <PluginName>
---
```

**Verification:**
- [ ] YAML frontmatter parses correctly
- [ ] `/help` displays command with description
- [ ] Autocomplete shows argument hint in CLI

**Token impact:** +10 tokens (improved clarity)

### Fix 1.3: Convert routing instruction to XML structure
**Location:** Line 8
**Operation:** REPLACE
**Severity:** CRITICAL

**Before:**
```markdown
When user runs `/install-plugin [PluginName]`, invoke the plugin-lifecycle skill.
```

**After:**
```markdown
<routing>
  <invoke skill="plugin-lifecycle" with="$ARGUMENTS" required="true">
    Pass plugin name to plugin-lifecycle skill for installation
  </invoke>
</routing>
```

**Verification:**
- [ ] Command explicitly invokes skill via structured routing
- [ ] Parameter passing is unambiguous ($ARGUMENTS)
- [ ] Required attribute enforces skill invocation

**Token impact:** -30 tokens (removes redundancy)

## Phase 2: Content Extraction (Token Reduction)

### Fix 2.1: Remove Behavior section (implementation details)
**Location:** Lines 20-36
**Operation:** DELETE
**Severity:** HIGH (token efficiency)

**Delete entirely:**
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
```

**Rationale:** These implementation details belong in the plugin-lifecycle skill, not the routing command. Commands should only validate preconditions and route to skills.

**Verification:**
- [ ] Behavior section completely removed
- [ ] No implementation details remain in command
- [ ] Line count reduced by 17 lines

**Token impact:** -250 tokens

### Fix 2.2: Remove Success Output section
**Location:** Lines 38-54
**Operation:** DELETE
**Severity:** HIGH (token efficiency)

**Delete entirely:**
```markdown
## Success Output

```
✓ [PluginName] installed successfully

Installed formats:
- VST3: ~/Library/Audio/Plug-Ins/VST3/[ProductName].vst3 (X.X MB)
- AU: ~/Library/Audio/Plug-Ins/Components/[ProductName].component (X.X MB)

Cache status: Cleared (all DAWs)

Next steps:
1. Open your DAW (Logic Pro, Ableton Live, etc.)
2. Rescan plugins (or restart DAW)
3. Load plugin in a project
4. Test audio processing and presets
```
```

**Rationale:** Output formatting is an implementation detail that belongs in the skill. The command should not dictate output templates.

**Verification:**
- [ ] Success Output section completely removed
- [ ] No output templates remain in command
- [ ] Line count reduced by 17 lines

**Token impact:** -100 tokens

## Phase 3: Polish (Clarity & Optimization)

### Fix 3.1: Add state contracts documentation
**Location:** After routing section (new insertion after Line 8)
**Operation:** INSERT
**Severity:** MEDIUM

**Insert after routing section:**
```markdown
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

**Verification:**
- [ ] State contracts section added after routing
- [ ] Reads and writes clearly documented
- [ ] Target files explicit (PLUGINS.md, logs)

**Token impact:** +50 tokens (improved reliability)

### Fix 3.2: Remove redundant "Routes To" footer
**Location:** Lines 56-58
**Operation:** DELETE
**Severity:** MEDIUM

**Delete:**
```markdown
## Routes To

`plugin-lifecycle` skill
```

**Rationale:** This information is already specified in the routing XML section. Redundant footer adds no value.

**Verification:**
- [ ] Routes To section completely removed
- [ ] No redundancy between routing XML and footer

**Token impact:** -20 tokens

## File Operations Manifest

**Files to modify:**
1. `.claude/commands/install-plugin.md` - Complete refactor (59 lines → 25 lines)

**Files to verify exist:**
1. `.claude/skills/plugin-lifecycle/SKILL.md` - Skill that handles implementation
2. `PLUGINS.md` - State file for plugin status tracking

## Execution Checklist

**Phase 1 (Critical):**
- [ ] YAML frontmatter includes `argument-hint: <PluginName>`
- [ ] Preconditions wrapped in `<preconditions enforcement="blocking">`
- [ ] Routing uses `<routing>` XML structure with explicit skill invocation
- [ ] No ambiguous pronouns or vague language

**Phase 2 (Extraction):**
- [ ] Behavior section (lines 20-36) completely deleted
- [ ] Success Output section (lines 38-54) completely deleted
- [ ] Implementation details moved to plugin-lifecycle skill
- [ ] Command reduced to routing layer only

**Phase 3 (Polish):**
- [ ] State contracts added with `<state_contracts>` XML
- [ ] Routes To footer (lines 56-58) deleted
- [ ] All instructions use imperative language
- [ ] Token count reduced by ~450 tokens (76% reduction)

**Final Verification:**
- [ ] Command loads without errors
- [ ] Command appears in `/help` with correct description
- [ ] Autocomplete works with argument hint
- [ ] Running `/install-plugin DriveVerb` invokes plugin-lifecycle skill
- [ ] Precondition checks block execution when status is not ✅ Working
- [ ] Health score improved from 27/40 to estimated 38/40

## Estimated Impact

**Before:**
- Health score: 27/40 (Red - below 30 threshold)
- Line count: 59 lines
- Token count: ~600 tokens
- Critical issues: 1 (no XML enforcement)

**After:**
- Health score: 38/40 (Green - target)
- Line count: 25 lines
- Token count: ~150 tokens
- Critical issues: 0

**Improvement:** +11 health points, -76% tokens

## Complete Refactored Command

Here's the final command after all fixes applied:

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
  <check target="testing" condition="completed" required="true">
    Plugin MUST have been tested in DAW from build folder
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

## Token Savings Breakdown

| Optimization | Tokens Saved | Percentage |
|-------------|--------------|------------|
| Remove Behavior section | -250 | 42% |
| Remove Success Output | -100 | 17% |
| XML preconditions | -50 | 8% |
| XML routing | -30 | 5% |
| Remove Routes To | -20 | 3% |
| Add state contracts | +50 | -8% |
| Add argument-hint | +10 | -2% |
| **Total** | **-390** | **65% reduction** |

Final size: ~600 tokens → ~210 tokens (routing layer only)

## Notes

This command suffered from **routing layer contamination** - it contained implementation details that belong in the plugin-lifecycle skill. After refactoring:

**Command responsibilities (routing layer):**
1. Validate preconditions with XML enforcement
2. Route to plugin-lifecycle skill
3. Document state contracts

**Skill responsibilities (plugin-lifecycle):**
1. Build plugin in Release mode
2. Extract PRODUCT_NAME from CMakeLists.txt
3. Install to system folders (VST3, AU)
4. Set permissions
5. Clear DAW caches
6. Verify installation
7. Update PLUGINS.md status
8. Generate success output

This follows the instructed routing pattern where commands are thin routing layers (<50 lines typical) and skills contain all implementation logic.
