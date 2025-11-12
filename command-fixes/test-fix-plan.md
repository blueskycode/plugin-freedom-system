# Fix Plan: /test

## Summary
- Critical fixes: 2
- Extraction operations: 1
- Total estimated changes: 6
- Estimated time: 15 minutes
- Token savings: 320 tokens (20% reduction)

## Phase 1: Critical Fixes (Blocking Issues)

### Fix 1.1: XML-Wrap Preconditions with Enforcement
**Location:** Lines 10-21
**Operation:** REPLACE
**Severity:** CRITICAL

**Before:**
```markdown
## Preconditions

**Check PLUGINS.md status:**
- Plugin MUST exist
- Status MUST NOT be 💡 Ideated (need implementation to test)

**If status is 💡:**
Reject with message:
```
[PluginName] is not implemented yet (Status: 💡 Ideated).
Use /implement [PluginName] to build it first.
```
```

**After:**
```markdown
## Preconditions

<preconditions enforcement="blocking">
  <check target="PLUGINS.md" condition="plugin_exists">
    Plugin entry MUST exist in PLUGINS.md
  </check>
  <check target="PLUGINS.md::status" condition="not_equals(💡 Ideated)">
    Status MUST NOT be 💡 Ideated (requires implementation to test)
  </check>
  <rejection_message status="💡 Ideated">
[PluginName] is not implemented yet (Status: 💡 Ideated).
Use /implement [PluginName] to build it first.
  </rejection_message>
</preconditions>
```

**Verification:**
- [ ] XML tags properly closed
- [ ] Enforcement attribute set to "blocking"
- [ ] Rejection message preserved exactly
- [ ] Preconditions stop execution when violated

**Token impact:** +40 tokens (adds XML structure, removes redundant prose)

### Fix 1.2: Structure Conditional Routing Logic in XML
**Location:** Lines 23-71
**Operation:** REPLACE
**Severity:** CRITICAL

**Before:**
```markdown
## Three Test Methods

### 1. Automated Stability Tests
**Command:** `/test [PluginName] automated`

**Requirements:** `plugins/[Plugin]/Tests/` directory must exist

**Routes to:** plugin-testing skill

**Duration:** ~2 minutes

**Tests:**
- Parameter stability (all combinations, edge cases)
- State save/restore (preset corruption)
- Processing stability (buffer sizes, sample rates)
- Thread safety (concurrent access)
- Edge case handling (silence, extremes, denormals)

### 2. Build and Validate
**Command:** `/test [PluginName] build`

**Requirements:** None (always available)

**Routes to:** build-automation skill

**Duration:** ~5-10 minutes

**Steps:**
1. Build Release mode (VST3 + AU)
2. Run pluginval with strict settings (level 10)
3. Install to system folders
4. Clear DAW caches

### 3. Manual DAW Testing
**Command:** `/test [PluginName] manual`

**Requirements:** None

**Routes to:** Display checklist directly (no skill)

**Checklist includes:**
- Load & initialize
- Audio processing
- Parameter testing
- State management
- Performance
- Compatibility
- Stress testing
```

**After:**
```markdown
## Three Test Methods

<routing_logic>
  <mode name="automated" argument="automated">
    <requirement path="plugins/{PluginName}/Tests/" type="directory" />
    <routes_to skill="plugin-testing" />
    <duration estimate="2 minutes" />
    <tests>
      - Parameter stability (all combinations, edge cases)
      - State save/restore (preset corruption)
      - Processing stability (buffer sizes, sample rates)
      - Thread safety (concurrent access)
      - Edge case handling (silence, extremes, denormals)
    </tests>
  </mode>

  <mode name="build" argument="build">
    <requirement>Always available (no dependencies)</requirement>
    <routes_to skill="build-automation" />
    <duration estimate="5-10 minutes" />
    <steps>
      1. Build Release mode (VST3 + AU)
      2. Run pluginval with strict settings (level 10)
      3. Install to system folders
      4. Clear DAW caches
    </steps>
  </mode>

  <mode name="manual" argument="manual">
    <requirement>Always available</requirement>
    <routes_to>Display checklist directly (no skill invocation)</routes_to>
    <checklist_items>
      - Load & initialize
      - Audio processing
      - Parameter testing
      - State management
      - Performance
      - Compatibility
      - Stress testing
    </checklist_items>
  </mode>
</routing_logic>
```

**Verification:**
- [ ] XML structure properly nested
- [ ] All three modes defined with distinct arguments
- [ ] Skill routing explicit for automated and build modes
- [ ] Manual mode shows checklist without skill invocation
- [ ] Requirements clearly specified for each mode

**Token impact:** +50 tokens (XML structure adds clarity, reduces parsing ambiguity)

### Fix 1.3: Add State File Documentation
**Location:** After line 21 (before "## Three Test Methods")
**Operation:** INSERT
**Severity:** CRITICAL

**Insert:**
```markdown
<state_interactions>
  <reads>
    - PLUGINS.md (plugin status, test capabilities)
  </reads>
  <writes>
    - None (testing results logged to console, skills handle any state updates)
  </writes>
</state_interactions>
```

**Verification:**
- [ ] Section inserted between Preconditions and Three Test Methods
- [ ] Clearly documents read-only access to PLUGINS.md
- [ ] Notes that command itself doesn't write state

**Token impact:** +30 tokens

## Phase 2: Content Extraction (Token Reduction)

### Fix 2.1: Consolidate Redundant Behavior Descriptions
**Location:** Lines 72-102
**Operation:** REPLACE
**Severity:** HIGH (token efficiency)

**Before:**
```markdown
## Behavior

**Without plugin name:**
List available plugins with test status:
```
Which plugin would you like to test?

1. [PluginName1] v[X.Y.Z] - Has automated tests ✓
2. [PluginName2] v[X.Y.Z] - Build validation only
3. [PluginName3] v[X.Y.Z] - Has automated tests ✓
```

**With plugin, no mode:**
Present test method options:
```
How would you like to test [PluginName]?

1. Automated stability tests (2 min)
   Run test suite - catches crashes, explosions, broken params

2. Build and validate (5-10 min)
   Compile Release build + run pluginval

3. Manual DAW testing (guidance)
   Show testing checklist for real-world validation
```

Options adapt based on what's available (automated only shown if Tests/ exists).

**With plugin and mode:**
Execute test directly.
```

**After:**
```markdown
## Behavior

<behavior>
  <case arguments="none">
    List available plugins with test status from PLUGINS.md
  </case>
  <case arguments="plugin_only">
    Present test method decision menu (adapt based on Tests/ directory existence)
  </case>
  <case arguments="plugin_and_mode">
    Execute test directly via appropriate skill
  </case>
</behavior>
```

**Verification:**
- [ ] Redundant menu examples removed
- [ ] Behavior concisely described in three cases
- [ ] References checkpoint protocol pattern (no need to duplicate)
- [ ] Line count reduced by ~30 lines

**Token impact:** -120 tokens

### Fix 2.2: Extract Error Handling to Shared Protocol Reference
**Location:** Lines 112-149
**Operation:** REPLACE
**Severity:** HIGH (token efficiency)

**Before:**
```markdown
## Error Handling

**Automated tests fail:**
```
❌ [N] tests failed:
  - [testName]: [Description]
  - [testName]: [Description]

Options:
1. Investigate failures (triggers deep-research)
2. Show me the test code
3. Show full test output
4. I'll fix it manually
```

**Build fails:**
```
Build error at [stage]:
[Error output with context]

Options:
1. Investigate (triggers deep-research)
2. Show me the code
3. Show full output
4. I'll fix it manually
```

**Pluginval fails:**
```
Pluginval failed [N] tests:
- [Test name]: [Description]
- [Test name]: [Description]

Options:
1. Investigate failures
2. Show full pluginval report
3. Continue anyway (skip validation)
```
```

**After:**
```markdown
## Error Handling

<error_handling>
  <on_failure type="automated_tests|build|pluginval">
    Present standard failure menu:
    1. Investigate (trigger deep-research skill)
    2. Show me the code
    3. Show full output
    4. I'll fix it manually (or continue anyway for pluginval)
  </on_failure>
</error_handling>
```

**Verification:**
- [ ] Three separate error blocks consolidated into one
- [ ] Pattern clearly describes 4-option failure menu
- [ ] References deep-research skill for investigation
- [ ] Preserves essential error handling behavior

**Token impact:** -80 tokens

## Phase 3: Polish (Clarity & Optimization)

### Fix 3.1: Move Auto-Invocation Documentation to plugin-workflow
**Location:** Lines 104-110
**Operation:** REPLACE
**Severity:** MEDIUM

**Before:**
```markdown
## Auto-Invoked During Workflow

plugin-workflow auto-invokes testing:
- After Stage 4 (DSP) completion
- After Stage 5 (GUI) completion

If tests fail, workflow stops until fixed.
```

**After:**
```markdown
## Integration

This command is also auto-invoked by plugin-workflow after Stage 4 (DSP) and Stage 5 (GUI).
```

**Verification:**
- [ ] Section condensed from 7 lines to 2 lines
- [ ] Key information preserved (auto-invocation context)
- [ ] Detailed workflow behavior belongs in plugin-workflow skill

**Token impact:** -40 tokens

### Fix 3.2: Simplify Output Section
**Location:** Lines 151-160
**Operation:** REPLACE
**Severity:** MEDIUM

**Before:**
```markdown
## Output

After successful testing:
```
✓ [Test method] passed

Next steps:
- Test manually in DAW (if not done)
- /improve [PluginName] if you find issues
```
```

**After:**
```markdown
## Output

After successful testing, display:
- Success message with test method
- Next step suggestions (manual DAW testing, /improve if issues found)
```

**Verification:**
- [ ] Output description condensed
- [ ] Example removed (follows standard checkpoint protocol)
- [ ] Essential information preserved

**Token impact:** -30 tokens

## File Operations Manifest

**Files to modify:**
1. `.claude/commands/test.md` - Apply all fixes from Phases 1-3

**Files to create:**
None (no extractions to separate files needed)

**Files to archive:**
None (command remains active)

## Execution Checklist

**Phase 1 (Critical):**
- [ ] YAML frontmatter complete with all required fields (already complete)
- [ ] Preconditions wrapped in `<preconditions enforcement="blocking">`
- [ ] Routing logic structured in `<routing_logic>` with explicit skill invocation
- [ ] State file interactions documented in `<state_interactions>`
- [ ] No ambiguous pronouns or vague language

**Phase 2 (Extraction):**
- [ ] Redundant behavior descriptions consolidated into `<behavior>` block
- [ ] Error handling blocks unified into single `<error_handling>` reference
- [ ] Token count reduced by 200 tokens minimum

**Phase 3 (Polish):**
- [ ] Auto-invocation section condensed to one-line integration note
- [ ] Output section simplified
- [ ] All instructions use imperative language
- [ ] Command file under 120 lines (down from 160)

**Final Verification:**
- [ ] Command loads without errors
- [ ] Command appears in `/help` with correct description
- [ ] Autocomplete works with argument hints
- [ ] Routing to plugin-testing skill succeeds
- [ ] Routing to build-automation skill succeeds
- [ ] Manual mode displays checklist without skill invocation
- [ ] Preconditions block execution when status is 💡 Ideated
- [ ] Health score improved from 28/40 to estimated 36/40

## Estimated Impact

**Before:**
- Health score: 28/40
- Line count: 160 lines
- Token count: ~1,600 tokens
- Critical issues: 2 (preconditions, routing logic)

**After:**
- Health score: 36/40 (target)
- Line count: 120 lines
- Token count: ~1,280 tokens
- Critical issues: 0

**Improvement:** +8 health points, -20% tokens, -25% line count

## Notes on XML Pattern Application

**Preconditions Pattern:**
The `<preconditions enforcement="blocking">` pattern ensures Claude cannot skip validation even under token pressure. Each `<check>` element specifies:
- `target`: What to check (file, field, state)
- `condition`: The validation rule (exists, equals, not_equals, in)

**Routing Logic Pattern:**
The `<routing_logic>` block makes decision paths explicit. Each `<mode>` element specifies:
- `name`: Descriptive mode name
- `argument`: Actual argument value to match
- `requirement`: Preconditions for this mode
- `routes_to`: Explicit skill name or behavior
- Additional metadata (duration, tests, steps) for clarity

**Behavior Pattern:**
The `<behavior>` block consolidates argument-based branching into three clear cases, referencing the checkpoint protocol pattern instead of duplicating menu examples.

**Error Handling Pattern:**
The `<error_handling>` block provides a template for failure responses across all test types, eliminating redundancy while preserving the essential 4-option recovery menu.

## Verification Commands

After implementing fixes:
```bash
# Verify command loads
claude-code /test --dry-run

# Check health score improvement
# (Re-run analysis after fixes applied)

# Test actual invocation
/test
/test DriveVerb
/test DriveVerb build
```

Expected behavior:
1. `/test` lists available plugins from PLUGINS.md
2. `/test DriveVerb` presents 3-option decision menu
3. `/test DriveVerb build` routes directly to build-automation skill
4. Preconditions block execution if plugin is 💡 Ideated status
