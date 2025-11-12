# Fix Plan: /improve

## Summary
- Critical fixes: 3
- Extraction operations: 1
- Total estimated changes: 7
- Estimated time: 71 minutes
- Token savings: 350 tokens (35% reduction)

## Phase 1: Critical Fixes (Blocking Issues)

### Fix 1.1: Add YAML Frontmatter argument-hint
**Location:** Lines 1-4
**Operation:** REPLACE
**Severity:** HIGH (discoverability)

**Before:**
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

**Verification:**
- [ ] YAML frontmatter parses correctly
- [ ] `/help` displays command with description
- [ ] Autocomplete shows argument hint for optional description parameter

**Token impact:** +10 tokens (frontmatter clarity)

---

### Fix 1.2: Add XML Enforcement for Precondition Checks
**Location:** Lines 10-31
**Operation:** WRAP
**Severity:** CRITICAL

**Before:**
```markdown
## Preconditions

**Check PLUGINS.md status:**
- Plugin MUST exist
- Status MUST be ✅ Working OR 📦 Installed
- Status MUST NOT be 🚧 In Development

**If status is 🚧:**
Reject with message:
"[PluginName] is still in development (Stage [N]).
Complete the workflow first with /continue [PluginName].
Cannot use /improve on in-progress plugins."

**If status is 💡:**
Reject with message:
"[PluginName] is not implemented yet (Status: 💡 Ideated).
Use /implement [PluginName] to build it first."
```

**After:**
```markdown
## Preconditions

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

      <on_violation status="[any other status]">
        REJECT with message:
        "[PluginName] has status '[Status]' in PLUGINS.md.
        Only ✅ Working or 📦 Installed plugins can be improved."
      </on_violation>
    </check>
  </status_verification>
</preconditions>
```

**Verification:**
- [ ] XML preconditions parse correctly
- [ ] Claude checks status before proceeding
- [ ] Rejection messages display for invalid states
- [ ] Command refuses to proceed on 🚧 or 💡 status

**Token impact:** +100 tokens (structural enforcement overhead, necessary for reliability)

---

### Fix 1.3: Add Decision Gate Structure for Routing Logic
**Location:** Lines 33-59
**Operation:** WRAP
**Severity:** CRITICAL

**Before:**
```markdown
## Routing

**Without plugin name:**
Present menu of completed plugins (✅ or 📦 status).

**With plugin, no description:**
Ask what to improve:
1. From existing brief ([feature].md found in improvements/)
2. Describe the change

**With vague description:**
Detect vagueness (lacks specific feature, action, or criteria).
Present choice:
1. Brainstorm approaches first → creates improvement brief
2. Just implement something reasonable → Phase 0.5 investigation

**With specific description:**
Proceed directly to plugin-improve skill with Phase 0.5 investigation.
```

**After:**
```markdown
## Routing

<routing_logic>
  <decision_gate type="argument_routing">
    <path condition="no_plugin_name">
      Read PLUGINS.md and filter for plugins with status ✅ Working OR 📦 Installed

      <menu_presentation>
        Display: "Which plugin would you like to improve?"

        [Numbered list of completed plugins with status emoji]

        Example:
        1. DriveVerb (📦 Installed)
        2. CompressorPro (✅ Working)
        3. Other (specify name)

        WAIT for user selection
      </menu_presentation>

      After selection, proceed to path condition="plugin_name_only"
    </path>

    <path condition="plugin_name_only">
      Check for existing improvement briefs in plugins/[PluginName]/improvements/*.md

      <decision_menu>
        IF briefs exist:
          Display:
          "What would you like to improve in [PluginName]?

          1. From existing brief: [brief-name-1].md
          2. From existing brief: [brief-name-2].md
          3. Describe a new change"

        IF no briefs:
          Display:
          "What would you like to improve in [PluginName]?

          Describe the change:"

        WAIT for user response
      </decision_menu>

      After description provided, proceed to vagueness_check
    </path>

    <path condition="plugin_name_and_description">
      Perform vagueness_check (see below)

      <vagueness_check>
        IF request is vague:
          Present vagueness handling menu (see Vagueness Detection section)
        ELSE IF request is specific:
          Proceed to plugin-improve skill with Phase 0.5 investigation
      </vagueness_check>
    </path>
  </decision_gate>

  <skill_invocation trigger="after_routing_complete">
    Once plugin name and specific description are obtained, invoke plugin-improve skill:

    <invocation_syntax>
      Use Skill tool: skill="plugin-improve"

      Pass context:
      - pluginName: [name]
      - description: [specific change description]
      - vagueness_resolution: [if applicable, which path user chose from vagueness menu]
    </invocation_syntax>
  </skill_invocation>
</routing_logic>
```

**Verification:**
- [ ] All four routing paths clearly defined
- [ ] Decision gates have explicit trigger conditions
- [ ] Menu presentations have exact format
- [ ] WAIT instructions present for user input
- [ ] Skill invocation point is explicit

**Token impact:** +50 tokens (routing clarity, necessary for correct path selection)

---

### Fix 1.4: Add XML Structure for Vagueness Detection
**Location:** Lines 60-76
**Operation:** WRAP + EXPAND
**Severity:** CRITICAL

**Before:**
```markdown
## Vagueness Detection

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

**After:**
```markdown
## Vagueness Detection

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

    IF any element missing → classify as VAGUE
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

        1. Brainstorm approaches first → creates improvement brief in plugins/[Name]/improvements/
        2. Just implement something reasonable → Phase 0.5 investigation (I'll propose a specific approach)

        Choose (1-2):
        ```
        WAIT for user response

        IF user chooses 1 (brainstorm):
          Invoke plugin-ideation skill in improvement mode
        ELSE IF user chooses 2 (implement):
          Proceed to plugin-improve skill with Phase 0.5 investigation
    </condition>

    <condition check="request_is_specific">
      IF specific:
        Proceed directly to plugin-improve skill with Phase 0.5 investigation
    </condition>
  </decision_gate>
</vagueness_detection>
```

**Verification:**
- [ ] Vagueness criteria are structured and machine-parseable
- [ ] Evaluation pattern provides explicit parsing steps
- [ ] Examples are categorized with explanations
- [ ] Decision gate handles both vague and specific cases
- [ ] Menu format matches checkpoint protocol

**Token impact:** +70 tokens (structural overhead), -70 tokens (condensed examples) = 0 net

---

## Phase 2: Content Extraction (Token Reduction)

### Fix 2.1: Extract Workflow Steps to Skill Reference
**Location:** Lines 77-90
**Operation:** EXTRACT + REPLACE
**Severity:** HIGH (token efficiency)

**Before:**
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
```markdown
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
    - Versioned and backed up (backups/[Plugin]/v[X.Y.Z]/)
    - Built in Release mode
    - Installed to system folders
    - Documented in CHANGELOG
    - Git history preserved (commit + tag)
  </output_guarantee>
</skill_workflow>
```

**Verification:**
- [ ] Essential information retained (overview, output guarantees)
- [ ] Reference to skill documentation included
- [ ] Line count reduced by ~8 lines
- [ ] User still understands what the skill does

**Token impact:** -180 tokens (major reduction through extraction)

---

## Phase 3: Polish (Clarity & Optimization)

### Fix 3.1: Document State File Interactions
**Location:** After line 99 (end of current content)
**Operation:** INSERT
**Severity:** MEDIUM

**Insert:**
```markdown

## State Management

<state_management>
  <files_read>
    - PLUGINS.md (precondition check: status must be ✅ or 📦)
    - plugins/[PluginName]/.ideas/plan.md (workflow context)
    - plugins/[PluginName]/CHANGELOG.md (version history)
    - plugins/[PluginName]/improvements/*.md (existing improvement briefs)
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

**Verification:**
- [ ] All state file interactions documented
- [ ] Git operations explicitly listed
- [ ] Backup location documented

**Token impact:** +80 tokens (documentation clarity, worth the cost for system integration)

---

### Fix 3.2: Clarify Imperative Language
**Location:** Line 8
**Operation:** REPLACE
**Severity:** LOW

**Before:**
```markdown
When user runs `/improve [PluginName] [description]`, this command routes based on argument presence.
```

**After:**
```markdown
When user runs `/improve [PluginName] [description]`, route based on argument presence (see Routing section below).
```

**Verification:**
- [ ] Language is imperative
- [ ] Reference to routing section is explicit

**Token impact:** -5 tokens (minor clarity improvement)

---

## File Operations Manifest

**Files to modify:**
1. `.claude/commands/improve.md` - All fixes above

**No files to create or archive** - This is a structural improvement to existing command

---

## Execution Checklist

**Phase 1 (Critical):**
- [ ] YAML frontmatter includes `argument-hint: "[PluginName] [description?]"`
- [ ] Preconditions wrapped in `<preconditions enforcement="blocking">`
- [ ] Routing logic uses `<decision_gate>` structure with explicit paths
- [ ] Vagueness detection uses `<vagueness_detection>` with evaluation pattern
- [ ] Skill invocation point is explicit with `<invocation_syntax>`
- [ ] All rejection messages formatted correctly

**Phase 2 (Extraction):**
- [ ] Workflow steps condensed to 4-line overview
- [ ] Reference to skill documentation added
- [ ] Output guarantees preserved
- [ ] Line count reduced by ~8 lines

**Phase 3 (Polish):**
- [ ] State management section added at end
- [ ] All files read/written documented
- [ ] Git operations explicit
- [ ] Imperative language used throughout

**Final Verification:**
- [ ] Command loads without YAML parse errors
- [ ] Command appears in `/help` with correct description
- [ ] Autocomplete shows `[PluginName] [description?]`
- [ ] All four routing paths work correctly
- [ ] Vagueness detection correctly classifies examples
- [ ] Preconditions block execution on invalid status
- [ ] Health score improved from 25/40 to ~35/40 (target)

---

## Estimated Impact

**Before:**
- Health score: 25/40 (Yellow)
- Line count: 99 lines
- Token count: ~1000 tokens
- Critical issues: 3

**After:**
- Health score: 35/40 (Green, target)
- Line count: ~120 lines
- Token count: ~650 tokens
- Critical issues: 0

**Improvement:** +10 health points, -35% tokens

---

## Execution Notes

1. **Order matters:** Execute fixes in the order listed (Phase 1 → 2 → 3)
2. **Line numbers shift:** After each fix, line numbers change. Use search to locate sections.
3. **XML validation:** After each XML addition, verify proper tag closure
4. **Testing:** Test all four routing paths after Phase 1 complete
5. **Backup:** Consider backing up current improve.md before starting

**Estimated total time:** 71 minutes (40 min critical + 5 min extraction + 26 min polish)
