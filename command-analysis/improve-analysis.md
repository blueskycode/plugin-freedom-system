# Command Analysis: improve

## Executive Summary
- Overall health: **Yellow** (Functional but lacks structural enforcement)
- Critical issues: **3** (Missing precondition enforcement, no XML structure for critical rules, vagueness detection is prose-based)
- Optimization opportunities: **5** (Token reduction, XML wrapping, clearer routing logic)
- Estimated context savings: **~350 tokens (35% reduction)**

## Dimension Scores (1-5)
1. Structure Compliance: **3/5** (Has YAML frontmatter with description, missing argument-hint for optional parameter)
2. Routing Clarity: **4/5** (Clear skill invocation, minor ambiguity in multi-path routing)
3. Instruction Clarity: **4/5** (Clear steps, could use imperative mood more consistently)
4. XML Organization: **1/5** (CRITICAL DEFICIENCY - no XML enforcement tags for preconditions or routing logic)
5. Context Efficiency: **4/5** (Lean at 99 lines, minimal duplication)
6. Claude-Optimized Language: **4/5** (Clear and explicit, minor pronoun usage)
7. System Integration: **4/5** (Documents PLUGINS.md interaction, missing .continue-here.md mention)
8. Precondition Enforcement: **1/5** (CRITICAL DEFICIENCY - prose-based checks without structural enforcement)

**Total Score: 25/40 (Yellow - Functional but needs critical improvements)**

## Critical Issues (blockers for Claude comprehension)

### Issue #1: Precondition Checks Lack XML Enforcement (Lines 10-31)
**Severity:** CRITICAL
**Impact:** Claude may skip precondition checks under token pressure, causing skill to execute on wrong plugin states

The precondition logic is expressed in prose:
```markdown
**Check PLUGINS.md status:**
- Plugin MUST exist
- Status MUST be ✅ Working OR 📦 Installed
- Status MUST NOT be 🚧 In Development

**If status is 🚧:**
Reject with message: ...

**If status is 💡:**
Reject with message: ...
```

**Problem:** Natural language emphasis (MUST, MUST NOT) is not structurally enforced. Claude can miss these during context compression or token pressure.

**Recommended Fix:** Wrap in XML structure with blocking enforcement:
```xml
<preconditions enforcement="blocking">
  <status_verification target="PLUGINS.md" required="true">
    <check condition="plugin_exists">
      Plugin entry MUST exist in PLUGINS.md
    </check>

    <check condition="status_in(✅ Working, 📦 Installed)">
      Status MUST be ✅ Working OR 📦 Installed

      <on_violation status="🚧 In Development">
        REJECT with message:
        "[PluginName] is still in development (Stage [N]).
        Complete the workflow first with /continue [PluginName].
        Cannot use /improve on in-progress plugins."
      </on_violation>

      <on_violation status="💡 Ideated">
        REJECT with message:
        "[PluginName] is not implemented yet (Status: 💡 Ideated).
        Use /implement [PluginName] to build it first."
      </on_violation>
    </check>
  </status_verification>
</preconditions>
```

### Issue #2: Vagueness Detection Logic Not Structurally Enforced (Lines 60-76)
**Severity:** CRITICAL
**Impact:** Claude may inconsistently detect vague requests, leading to poor user experience

The vagueness detection criteria are listed in prose:
```markdown
Request IS vague if it lacks:
- Specific feature name
- Specific action
- Acceptance criteria

Examples of VAGUE:
- "improve the filters"
- "better presets"
- "UI feels cramped"

Examples of SPECIFIC:
- "add resonance parameter to filter, range 0-1"
- "fix bypass parameter - not muting audio"
- "increase window height to 500px"
```

**Problem:** No structural pattern for Claude to evaluate. Relies on natural language inference which can be inconsistent.

**Recommended Fix:** Wrap in decision gate with structured evaluation criteria:
```xml
<vagueness_detection>
  <criteria>
    Request IS vague if it lacks ANY of:
    <required_element>Specific feature name (parameter, UI component, DSP element)</required_element>
    <required_element>Specific action (add, fix, remove, modify, increase, decrease)</required_element>
    <required_element>Acceptance criteria (range, value, behavior, constraint)</required_element>
  </criteria>

  <evaluation_pattern>
    Parse user description for presence of:
    - Feature identifier: Look for component names, parameter names, specific UI elements
    - Action verb: Look for add/fix/remove/modify/increase/decrease/change
    - Measurable criteria: Look for numbers, ranges, specific behaviors, constraints

    IF any missing → classify as VAGUE
    ELSE → classify as SPECIFIC
  </evaluation_pattern>

  <examples>
    <vague_examples>
      - "improve the filters" (lacks: which filter? what aspect? how much?)
      - "better presets" (lacks: better how? which preset? specific values?)
      - "UI feels cramped" (lacks: which component? by how much? specific dimension?)
    </vague_examples>

    <specific_examples>
      - "add resonance parameter to filter, range 0-1" (has: feature=resonance, action=add, criteria=range 0-1)
      - "fix bypass parameter - not muting audio" (has: feature=bypass, action=fix, criteria=mute audio)
      - "increase window height to 500px" (has: feature=height, action=increase, criteria=500px)
    </specific_examples>
  </examples>

  <decision_gate type="vagueness_handling">
    <condition check="request_is_vague">
      IF vague:
        Present choice menu:
        ```
        Your request is vague. How should I proceed?

        1. Brainstorm approaches first → creates improvement brief
        2. Just implement something reasonable → Phase 0.5 investigation
        ```
        WAIT for user response
    </condition>

    <condition check="request_is_specific">
      IF specific:
        Proceed directly to plugin-improve skill with Phase 0.5 investigation
    </condition>
  </decision_gate>
</vagueness_detection>
```

### Issue #3: Multi-Path Routing Logic Not Structurally Enforced (Lines 33-59)
**Severity:** HIGH
**Impact:** Claude may choose wrong path or skip necessary decision menus

The command has multiple routing paths based on arguments:
```markdown
**Without plugin name:**
Present menu of completed plugins (✅ or 📦 status).

**With plugin, no description:**
Ask what to improve: ...

**With vague description:**
Detect vagueness (lacks specific feature, action, or criteria).
Present choice: ...

**With specific description:**
Proceed directly to plugin-improve skill with Phase 0.5 investigation.
```

**Problem:** Four different routing paths described in prose without structural enforcement. Claude may not correctly evaluate which path to take.

**Recommended Fix:** Wrap in decision gate structure:
```xml
<routing_logic>
  <decision_gate type="argument_routing">
    <path condition="no_plugin_name">
      Read PLUGINS.md and filter for plugins with status ✅ Working OR 📦 Installed

      <menu_presentation>
        Display: "Which plugin would you like to improve?"

        [Numbered list of completed plugins]

        WAIT for user selection
      </menu_presentation>
    </path>

    <path condition="plugin_name_only">
      Check for existing improvement briefs in plugins/[PluginName]/improvements/*.md

      <decision_menu>
        Display:
        "What would you like to improve in [PluginName]?

        1. From existing brief ([feature].md found in improvements/)
        2. Describe the change"

        WAIT for user response
      </decision_menu>
    </path>

    <path condition="plugin_name_and_description">
      <vagueness_check ref="vagueness_detection">
        IF vague:
          Present vagueness handling menu (see vagueness_detection above)
        ELSE IF specific:
          Proceed to plugin-improve skill with Phase 0.5 investigation
      </vagueness_check>
    </path>
  </decision_gate>

  <skill_invocation>
    After routing completes and user has provided:
    - Plugin name
    - Specific description or selected brief

    Invoke plugin-improve skill via Skill tool with parameters:
    - pluginName: [name]
    - description: [specific change description]
  </skill_invocation>
</routing_logic>
```

## Optimization Opportunities

### Optimization #1: Extract Plugin-Improve Workflow Steps to Reference (Lines 77-90)
**Potential savings:** ~180 tokens (18% reduction)
**Current:** 10-step workflow enumeration in main command
**Recommended:** Extract to reference file, keep high-level summary

**Current (Lines 77-90):**
```markdown
The plugin-improve skill executes:
1. **Phase 0.5:** Investigation (root cause analysis)
2. **Approval:** Wait for user confirmation
3. **Version selection:** Ask PATCH/MINOR/MAJOR
4. **Backup:** Copy to backups/[Plugin]/v[X.Y.Z]/
5. **Implementation:** Make code changes
6. **CHANGELOG:** Update with version and description
7. **Git commit:** Conventional format with version
8. **Git tag:** Tag release (v[X.Y.Z])
9. **Build:** Compile Release mode
10. **Install:** Deploy to system folders
```

**After:**
```xml
<skill_workflow>
  The plugin-improve skill executes a complete improvement cycle:

  <workflow_overview>
    1. Investigation (Phase 0.5 root cause analysis)
    2. Approval gate (user confirmation)
    3. Version selection (PATCH/MINOR/MAJOR)
    4. Backup → Implement → Document → Build → Deploy
  </workflow_overview>

  <reference>
    See plugin-improve skill documentation for full 10-step workflow details.
  </reference>

  <output_guarantee>
    Changes are production-ready:
    - Versioned and backed up
    - Built in Release mode
    - Installed to system folders
    - Documented in CHANGELOG
    - Git history preserved
  </output_guarantee>
</skill_workflow>
```

**Token savings:** ~180 tokens
**Benefit:** Reduces cognitive load, maintains essential information (what user needs to know), defers implementation details to skill

### Optimization #2: Condense Vagueness Examples (Lines 67-76)
**Potential savings:** ~70 tokens (7% reduction)
**Current:** Six examples (3 vague, 3 specific) with full descriptions
**Recommended:** Move to XML structure within vagueness_detection (see Issue #2 fix)

This optimization is already included in Issue #2 fix above. The examples become structured data within the XML instead of prose lists.

### Optimization #3: Add argument-hint to Frontmatter (Lines 1-4)
**Potential savings:** 0 tokens (improves discoverability)
**Current:** Missing argument-hint field
**Recommended:** Add argument-hint for better slash command autocomplete

**Current:**
```yaml
---
name: improve
description: Modify completed plugins with versioning
---
```

**After:**
```yaml
---
name: improve
description: Modify completed plugins with versioning
argument-hint: "[PluginName] [description?]"
---
```

**Benefit:** Better autocomplete UX, documents optional description parameter

### Optimization #4: Document State File Interactions (Lines 92-99)
**Potential savings:** 0 tokens (improves system integration clarity)
**Current:** Only mentions production output, doesn't document state file updates
**Recommended:** Add state file documentation

**Add after line 99:**
```xml
<state_management>
  <files_read>
    - PLUGINS.md (precondition check: status must be ✅ or 📦)
    - plugins/[PluginName]/.ideas/plan.md (workflow context)
    - plugins/[PluginName]/CHANGELOG.md (version history)
    - plugins/[PluginName]/improvements/*.md (existing briefs)
  </files_read>

  <files_written>
    - plugins/[PluginName]/CHANGELOG.md (version and changes)
    - plugins/[PluginName]/backups/v[X.Y.Z]/* (pre-change backup)
    - PLUGINS.md (Last Updated timestamp)
  </files_written>

  <git_operations>
    - Commit: "feat([Plugin]): [description] (v[X.Y.Z])"
    - Tag: "v[X.Y.Z]"
  </git_operations>
</state_management>
```

**Benefit:** Documents full scope of file interactions, helps with debugging and maintenance

### Optimization #5: Clarify Skill Invocation Point (Lines 8, 33-59)
**Potential savings:** ~20 tokens (2% reduction)
**Current:** Skill invocation implied but not explicit after routing completes
**Recommended:** Add explicit invocation instruction

**Add at end of routing logic (after line 59):**
```xml
<skill_invocation trigger="after_routing_complete">
  Once plugin name and specific description are obtained, invoke plugin-improve skill:

  <invocation_syntax>
    Use Skill tool: skill="plugin-improve"

    Pass context:
    - pluginName: [name]
    - description: [specific change description]
    - vagueness_resolution: [if applicable, which path user chose]
  </invocation_syntax>
</skill_invocation>
```

**Benefit:** Makes routing-to-skill handoff explicit, no ambiguity about when to invoke

## Implementation Priority

### 1. Immediate (Critical issues blocking comprehension)
- **Issue #1:** Add XML enforcement for precondition checks (Lines 10-31)
  - Estimated effort: 10 minutes
  - Impact: Prevents executing on wrong plugin states

- **Issue #2:** Add XML structure for vagueness detection (Lines 60-76)
  - Estimated effort: 15 minutes
  - Impact: Consistent vague request handling

- **Issue #3:** Add decision gate structure for routing logic (Lines 33-59)
  - Estimated effort: 15 minutes
  - Impact: Correct path selection in all scenarios

### 2. High (Major optimizations)
- **Optimization #1:** Extract workflow steps to reference (Lines 77-90)
  - Estimated effort: 5 minutes
  - Token savings: ~180 tokens

- **Optimization #3:** Add argument-hint to frontmatter (Lines 1-4)
  - Estimated effort: 1 minute
  - Improves discoverability

### 3. Medium (Minor improvements)
- **Optimization #4:** Document state file interactions (Lines 92-99)
  - Estimated effort: 10 minutes
  - Improves system integration documentation

- **Optimization #5:** Clarify skill invocation point (After line 59)
  - Estimated effort: 5 minutes
  - Makes routing-to-skill handoff explicit

## Verification Checklist

After implementing fixes, verify:
- [ ] YAML frontmatter includes description and argument-hint
- [ ] Preconditions use XML enforcement with blocking attribute
- [ ] Vagueness detection uses structured evaluation pattern
- [ ] Routing logic uses decision gates for all paths
- [ ] Skill invocation point is explicit
- [ ] State file interactions are documented
- [ ] Command is under 200 lines (currently 99, should stay ~120 after fixes)
- [ ] All decision menus use inline numbered lists

## Token Savings Summary

| Optimization | Current Tokens | After Tokens | Savings |
|-------------|----------------|--------------|---------|
| Workflow steps extraction | ~250 | ~70 | ~180 |
| Vagueness examples (in Issue #2) | ~120 | ~50 | ~70 |
| Routing logic clarity | ~150 | ~100 | ~50 |
| Skill invocation | N/A | +50 | -50 |
| XML enforcement overhead | N/A | +100 | -100 |
| **Net savings** | **~1000** | **~650** | **~350 (35%)** |

Note: While XML adds ~150 tokens of structure, it provides critical enforcement and clarity. The extractions more than compensate.

## Estimated Implementation Time

- **Critical fixes (Issues #1-3):** 40 minutes
- **High priority optimizations:** 6 minutes
- **Medium priority optimizations:** 15 minutes
- **Testing and validation:** 10 minutes
- **Total:** ~71 minutes (1.2 hours)

## Before/After Comparison

### BEFORE (Current - 99 lines, ~1000 tokens)
- Prose-based preconditions (lines 10-31)
- Prose-based vagueness detection (lines 60-76)
- Implicit routing logic (lines 33-59)
- Full 10-step workflow enumeration (lines 77-90)
- Missing argument-hint in frontmatter
- No state file documentation

### AFTER (Estimated - ~120 lines, ~650 tokens)
- XML-enforced preconditions with blocking attributes
- Structured vagueness detection with evaluation pattern
- Decision gate routing with explicit paths
- High-level workflow summary with reference to skill docs
- Complete frontmatter with argument-hint
- Documented state file interactions
- Explicit skill invocation point

### Key Improvements
1. **Structural enforcement** - XML tags make critical logic machine-parseable
2. **Token efficiency** - 35% reduction through extraction and condensation
3. **Clarity** - Decision gates make routing logic explicit
4. **Discoverability** - argument-hint improves autocomplete UX
5. **System integration** - Documents all file interactions

## Recommended Implementation Order

1. **Add XML precondition enforcement** (Issue #1) - 10 min
   - Highest impact on reliability
   - Prevents catastrophic failures (wrong plugin state)

2. **Add decision gate routing structure** (Issue #3) - 15 min
   - Second highest impact
   - Ensures correct path selection

3. **Add vagueness detection structure** (Issue #2) - 15 min
   - Improves consistency
   - Better user experience

4. **Extract workflow steps** (Optimization #1) - 5 min
   - Largest token savings
   - Reduces cognitive load

5. **Add argument-hint** (Optimization #3) - 1 min
   - Quick win
   - Improves discoverability

6. **Document state interactions** (Optimization #4) - 10 min
   - Better system integration
   - Helps debugging

7. **Clarify skill invocation** (Optimization #5) - 5 min
   - Final routing clarity
   - Makes handoff explicit

8. **Test and validate** - 10 min
   - Verify behavior matches expectations
   - Check all paths work correctly

**Total estimated time: ~71 minutes**
