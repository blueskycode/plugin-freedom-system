# Command Analysis: plan

## Executive Summary
- Overall health: **Yellow** (Functional but lacks structural enforcement for critical logic)
- Critical issues: **2** (No XML enforcement for preconditions, status blocking lacks structure)
- Optimization opportunities: **4** (Precondition enforcement, behavior routing, contract verification, verbosity reduction)
- Estimated context savings: **480 tokens (36% reduction)**

## Dimension Scores (1-5)
1. Structure Compliance: **5/5** (Complete YAML frontmatter with description)
2. Routing Clarity: **5/5** (Crystal clear - invokes plugin-planning skill immediately)
3. Instruction Clarity: **4/5** (Clear imperative language, minor pronoun usage in lines 46-47)
4. XML Organization: **2/5** (No XML enforcement - relies entirely on prose instructions)
5. Context Efficiency: **3/5** (Reasonable 133 lines, but significant bloat in precondition sections)
6. Claude-Optimized Language: **4/5** (Mostly imperative, occasional descriptive prose)
7. System Integration: **5/5** (Excellent documentation of PLUGINS.md, .continue-here.md, contract files)
8. Precondition Enforcement: **1/5** (CRITICAL DEFICIENCY - all preconditions in prose, no structural enforcement)

## Critical Issues (blockers for Claude comprehension)

### Issue #1: Status Verification Lacks XML Enforcement (Lines 12-28)
**Severity:** CRITICAL
**Impact:** Claude may skip status checks or incorrectly allow blocked states to proceed

The status verification logic is buried in nested markdown lists:
```markdown
**Check PLUGINS.md status:**

1. Verify plugin exists in PLUGINS.md
2. Check current status:
   - If 💡 Ideated: OK to proceed (start fresh)
   - If 🚧 Stage 0: OK to proceed (resume research)
   - If 🚧 Stage 1: OK to proceed (resume planning)
   - If 🚧 Stage 2+: **BLOCK** - Plugin already in implementation
```

**Problem:** Natural language conditions without structural enforcement. Claude can miss the Stage 2+ blocking condition during context compression.

**Recommended Fix:** Wrap in XML with decision gates and enforcement attributes:
```xml
<preconditions enforcement="blocking">
  <status_verification target="PLUGINS.md" required="true">
    <step order="1">Verify plugin entry exists in PLUGINS.md</step>
    <step order="2">Extract current status emoji</step>
    <step order="3">
      Evaluate status against allowed/blocked states:

      <allowed_state status="💡 Ideated">
        OK to proceed - start fresh planning (Stage 0)
      </allowed_state>

      <allowed_state status="🚧 Stage 0">
        OK to proceed - resume research phase
      </allowed_state>

      <allowed_state status="🚧 Stage 1">
        OK to proceed - resume planning phase
      </allowed_state>

      <blocked_state status="🚧 Stage N" condition="N >= 2" action="BLOCK_WITH_MESSAGE">
        [PluginName] is already in implementation (Stage [N]).

        Stages 0-1 (planning) are complete. Use:
        - /continue [PluginName] - Resume from current stage
        - /implement [PluginName] - Review implementation workflow
      </blocked_state>
    </step>
  </status_verification>
</preconditions>
```

### Issue #2: Creative Brief Check Not Structurally Enforced (Lines 30-44)
**Severity:** HIGH
**Impact:** Claude may proceed without creative brief, causing planning skill to fail

The creative brief verification is a critical precondition but lacks structural enforcement:
```markdown
**Check for creative brief:**
```
plugins/[PluginName]/.ideas/creative-brief.md
```

If missing, offer:
```
✗ No creative brief found for [PluginName]

Planning requires a creative brief to define plugin vision.

Would you like to:
1. Create one now (/dream [PluginName])
2. Skip planning (not recommended - leads to implementation drift)
```
```

**Problem:** The check is described procedurally but not wrapped in enforcement structure. No blocking attribute to prevent skill invocation when contract is missing.

**Recommended Fix:** Wrap in decision gate with blocking enforcement:
```xml
<preconditions enforcement="blocking">
  <contract_verification blocking="true">
    <required_contract path="plugins/[PluginName]/.ideas/creative-brief.md" created_by="ideation">
      Creative brief defines plugin vision and serves as input to Stage 0 (Research)
    </required_contract>

    <on_missing action="BLOCK_AND_OFFER_SOLUTIONS">
      Display error message:
      "✗ No creative brief found for [PluginName]

      Planning requires a creative brief to define plugin vision.

      Would you like to:
      1. Create one now (/dream [PluginName])
      2. Skip planning (not recommended - leads to implementation drift)"

      WAIT for user response. Do NOT invoke plugin-planning skill until contract exists.
    </on_missing>
  </contract_verification>
</preconditions>
```

## Optimization Opportunities

### Optimization #1: Precondition Section Bloat (Lines 10-44)
**Potential savings:** 280 tokens (40% reduction in precondition section)
**Current:** 35 lines of nested markdown with repeated structure
**Recommended:** Extract to structured XML and consolidate

**Before:**
```markdown
## Preconditions

**Check PLUGINS.md status:**

1. Verify plugin exists in PLUGINS.md
2. Check current status:
   - If 💡 Ideated: OK to proceed (start fresh)
   - If 🚧 Stage 0: OK to proceed (resume research)
   - If 🚧 Stage 1: OK to proceed (resume planning)
   - If 🚧 Stage 2+: **BLOCK** - Plugin already in implementation

**If plugin is Stage 2 or beyond:**
```
[PluginName] is already in implementation (Stage [N]).

Stages 0-1 (planning) are complete. Use:
- /continue [PluginName] - Resume from current stage
- /implement [PluginName] - Review implementation workflow
```

**Check for creative brief:**
```
plugins/[PluginName]/.ideas/creative-brief.md
```

If missing, offer:
```
✗ No creative brief found for [PluginName]

Planning requires a creative brief to define plugin vision.

Would you like to:
1. Create one now (/dream [PluginName])
2. Skip planning (not recommended - leads to implementation drift)
```
```

**After (condensed with XML):**
```xml
<preconditions enforcement="blocking">
  <status_verification target="PLUGINS.md">
    Verify plugin exists and status allows planning:

    <allowed_states>
      💡 Ideated | 🚧 Stage 0 | 🚧 Stage 1
    </allowed_states>

    <blocked_states condition="stage >= 2">
      BLOCK with message:
      "[PluginName] is already in implementation (Stage [N]).

      Use /continue or /implement instead."
    </blocked_states>
  </status_verification>

  <contract_verification>
    <required path="plugins/[PluginName]/.ideas/creative-brief.md">
      IF missing: BLOCK and offer to run /dream [PluginName]
    </required>
  </contract_verification>
</preconditions>
```

**Token savings:** ~280 tokens (reduced from 35 lines to 20 lines)

### Optimization #2: Behavior Section Verbose (Lines 46-62)
**Potential savings:** 120 tokens (30% reduction in behavior section)
**Current:** 17 lines explaining with/without argument behavior
**Recommended:** Consolidate into structured routing logic

**Before:**
```markdown
## Behavior

**Without argument:**
List plugins eligible for planning:
- Status: 💡 Ideated
- Status: 🚧 Stage 0 (resume)
- Status: 🚧 Stage 1 (resume)

Present numbered menu of eligible plugins or offer to create new plugin.

**With plugin name:**
```bash
/plan [PluginName]
```

Verify preconditions, then invoke the plugin-planning skill.
```

**After (condensed with routing structure):**
```xml
<behavior>
  <routing_logic>
    <condition check="argument_provided">
      IF $ARGUMENTS provided:
        1. Verify preconditions (block if failed)
        2. Invoke plugin-planning skill with plugin name
      ELSE:
        1. List plugins with status: 💡 Ideated, 🚧 Stage 0, 🚧 Stage 1
        2. Present numbered menu of eligible plugins
        3. Offer to create new plugin via /dream
    </condition>
  </routing_logic>
</behavior>
```

**Token savings:** ~120 tokens (reduced from 17 lines to 11 lines)

### Optimization #3: Planning Stages Section Redundant (Lines 64-80)
**Potential savings:** 60 tokens (15% reduction in section)
**Current:** 17 lines explaining what the skill does (belongs in skill, not command)
**Recommended:** Single sentence delegation statement

**Before:**
```markdown
## The Planning Stages

The plugin-planning skill executes:

**Stage 0: Research (5-10 min)**
- Identify plugin technical approach
- Research JUCE DSP modules
- Research professional plugin examples
- Research parameter ranges
- Design sync (if mockup exists)
- Output: architecture.md (DSP specification)

**Stage 1: Planning (2-5 min)**
- Calculate complexity score
- Determine implementation strategy (single-pass vs phased)
- Create phase breakdown for complex plugins
- Output: plan.md (implementation strategy)
```

**After:**
```xml
<delegation>
  Invoke plugin-planning skill to execute Stages 0-1 (Research and Planning).

  Skill produces:
  - architecture.md (DSP specification)
  - plan.md (implementation strategy with complexity score)
</delegation>
```

**Reasoning:** Command is a routing layer - detailed stage breakdown belongs in plugin-planning skill documentation, not the command that invokes it.

**Token savings:** ~60 tokens

### Optimization #4: Contract Enforcement Section Verbose (Lines 82-111)
**Potential savings:** 20 tokens (10% reduction in section)
**Current:** 30 lines with redundant block message
**Recommended:** Consolidate into single enforcement block

**Before:**
```markdown
## Contract Enforcement

**Stage 0 (Research):**
- Requires: creative-brief.md
- Creates: architecture.md

**Stage 1 (Planning) BLOCKS if missing:**
- parameter-spec.md (from UI mockup finalization)
- architecture.md (from Stage 0)

If blocked at Stage 1:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✗ BLOCKED: Cannot proceed to Stage 1
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Missing implementation contracts:
✓ creative-brief.md - exists
✗ parameter-spec.md - MISSING (required)
[✓/✗] architecture.md - [status]

HOW TO UNBLOCK:
1. parameter-spec.md: Complete ui-mockup workflow
   Run: /dream [PluginName] → Choose "Create UI mockup" → Finalize

2. architecture.md: Complete Stage 0 (Research)
   Run: /plan [PluginName] → Complete Stage 0 first

Once both contracts exist, Stage 1 will proceed.
```
```

**After:**
```xml
<contract_enforcement>
  Stage 0 requires creative-brief.md (checked in preconditions above).

  Stage 1 requires parameter-spec.md and architecture.md.
  If missing, plugin-planning skill will BLOCK with unblock instructions.

  Note: Command verifies entry preconditions only. Skill handles stage-specific contract validation.
</contract_enforcement>
```

**Reasoning:** The command should verify preconditions for invoking the skill, but stage-internal contract checking belongs in the skill itself. The detailed block message with ASCII art is skill responsibility.

**Token savings:** ~20 tokens

## Implementation Priority

### 1. Immediate (Critical issues blocking comprehension)
- **Issue #1:** Add XML enforcement for status verification (Lines 12-28)
  - Wrap in `<status_verification>` with `<allowed_state>` and `<blocked_state>` tags
  - Add `enforcement="blocking"` attribute
  - Add `action="BLOCK_WITH_MESSAGE"` to blocked states
  - **Effort:** 10 minutes
  - **Impact:** Prevents incorrectly allowing Stage 2+ plugins to enter planning

- **Issue #2:** Add XML enforcement for creative brief check (Lines 30-44)
  - Wrap in `<contract_verification>` with `<required_contract>` and `<on_missing>` tags
  - Add `blocking="true"` attribute
  - Add explicit "WAIT for user response" instruction
  - **Effort:** 8 minutes
  - **Impact:** Prevents skill invocation without required input contract

### 2. High (Major optimizations)
- **Optimization #1:** Consolidate precondition section with XML (Lines 10-44)
  - Replace nested markdown with structured decision gates
  - Token savings: 280 tokens
  - **Effort:** 15 minutes

- **Optimization #2:** Consolidate behavior section with routing logic (Lines 46-62)
  - Replace prose with structured routing
  - Token savings: 120 tokens
  - **Effort:** 8 minutes

### 3. Medium (Minor improvements)
- **Optimization #3:** Extract stage details to skill documentation (Lines 64-80)
  - Replace with delegation statement
  - Token savings: 60 tokens
  - **Effort:** 5 minutes

- **Optimization #4:** Simplify contract enforcement section (Lines 82-111)
  - Remove stage-internal details (belongs in skill)
  - Token savings: 20 tokens
  - **Effort:** 5 minutes

## Verification Checklist

After implementing fixes, verify:
- [x] YAML frontmatter includes description (already compliant)
- [ ] Preconditions use XML enforcement with blocking attributes
- [ ] Status verification uses `<allowed_state>` and `<blocked_state>` tags
- [ ] Creative brief check uses `<contract_verification>` with `<on_missing>` handler
- [ ] Behavior section uses routing structure instead of prose
- [x] Command is under 200 lines (133 lines - already compliant)
- [x] Routing to plugin-planning skill is explicit (already compliant)
- [x] State file interactions documented (PLUGINS.md, .continue-here.md - already compliant)

## Complete Optimized Version

Here's the command after all fixes applied:

```markdown
---
name: plan
description: Interactive research and planning for plugin (Stages 0-1)
---

# /plan

When user runs `/plan [PluginName?]`, invoke the plugin-planning skill to handle Stages 0-1 (Research and Planning).

<preconditions enforcement="blocking">
  <status_verification target="PLUGINS.md" required="true">
    <step order="1">Verify plugin entry exists in PLUGINS.md</step>
    <step order="2">Extract current status emoji</step>
    <step order="3">
      Evaluate status against allowed/blocked states:

      <allowed_state status="💡 Ideated">
        OK to proceed - start fresh planning (Stage 0)
      </allowed_state>

      <allowed_state status="🚧 Stage 0">
        OK to proceed - resume research phase
      </allowed_state>

      <allowed_state status="🚧 Stage 1">
        OK to proceed - resume planning phase
      </allowed_state>

      <blocked_state status="🚧 Stage N" condition="N >= 2" action="BLOCK_WITH_MESSAGE">
        [PluginName] is already in implementation (Stage [N]).

        Stages 0-1 (planning) are complete. Use:
        - /continue [PluginName] - Resume from current stage
        - /implement [PluginName] - Review implementation workflow
      </blocked_state>
    </step>
  </status_verification>

  <contract_verification blocking="true">
    <required_contract path="plugins/[PluginName]/.ideas/creative-brief.md" created_by="ideation">
      Creative brief defines plugin vision and serves as input to Stage 0 (Research)
    </required_contract>

    <on_missing action="BLOCK_AND_OFFER_SOLUTIONS">
      Display error message:
      "✗ No creative brief found for [PluginName]

      Planning requires a creative brief to define plugin vision.

      Would you like to:
      1. Create one now (/dream [PluginName])
      2. Skip planning (not recommended - leads to implementation drift)"

      WAIT for user response. Do NOT invoke plugin-planning skill until contract exists.
    </on_missing>
  </contract_verification>
</preconditions>

<behavior>
  <routing_logic>
    <condition check="argument_provided">
      IF $ARGUMENTS provided:
        1. Verify preconditions (block if failed)
        2. Invoke plugin-planning skill with plugin name
      ELSE:
        1. List plugins with status: 💡 Ideated, 🚧 Stage 0, 🚧 Stage 1
        2. Present numbered menu of eligible plugins
        3. Offer to create new plugin via /dream
    </condition>
  </routing_logic>
</behavior>

<delegation>
  Invoke plugin-planning skill to execute Stages 0-1 (Research and Planning).

  Skill produces:
  - architecture.md (DSP specification)
  - plan.md (implementation strategy with complexity score)
</delegation>

<contract_enforcement>
  Stage 0 requires creative-brief.md (checked in preconditions above).

  Stage 1 requires parameter-spec.md and architecture.md.
  If missing, plugin-planning skill will BLOCK with unblock instructions.

  Note: Command verifies entry preconditions only. Skill handles stage-specific contract validation.
</contract_enforcement>

## Handoff to Implementation

After Stage 1 completes, the skill creates handoff state:
- .continue-here.md updated with "ready_for_implementation: true"
- User runs `/implement [PluginName]` to begin Stage 2 (Foundation)

## Workflow Integration

Complete plugin development flow:
1. `/dream [PluginName]` - Create creative brief + UI mockup
2. `/plan [PluginName]` - Research and planning (Stages 0-1)
3. `/implement [PluginName]` - Build plugin (Stages 2-6)

## Output

By completion of planning, you have:
- ✅ architecture.md (DSP specification)
- ✅ plan.md (implementation strategy with complexity score)
- ✅ Updated PLUGINS.md status
- ✅ Git commits for both stages
- ✅ Ready for implementation handoff
```

## Estimated Impact Summary

### Token Reduction Breakdown
- Precondition consolidation: 280 tokens
- Behavior consolidation: 120 tokens
- Stage details extraction: 60 tokens
- Contract enforcement simplification: 20 tokens
- **Total savings:** 480 tokens (36% reduction)

**Baseline:** 133 lines ≈ 1,330 tokens
**After optimization:** ~85 lines ≈ 850 tokens (36% reduction)

### Comprehension Improvement: **HIGH**

**Reasons:**
1. **XML enforcement tags make preconditions machine-parseable**
   - Status verification becomes a decision gate with explicit allowed/blocked states
   - Contract verification has blocking enforcement that prevents skill invocation
   - Claude can't accidentally skip checks or allow invalid states

2. **Decision gates survive context compression**
   - `<allowed_state>` and `<blocked_state>` tags act as semantic anchors
   - `enforcement="blocking"` attribute makes consequences explicit
   - Structured routing logic is harder to misinterpret than prose

3. **Clear separation between command and skill responsibilities**
   - Command: Verify entry preconditions, route to skill
   - Skill: Execute stages, handle stage-specific contract validation
   - Reduces confusion about where each check happens

4. **Routing logic is structurally explicit**
   - `<routing_logic>` with `<condition>` tags makes branching obvious
   - IF/ELSE structure is clearer than "with/without argument" prose
   - Makes argument handling predictable

**Risk mitigation:**
- Without XML enforcement: Claude might invoke skill on Stage 2+ plugin → skill errors out
- With XML enforcement: Precondition gates BLOCK execution before skill invocation → clean error messages

### Maintenance Improvement: **MEDIUM**

**Reasons:**
1. **XML structure enables validation**
   - Could build linter to verify all preconditions have enforcement attributes
   - Can programmatically validate allowed/blocked state completeness
   - Easy to detect missing contract checks

2. **Reduced duplication**
   - Stage details moved to skill (single source of truth)
   - Contract enforcement simplified (command checks entry, skill checks stages)
   - Block messages defined once per condition

3. **Token efficiency matters for commands**
   - Commands execute on every invocation (unlike skills loaded once)
   - 36% reduction = faster context loading
   - Cleaner structure = easier to update

**Time savings:**
- Current: ~10 minutes to update precondition logic (navigate nested markdown, ensure consistency)
- After: ~3 minutes (update structured XML gates, validation ensures completeness)

## Examples of Issues Found

### Example 1: Status Verification Buried in Markdown Lists

**BEFORE (Lines 12-28):**
```markdown
**Check PLUGINS.md status:**

1. Verify plugin exists in PLUGINS.md
2. Check current status:
   - If 💡 Ideated: OK to proceed (start fresh)
   - If 🚧 Stage 0: OK to proceed (resume research)
   - If 🚧 Stage 1: OK to proceed (resume planning)
   - If 🚧 Stage 2+: **BLOCK** - Plugin already in implementation

**If plugin is Stage 2 or beyond:**
```
[PluginName] is already in implementation (Stage [N]).

Stages 0-1 (planning) are complete. Use:
- /continue [PluginName] - Resume from current stage
- /implement [PluginName] - Review implementation workflow
```
```

**AFTER:**
```xml
<preconditions enforcement="blocking">
  <status_verification target="PLUGINS.md" required="true">
    <step order="1">Verify plugin entry exists in PLUGINS.md</step>
    <step order="2">Extract current status emoji</step>
    <step order="3">
      Evaluate status against allowed/blocked states:

      <allowed_state status="💡 Ideated">
        OK to proceed - start fresh planning (Stage 0)
      </allowed_state>

      <allowed_state status="🚧 Stage 0">
        OK to proceed - resume research phase
      </allowed_state>

      <allowed_state status="🚧 Stage 1">
        OK to proceed - resume planning phase
      </allowed_state>

      <blocked_state status="🚧 Stage N" condition="N >= 2" action="BLOCK_WITH_MESSAGE">
        [PluginName] is already in implementation (Stage [N]).

        Stages 0-1 (planning) are complete. Use:
        - /continue [PluginName] - Resume from current stage
        - /implement [PluginName] - Review implementation workflow
      </blocked_state>
    </step>
  </status_verification>
</preconditions>
```

**Impact:** Structural enforcement makes status gates machine-parseable, prevents Claude from missing Stage 2+ blocking condition, makes allowed vs blocked states explicit.

### Example 2: Creative Brief Check Without Blocking Enforcement

**BEFORE (Lines 30-44):**
```markdown
**Check for creative brief:**
```
plugins/[PluginName]/.ideas/creative-brief.md
```

If missing, offer:
```
✗ No creative brief found for [PluginName]

Planning requires a creative brief to define plugin vision.

Would you like to:
1. Create one now (/dream [PluginName])
2. Skip planning (not recommended - leads to implementation drift)
```
```

**AFTER:**
```xml
<preconditions enforcement="blocking">
  <contract_verification blocking="true">
    <required_contract path="plugins/[PluginName]/.ideas/creative-brief.md" created_by="ideation">
      Creative brief defines plugin vision and serves as input to Stage 0 (Research)
    </required_contract>

    <on_missing action="BLOCK_AND_OFFER_SOLUTIONS">
      Display error message:
      "✗ No creative brief found for [PluginName]

      Planning requires a creative brief to define plugin vision.

      Would you like to:
      1. Create one now (/dream [PluginName])
      2. Skip planning (not recommended - leads to implementation drift)"

      WAIT for user response. Do NOT invoke plugin-planning skill until contract exists.
    </on_missing>
  </contract_verification>
</preconditions>
```

**Impact:** Explicit blocking enforcement prevents skill invocation without required input, `<on_missing>` handler makes error recovery path structural, "WAIT for user response" prevents auto-proceeding.

### Example 3: Behavior Logic in Prose Instead of Structure

**BEFORE (Lines 46-62):**
```markdown
## Behavior

**Without argument:**
List plugins eligible for planning:
- Status: 💡 Ideated
- Status: 🚧 Stage 0 (resume)
- Status: 🚧 Stage 1 (resume)

Present numbered menu of eligible plugins or offer to create new plugin.

**With plugin name:**
```bash
/plan [PluginName]
```

Verify preconditions, then invoke the plugin-planning skill.
```

**AFTER:**
```xml
<behavior>
  <routing_logic>
    <condition check="argument_provided">
      IF $ARGUMENTS provided:
        1. Verify preconditions (block if failed)
        2. Invoke plugin-planning skill with plugin name
      ELSE:
        1. List plugins with status: 💡 Ideated, 🚧 Stage 0, 🚧 Stage 1
        2. Present numbered menu of eligible plugins
        3. Offer to create new plugin via /dream
    </condition>
  </routing_logic>
</behavior>
```

**Impact:** Structured routing logic makes branching explicit, IF/ELSE is clearer than "with/without" prose, consolidates 17 lines to 11 lines with better clarity.
