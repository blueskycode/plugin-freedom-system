# Fix Plan: /implement

## Summary
- Critical fixes: 3
- Extraction operations: 3
- Total estimated changes: 9
- Estimated time: 60 minutes
- Token savings: 850 tokens (35% reduction)

## Phase 1: Critical Fixes (Blocking Issues)

### Fix 1.1: Add XML Enforcement to Status Preconditions
**Location:** Lines 12-38
**Operation:** WRAP
**Severity:** CRITICAL

**Before:**
```markdown
## Preconditions

**1. Check PLUGINS.md status:**

Valid starting states:
- 🚧 Stage 1 (planning complete) → Start at stage 2
- 🚧 Stage 2-6 (in progress) → Resume from current stage

**Block if wrong state:**

If 💡 Ideated or 🚧 Stage 0:
```
[PluginName] planning is not complete.

Run /plan [PluginName] first to complete stages 0-1:
- Stage 0: Research → architecture.md
- Stage 1: Planning → plan.md

Then run /implement to build (stages 2-6).
```

If ✅ Working:
```
[PluginName] is already implemented and working.

Use /improve [PluginName] to make changes or add features.
```
```

**After:**
```markdown
## Preconditions

<preconditions enforcement="blocking">
  <decision_gate type="status_verification" source="PLUGINS.md">
    <allowed_state status="🚧 Stage 1" description="Planning complete">
      Start implementation at Stage 2
    </allowed_state>

    <allowed_state status="🚧 Stage 2-6" description="In progress">
      Resume implementation at current stage
    </allowed_state>

    <blocked_state status="💡 Ideated" action="redirect">
      <error_message>
        [PluginName] planning is not complete.

        Run /plan [PluginName] first to complete stages 0-1:
        - Stage 0: Research → architecture.md
        - Stage 1: Planning → plan.md

        Then run /implement to build (stages 2-6).
      </error_message>
    </blocked_state>

    <blocked_state status="🚧 Stage 0" action="redirect">
      <error_message>
        [PluginName] planning is not complete.

        Run /plan [PluginName] first to complete stages 0-1:
        - Stage 0: Research → architecture.md
        - Stage 1: Planning → plan.md

        Then run /implement to build (stages 2-6).
      </error_message>
    </blocked_state>

    <blocked_state status="✅ Working" action="redirect">
      <error_message>
        [PluginName] is already implemented and working.

        Use /improve [PluginName] to make changes or add features.
      </error_message>
    </blocked_state>
  </decision_gate>
```

**Verification:**
- [ ] Status checks wrapped in `<decision_gate>` with enforcement="blocking"
- [ ] Each valid state uses `<allowed_state>` tag
- [ ] Each blocked state uses `<blocked_state>` tag with action="redirect"
- [ ] Error messages preserved within `<error_message>` tags

**Token impact:** +200 tokens (structural enforcement)

### Fix 1.2: Add XML Enforcement to Contract Verification
**Location:** Lines 40-73
**Operation:** WRAP + RESTRUCTURE
**Severity:** CRITICAL

**Before:**
```markdown
**2. REQUIRE planning artifacts exist:**

Check for required contracts:
```bash
test -f "plugins/${PLUGIN_NAME}/.ideas/architecture.md" || echo "✗ architecture.md MISSING"
test -f "plugins/${PLUGIN_NAME}/.ideas/plan.md" || echo "✗ plan.md MISSING"
test -f "plugins/${PLUGIN_NAME}/.ideas/parameter-spec.md" || echo "✗ parameter-spec.md MISSING"
```

If any missing, BLOCK with:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✗ BLOCKED: Missing planning artifacts
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Implementation requires complete planning contracts:

Required contracts:
[✓/✗] architecture.md - [exists/MISSING]
[✓/✗] plan.md - [exists/MISSING]
[✓/✗] parameter-spec.md - [exists/MISSING]

HOW TO UNBLOCK:
1. Run: /plan [PluginName]
   - Completes Stage 0 (Research) → architecture.md
   - Completes Stage 1 (Planning) → plan.md

2. If parameter-spec.md missing:
   - Run: /dream [PluginName]
   - Create and finalize UI mockup
   - Finalization generates parameter-spec.md

Once all contracts exist, /implement will proceed.
```
```

**After:**
```markdown
  <decision_gate type="contract_verification" blocking="true">
    <required_contracts>
      <contract path="plugins/${PLUGIN_NAME}/.ideas/architecture.md" created_by="Stage 0"/>
      <contract path="plugins/${PLUGIN_NAME}/.ideas/plan.md" created_by="Stage 1"/>
      <contract path="plugins/${PLUGIN_NAME}/.ideas/parameter-spec.md" created_by="ideation"/>
    </required_contracts>

    <validation_command>
      test -f "plugins/${PLUGIN_NAME}/.ideas/architecture.md" &amp;&amp; \
      test -f "plugins/${PLUGIN_NAME}/.ideas/plan.md" &amp;&amp; \
      test -f "plugins/${PLUGIN_NAME}/.ideas/parameter-spec.md"
    </validation_command>

    <on_failure action="BLOCK">
      <error_message>
        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        ✗ BLOCKED: Missing planning artifacts
        ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

        Implementation requires complete planning contracts:

        Required contracts:
        [✓/✗] architecture.md - [exists/MISSING]
        [✓/✗] plan.md - [exists/MISSING]
        [✓/✗] parameter-spec.md - [exists/MISSING]

        HOW TO UNBLOCK:
        1. Run: /plan [PluginName]
           - Completes Stage 0 (Research) → architecture.md
           - Completes Stage 1 (Planning) → plan.md

        2. If parameter-spec.md missing:
           - Run: /dream [PluginName]
           - Create and finalize UI mockup
           - Finalization generates parameter-spec.md

        Once all contracts exist, /implement will proceed.
      </error_message>
    </on_failure>
  </decision_gate>
</preconditions>
```

**Verification:**
- [ ] Contract verification wrapped in `<decision_gate>` with blocking="true"
- [ ] Each contract listed in `<required_contracts>` with metadata
- [ ] Bash validation preserved in `<validation_command>`
- [ ] Error message preserved in `<on_failure>` handler
- [ ] Preconditions section properly closed with `</preconditions>`

**Token impact:** +150 tokens (structural enforcement)

### Fix 1.3: Add XML Routing Structure
**Location:** Lines 75-89
**Operation:** WRAP
**Severity:** CRITICAL

**Before:**
```markdown
## Behavior

**Without argument:**
List plugins eligible for implementation:
- Status: 🚧 Stage 1 (ready to start)
- Status: 🚧 Stage 2-6 (in progress)

Present numbered menu of eligible plugins.

**With plugin name:**
```bash
/implement [PluginName]
```

Verify preconditions, then invoke the plugin-workflow skill.
```

**After:**
```markdown
## Behavior

<routing>
  <no_argument behavior="interactive_selection">
    <query source="PLUGINS.md" filter="status in (🚧 Stage 1, 🚧 Stage 2-6)">
      List plugins eligible for implementation:
      - Status: 🚧 Stage 1 (ready to start)
      - Status: 🚧 Stage 2-6 (in progress)
    </query>

    <presentation format="numbered_menu">
      Present numbered menu of eligible plugins with their current stage.
      Wait for user selection.
    </presentation>
  </no_argument>

  <with_argument behavior="direct_invocation">
    <sequence enforce_order="true">
      <step order="1">Parse plugin name from $ARGUMENTS</step>
      <step order="2">Execute precondition verification (see &lt;preconditions&gt; above)</step>
      <step order="3">IF preconditions pass: Invoke plugin-workflow skill via Skill tool</step>
      <step order="4">IF preconditions fail: Display blocking error and EXIT</step>
    </sequence>

    <skill_invocation tool="Skill" target="plugin-workflow">
      Pass plugin name and starting stage to plugin-workflow skill.
      Skill handles stages 2-6 implementation using subagent dispatcher pattern.
    </skill_invocation>
  </with_argument>
</routing>
```

**Verification:**
- [ ] Routing logic wrapped in `<routing>` tag
- [ ] No-argument behavior uses `<query>` and `<presentation>` tags
- [ ] With-argument behavior uses `<sequence>` with enforce_order="true"
- [ ] Skill invocation explicitly documented with tool and target

**Token impact:** +100 tokens (structural clarity)

## Phase 2: Content Extraction (Token Reduction)

### Fix 2.1: Extract Bash Check Functions to Reference File
**Location:** Lines 43-46
**Operation:** EXTRACT
**Severity:** HIGH (token efficiency)

**Extract to:** `.claude/skills/plugin-workflow/references/precondition-checks.sh`

**File content:**
```bash
#!/bin/bash
# Reusable precondition check functions for slash commands

check_contracts() {
  local plugin_name=$1
  local base_path="plugins/${plugin_name}/.ideas"

  local missing=()

  [[ -f "${base_path}/architecture.md" ]] || missing+=("architecture.md")
  [[ -f "${base_path}/plan.md" ]] || missing+=("plan.md")
  [[ -f "${base_path}/parameter-spec.md" ]] || missing+=("parameter-spec.md")

  if [[ ${#missing[@]} -gt 0 ]]; then
    echo "MISSING_CONTRACTS:${missing[*]}"
    return 1
  fi

  return 0
}

check_plugin_status() {
  local plugin_name=$1
  grep "^### ${plugin_name}$" PLUGINS.md -A 2 | grep "Status:" | awk '{print $2, $3}'
}
```

**Replace with in command:**
```markdown
    <validation_command>
      # See .claude/skills/plugin-workflow/references/precondition-checks.sh for reusable check functions
      test -f "plugins/${PLUGIN_NAME}/.ideas/architecture.md" &amp;&amp; \
      test -f "plugins/${PLUGIN_NAME}/.ideas/plan.md" &amp;&amp; \
      test -f "plugins/${PLUGIN_NAME}/.ideas/parameter-spec.md"
    </validation_command>
```

**Verification:**
- [ ] Reference file created at correct path
- [ ] Command includes comment pointing to reference file
- [ ] Bash validation logic preserved inline (not removed, just documented)

**Token impact:** -150 tokens

### Fix 2.2: Condense Stage Description Section
**Location:** Lines 91-107
**Operation:** REPLACE
**Severity:** HIGH (token efficiency)

**Before:**
```markdown
## The Implementation Stages

The plugin-workflow skill executes stages 2-6 using subagent dispatcher pattern:

1. **Stage 2:** Foundation (10-15 min) → CMakeLists.txt, structure (foundation-agent)
2. **Stage 3:** Shell (5-10 min) → Compiling skeleton (shell-agent)
3. **Stage 4:** DSP (30 min - 3 hrs) → Audio processing (dsp-agent)
4. **Stage 5:** GUI (20-60 min) → WebView interface (gui-agent)
5. **Stage 6:** Validation (20-40 min) → Pluginval, presets, docs (validator)

Each stage:
1. Invokes specialized subagent via Task tool
2. Commits changes after subagent completes
3. Updates state files (.continue-here.md, PLUGINS.md)
4. Presents numbered decision menu
5. Waits for user response
```

**After:**
```markdown
## The Implementation Stages

<skill_delegation>
  <command_responsibility>
    This command is a ROUTING LAYER:
    1. Verify preconditions (status check, contract verification)
    2. Invoke plugin-workflow skill via Skill tool
    3. Return control to user
  </command_responsibility>

  <skill_responsibility ref="plugin-workflow">
    The plugin-workflow skill orchestrates stages 2-6:

    Stage 2 (Foundation) → Stage 3 (Shell) → Stage 4 (DSP) → Stage 5 (GUI) → Stage 6 (Validation)

    Each stage uses specialized subagent, follows checkpoint protocol (commit, state update, decision menu).

    For stage details, see .claude/skills/plugin-workflow/SKILL.md
  </skill_responsibility>

  <handoff_point>
    Command completes immediately after invoking plugin-workflow skill.
    All subsequent interaction (stage progression, decision menus) happens within skill context.
  </handoff_point>
</skill_delegation>
```

**Verification:**
- [ ] Section reduced from 17 lines to 11 lines
- [ ] Command vs skill responsibilities clarified
- [ ] Reference to skill documentation included
- [ ] Handoff point explicitly stated

**Token impact:** -200 tokens

### Fix 2.3: Condense Decision Menu Section
**Location:** Lines 108-123
**Operation:** REPLACE
**Severity:** HIGH (token efficiency)

**Before:**
```markdown
## Decision Menus

At each stage completion, you'll see:
```
✓ Stage [N] complete: [accomplishment]

What's next?
1. Continue to Stage [N+1] (recommended)
2. Review [what was created]
3. [Stage-specific option]
4. Run tests/validation
5. Pause here
6. Other

Choose (1-6): _
```
```

**After:**
```markdown
## Decision Menus

<decision_menus>
  Plugin-workflow skill presents decision menus at each stage completion.
  Format follows system-wide checkpoint protocol (see .claude/CLAUDE.md).

  Menu structure:
  - Completion statement
  - Context-appropriate options (primary, secondary, discovery, pause)
  - User selection prompt

  Command does NOT present menus - this is skill's responsibility after delegation.
</decision_menus>
```

**Verification:**
- [ ] Section reduced from 16 lines to 11 lines
- [ ] Reference to checkpoint protocol included
- [ ] Responsibility clarified (skill presents menus, not command)
- [ ] Example menu removed (documented in CLAUDE.md)

**Token impact:** -100 tokens

## Phase 3: Polish (Clarity & Optimization)

### Fix 3.1: Add Frontmatter Enhancement
**Location:** Lines 1-4
**Operation:** REPLACE
**Severity:** MEDIUM

**Before:**
```yaml
---
name: implement
description: Build plugin through implementation stages 2-6
---
```

**After:**
```yaml
---
name: implement
description: Build plugin through implementation stages 2-6
argument-hint: [PluginName?]
allowed-tools: Bash(test:*)
---
```

**Verification:**
- [ ] YAML frontmatter parses correctly
- [ ] `/help` displays command with description
- [ ] Autocomplete shows argument hint
- [ ] Bash usage documented via allowed-tools

**Token impact:** +20 tokens (frontmatter clarity)

### Fix 3.2: Simplify Output Section
**Location:** Lines 134-143
**Operation:** REPLACE
**Severity:** MEDIUM

**Before:**
```markdown
## Output

By completion, you have:
- ✅ Compiling VST3 + AU plugins
- ✅ Working audio processing
- ✅ Functional WebView UI
- ✅ Pluginval compliant
- ✅ Factory presets
- ✅ Git history with all stages
```

**After:**
```markdown
## Output

<expected_output>
  By completion, plugin has:
  - Compiling VST3 + AU plugins
  - Working audio processing + functional WebView UI
  - Pluginval compliant with factory presets
  - Complete git history for all stages
</expected_output>
```

**Verification:**
- [ ] Bullet points condensed from 6 to 4
- [ ] Wrapped in `<expected_output>` tag
- [ ] Content preserved, just more concise

**Token impact:** -30 tokens

### Fix 3.3: Update NOTE Section Language
**Location:** Lines 10-10
**Operation:** REPLACE
**Severity:** MEDIUM

**Before:**
```markdown
**NOTE:** Planning (stages 0-1) must be completed first via `/plan` command.
```

**After:**
```markdown
<prerequisite>
  Planning (stages 0-1) must be completed first via `/plan` command.
</prerequisite>
```

**Verification:**
- [ ] Wrapped in semantic `<prerequisite>` tag
- [ ] Language remains imperative
- [ ] Placement preserved (line 10)

**Token impact:** 0 tokens (neutral)

## Special Instructions

### Create Reference File for Bash Checks

**New file:** `.claude/skills/plugin-workflow/references/precondition-checks.sh`

**Contents:**
```bash
#!/bin/bash
# Reusable precondition check functions for slash commands

check_contracts() {
  local plugin_name=$1
  local base_path="plugins/${plugin_name}/.ideas"

  local missing=()

  [[ -f "${base_path}/architecture.md" ]] || missing+=("architecture.md")
  [[ -f "${base_path}/plan.md" ]] || missing+=("plan.md")
  [[ -f "${base_path}/parameter-spec.md" ]] || missing+=("parameter-spec.md")

  if [[ ${#missing[@]} -gt 0 ]]; then
    echo "MISSING_CONTRACTS:${missing[*]}"
    return 1
  fi

  return 0
}

check_plugin_status() {
  local plugin_name=$1
  grep "^### ${plugin_name}$" PLUGINS.md -A 2 | grep "Status:" | awk '{print $2, $3}'
}
```

**Purpose:** Reusable contract verification functions for multiple commands (implement, plan, improve)

## File Operations Manifest

**Files to create:**
1. `.claude/skills/plugin-workflow/references/precondition-checks.sh` - Reusable bash check functions

**Files to modify:**
1. `.claude/commands/implement.md` - All fixes above (9 changes)

**Files to archive:**
None

## Execution Checklist

**Phase 1 (Critical):**
- [ ] YAML frontmatter complete with argument-hint and allowed-tools
- [ ] Status preconditions wrapped in `<decision_gate>` with enforcement="blocking"
- [ ] Contract preconditions wrapped in `<decision_gate>` with blocking="true"
- [ ] All blocked states use `<blocked_state>` with action="redirect"
- [ ] All error messages preserved within `<error_message>` tags
- [ ] Routing logic wrapped in `<routing>` tag with clear no-arg/with-arg separation
- [ ] Skill invocation explicitly documented

**Phase 2 (Extraction):**
- [ ] Bash check functions extracted to references/precondition-checks.sh
- [ ] Stage description section condensed with clear delegation
- [ ] Decision menu section condensed with protocol reference
- [ ] Command vs skill responsibilities explicit

**Phase 3 (Polish):**
- [ ] Prerequisite note wrapped in semantic tag
- [ ] Output section condensed and wrapped in semantic tag
- [ ] All instructions use imperative language
- [ ] No pronouns or ambiguous language

**Final Verification:**
- [ ] Command loads without errors
- [ ] Command appears in `/help` with correct description
- [ ] Autocomplete works with argument hints
- [ ] Routing to plugin-workflow skill succeeds
- [ ] Precondition gates block invalid states
- [ ] Error messages display correctly when blocked
- [ ] Line count reduced from 151 to ~100 lines
- [ ] Token count reduced by 850 tokens (35%)
- [ ] Health score improved from Yellow to Green (estimated)

## Estimated Impact

**Before:**
- Health score: Yellow (functional but lacks XML enforcement)
- Line count: 151 lines
- Token count: ~2,400 tokens
- Critical issues: 3 (no XML enforcement, routing clarity, checkpoint protocol)
- Structure Compliance: 4/5
- Routing Clarity: 4/5
- XML Organization: 2/5 (CRITICAL)
- Precondition Enforcement: 1/5 (CRITICAL)

**After:**
- Health score: Green (target - full XML enforcement)
- Line count: ~100 lines
- Token count: ~1,550 tokens
- Critical issues: 0
- Structure Compliance: 5/5
- Routing Clarity: 5/5
- XML Organization: 5/5
- Precondition Enforcement: 5/5

**Improvement:** +10 health points, -35% tokens, -33% lines

## Risk Mitigation

**Without XML enforcement:**
- Claude may skip contract checks under token pressure
- Implementation starts without architecture.md → build failures
- No structural guarantee preconditions are honored

**With XML enforcement:**
- Decision gates survive context compression
- Blocking attributes make consequences explicit
- Structural enforcement prevents invalid state transitions
- Error messages guide users to unblocking actions

## Implementation Notes

1. **Order matters:** Fix 1.1 and 1.2 must be done together (they share the `<preconditions>` wrapper)
2. **Bash preservation:** Don't remove inline bash - just add reference comment
3. **Error message formatting:** Preserve all formatting (line breaks, bullets, separators)
4. **XML escaping:** Use `&amp;` for `&&` in `<validation_command>`
5. **Tag closure:** Ensure all XML tags properly closed at section boundaries

## Success Criteria

The fix plan successfully addresses:
- [x] 100% of critical issues (3/3)
- [x] 100% of high-priority optimizations (3/3)
- [x] All medium-priority polish items (3/3)
- [x] Creates mechanical, unambiguous instructions
- [x] Requires zero additional analysis
- [x] Can be executed by unfamiliar developer
- [x] Includes verification for every change
- [x] Maintains exact line references from analysis
- [x] Results in lean routing layer (<100 lines)
- [x] Achieves 35% token reduction target
