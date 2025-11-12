# Command Analysis: implement

## Executive Summary
- Overall health: **Yellow** (Functional but lacks XML enforcement structure)
- Critical issues: **3** (No XML precondition enforcement, routing logic buried in prose, no checkpoint protocol structure)
- Optimization opportunities: **4** (Precondition blocks need XML, routing clarity, bash checks extraction, decision menu format)
- Estimated context savings: **850 tokens (35% reduction)**

## Dimension Scores (1-5)
1. Structure Compliance: **4/5** (Good YAML frontmatter with description, could add allowed-tools for bash)
2. Routing Clarity: **4/5** (Clear delegation to plugin-workflow skill, minor instruction noise)
3. Instruction Clarity: **4/5** (Mostly imperative, some conversational phrasing)
4. XML Organization: **2/5** (No XML enforcement - relies entirely on prose and markdown)
5. Context Efficiency: **3/5** (150 lines - reasonable but contains bloat from error messages)
6. Claude-Optimized Language: **4/5** (Mostly imperative, occasional pronoun usage)
7. System Integration: **4/5** (Documents PLUGINS.md, .continue-here.md, and contract files well)
8. Precondition Enforcement: **1/5** (CRITICAL DEFICIENCY - all preconditions in prose, no structural enforcement)

## Critical Issues (blockers for Claude comprehension)

### Issue #1: Precondition Checks Have No XML Enforcement (Lines 12-73)
**Severity:** CRITICAL
**Impact:** Claude may skip precondition validation under token pressure, allowing implementation without contracts

The command has extensive precondition checking logic but it's entirely in prose:
```markdown
**1. Check PLUGINS.md status:**

Valid starting states:
- 🚧 Stage 1 (planning complete) → Start at stage 2
- 🚧 Stage 2-6 (in progress) → Resume from current stage

**Block if wrong state:**

If 💡 Ideated or 🚧 Stage 0:
[Error message block]

If ✅ Working:
[Error message block]

**2. REQUIRE planning artifacts exist:**

Check for required contracts:
```bash
test -f "plugins/${PLUGIN_NAME}/.ideas/architecture.md" || echo "✗ architecture.md MISSING"
test -f "plugins/${PLUGIN_NAME}/.ideas/plan.md" || echo "✗ plan.md MISSING"
test -f "plugins/${PLUGIN_NAME}/.ideas/parameter-spec.md" || echo "✗ parameter-spec.md MISSING"
```
```

**Problem:** Natural language preconditions can be dropped during context compression. No structural enforcement that these must be checked before proceeding.

**Recommended Fix:** Wrap in decision gates with blocking attributes:
```xml
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
        [Same as above]
      </error_message>
    </blocked_state>

    <blocked_state status="✅ Working" action="redirect">
      <error_message>
        [PluginName] is already implemented and working.

        Use /improve [PluginName] to make changes or add features.
      </error_message>
    </blocked_state>
  </decision_gate>

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

**Impact:** Structural enforcement ensures preconditions cannot be skipped. Decision gates survive context compression. Blocking attributes make consequences explicit.

### Issue #2: Routing Logic Not Structurally Separated (Lines 75-90)
**Severity:** HIGH
**Impact:** Command mixes precondition logic with routing instructions, reducing clarity

Lines 75-90 describe routing behavior but it's embedded after 60+ lines of preconditions:
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

**Problem:** Routing logic appears after preconditions, making it easy to miss. No clear separation between "what to check" vs "what to do".

**Recommended Fix:** Use routing section with clear structure:
```xml
<routing>
  <no_argument behavior="interactive_selection">
    <query source="PLUGINS.md" filter="status in (🚧 Stage 1, 🚧 Stage 2-6)">
      List plugins eligible for implementation
    </query>

    <presentation format="numbered_menu">
      Present menu of eligible plugins with their current stage.
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

### Issue #3: No Checkpoint Protocol Documentation (Lines 100-107)
**Severity:** MEDIUM
**Impact:** Command doesn't explicitly state checkpoint behavior, relies on implicit skill knowledge

Lines 100-107 mention checkpoint behavior but don't structure it:
```markdown
Each stage:
1. Invokes specialized subagent via Task tool
2. Commits changes after subagent completes
3. Updates state files (.continue-here.md, PLUGINS.md)
4. Presents numbered decision menu
5. Waits for user response
```

**Problem:** This describes plugin-workflow skill behavior, not command behavior. Creates confusion about responsibility boundaries.

**Recommended Fix:** Clarify command vs skill responsibilities:
```xml
<skill_delegation>
  <command_responsibility>
    This command is a ROUTING LAYER:
    1. Verify preconditions (status check, contract verification)
    2. Invoke plugin-workflow skill via Skill tool
    3. Return control to user
  </command_responsibility>

  <skill_responsibility ref="plugin-workflow">
    The plugin-workflow skill handles implementation orchestration:
    - Dispatcher pattern (invokes foundation-agent, shell-agent, dsp-agent, gui-agent)
    - Checkpoint protocol (commits, state updates, decision menus)
    - Stage progression (2 → 3 → 4 → 5 → 6)

    See .claude/skills/plugin-workflow/SKILL.md for details.
  </skill_responsibility>

  <handoff_point>
    Command completes immediately after invoking plugin-workflow skill.
    All subsequent interaction (stage progression, decision menus) happens within skill context.
  </handoff_point>
</skill_delegation>
```

## Optimization Opportunities

### Optimization #1: Extract Bash Checks to Reference File (Lines 40-47)
**Potential savings:** 150 tokens (10% reduction)
**Current:** Bash commands embedded in command file
**Recommended:** Extract to references/precondition-checks.sh

**Before:**
```markdown
Check for required contracts:
```bash
test -f "plugins/${PLUGIN_NAME}/.ideas/architecture.md" || echo "✗ architecture.md MISSING"
test -f "plugins/${PLUGIN_NAME}/.ideas/plan.md" || echo "✗ plan.md MISSING"
test -f "plugins/${PLUGIN_NAME}/.ideas/parameter-spec.md" || echo "✗ parameter-spec.md MISSING"
```
```

**After:**
```markdown
<contract_verification>
  Execute contract checks (see bash implementation in decision gate above).
  See references/precondition-checks.sh for reusable check functions.
</contract_verification>
```

**New file: references/precondition-checks.sh**
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

### Optimization #2: Condense Error Message Blocks (Lines 48-73)
**Potential savings:** 400 tokens (27% reduction)
**Current:** Three large error message blocks totaling ~50 lines
**Recommended:** Template-based messages with parameter substitution

**Before:**
```markdown
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
```xml
<error_templates>
  <template id="missing_contracts">
    ✗ BLOCKED: Missing planning artifacts

    Implementation requires complete planning contracts:
    {contract_status_list}

    HOW TO UNBLOCK:
    {unblock_instructions}
  </template>

  <template id="planning_incomplete">
    {plugin_name} planning is not complete.
    Run /plan {plugin_name} first to complete stages 0-1.
    Then run /implement to build (stages 2-6).
  </template>

  <template id="already_complete">
    {plugin_name} is already implemented and working.
    Use /improve {plugin_name} to make changes or add features.
  </template>
</error_templates>
```

Store full error message templates in assets/error-messages.json:
```json
{
  "missing_contracts": {
    "header": "✗ BLOCKED: Missing planning artifacts",
    "body": "Implementation requires complete planning contracts:\n\nRequired contracts:\n{contract_checklist}\n\nHOW TO UNBLOCK:\n{unblock_steps}",
    "separator": "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  }
}
```

### Optimization #3: Simplify Stage Description Section (Lines 91-107)
**Potential savings:** 200 tokens (13% reduction)
**Current:** 17 lines describing what plugin-workflow does
**Recommended:** 5-line summary with reference to skill

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
```xml
<implementation_overview>
  This command delegates to plugin-workflow skill, which orchestrates stages 2-6:

  Stage 2 (Foundation) → Stage 3 (Shell) → Stage 4 (DSP) → Stage 5 (GUI) → Stage 6 (Validation)

  Each stage uses specialized subagent, follows checkpoint protocol (commit, state update, decision menu).

  For stage details, see .claude/skills/plugin-workflow/SKILL.md
</implementation_overview>
```

### Optimization #4: Extract Decision Menu Examples (Lines 109-123)
**Potential savings:** 100 tokens (7% reduction)
**Current:** Example decision menu format embedded in command
**Recommended:** Reference system-wide checkpoint protocol documentation

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
```xml
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

## Implementation Priority

### 1. Immediate (Critical issues blocking comprehension)
- Add XML enforcement to preconditions (Issue #1) - Lines 12-73
- Separate routing logic with XML structure (Issue #2) - Lines 75-90

### 2. High (Major optimizations)
- Condense error message blocks (Optimization #2) - Lines 48-73
- Simplify stage description section (Optimization #3) - Lines 91-107

### 3. Medium (Minor improvements)
- Extract bash checks to reference file (Optimization #1) - Lines 40-47
- Extract decision menu examples (Optimization #4) - Lines 109-123
- Clarify checkpoint protocol responsibility (Issue #3) - Lines 100-107

## Verification Checklist

After implementing fixes, verify:
- [ ] YAML frontmatter includes `description` field
- [ ] Preconditions use `<decision_gate>` XML enforcement with blocking attributes
- [ ] Status validation uses `<allowed_state>` and `<blocked_state>` tags
- [ ] Contract verification uses `<required_contracts>` with on_failure handling
- [ ] Routing section separates no-argument vs with-argument behavior
- [ ] Command responsibility vs skill responsibility is explicit
- [ ] Error messages use templates or reference JSON assets
- [ ] Command file is under 100 lines after optimizations
- [ ] Bash commands extracted to references/ where appropriate
- [ ] Decision menu format references system-wide protocol

## Estimated Impact

### Context Reduction
- Extract bash checks: 150 tokens
- Condense error messages: 400 tokens
- Simplify stage descriptions: 200 tokens
- Extract decision menu examples: 100 tokens
- **Total savings: 850 tokens (35% reduction)**

**Baseline:** 150 lines ≈ 2,400 tokens
**After optimization:** ~1,550 tokens (35% reduction)

### Comprehension Improvement: **HIGH**

**Reasons:**
1. **XML decision gates make preconditions structural, not advisory**
   - `<blocked_state>` tags survive context compression
   - `enforcement="blocking"` attribute makes consequence explicit
   - Can't accidentally skip status or contract verification

2. **Clear separation of command vs skill responsibilities**
   - Command = routing layer (verify preconditions, invoke skill)
   - Skill = orchestrator (stages 2-6, checkpoints, subagents)
   - No confusion about who handles decision menus

3. **Error message templates reduce repetition**
   - Single source of truth for error formatting
   - Parameter substitution makes messages consistent
   - Easier to update error guidance

4. **Routing structure makes behavior unambiguous**
   - No argument → interactive menu
   - With argument → direct invocation
   - Clear sequence: parse → verify → invoke

**Risk mitigation:**
- Without XML enforcement: Claude might skip contract checks → implementation fails due to missing architecture.md
- With XML enforcement: Decision gates block execution if contracts missing → prevents wasted work

### Maintenance Improvement: **MEDIUM**

**Reasons:**
1. **Template-based error messages**
   - Change message format once in JSON, applies to all commands
   - Can A/B test different unblocking instruction formats
   - Easy to add localization later

2. **Extracted bash checks**
   - Reusable across multiple commands (implement, plan, improve)
   - Can add unit tests for check functions
   - Easier to update contract requirements

3. **XML schema enables validation**
   - Could build linter to validate decision gate structure
   - Detect missing blocking attributes automatically
   - Verify all error templates exist

**Time savings:**
- Current: ~15 minutes to update error messages across all commands
- After: ~3 minutes (update template once in JSON)

## Additional Notes

### Comparison to plugin-workflow Skill
This command is **much leaner** than the plugin-workflow skill (150 lines vs 411 lines), which is correct. Commands should be routing layers.

**Strengths:**
- Clear delegation to plugin-workflow skill
- Good precondition checking logic
- Reasonable length for a command

**Weaknesses:**
- Preconditions not structurally enforced (same issue as skill)
- Error messages bloat the command file
- No XML tags to protect critical logic from compression

### System Integration Notes

**State files documented:**
- ✓ PLUGINS.md (status field checked in preconditions)
- ✓ .continue-here.md (mentioned in pause/resume section)
- ✓ Contract files (architecture.md, plan.md, parameter-spec.md)

**Integration points documented:**
- ✓ /plan command (for unblocking planning-incomplete state)
- ✓ /dream command (for unblocking missing parameter-spec.md)
- ✓ /continue command (for resuming paused workflows)
- ✓ /improve command (for already-complete plugins)
- ✓ /install-plugin command (workflow completion next step)

**Missing documentation:**
- [ ] Decision menu format reference (should cite .claude/CLAUDE.md checkpoint protocol)
- [ ] Subagent invocation pattern (should reference plugin-workflow for details)
- [ ] Required Reading injection (juce8-critical-patterns.md) - mentioned in skill but not command

### Token Budget Consideration
At 150 lines (~2,400 tokens), this command consumes minimal context. After optimization (100 lines, ~1,550 tokens), it becomes even more efficient.

**For comparison:**
- plugin-workflow skill: ~16,000 tokens (with state-management.md)
- implement command: ~2,400 tokens
- Ratio: 6.7x (skill is appropriately more detailed)

This is healthy - commands should be lightweight routing layers, skills should contain detailed orchestration logic.

### Recommended Fixes Summary

**Critical (do first):**
1. Wrap preconditions in `<decision_gate>` XML with blocking enforcement
2. Add `<allowed_state>` and `<blocked_state>` tags for status validation
3. Add `<required_contracts>` wrapper with on_failure handling

**High priority:**
4. Condense error messages using templates or JSON assets
5. Simplify stage description section (5 lines vs 17)
6. Add `<routing>` section separating no-arg vs with-arg behavior

**Medium priority:**
7. Extract bash checks to references/precondition-checks.sh
8. Add `<skill_delegation>` section clarifying responsibilities
9. Reference system-wide checkpoint protocol for decision menu format

**Total implementation time:** ~60 minutes
**Impact:** High comprehension improvement, medium maintenance improvement, 35% token reduction
