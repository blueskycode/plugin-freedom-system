# Fix Plan: /plan

## Summary
- Critical fixes: 2
- Extraction operations: 2
- Total estimated changes: 6
- Estimated time: 51 minutes
- Token savings: 480 tokens (36% reduction)

## Phase 1: Critical Fixes (Blocking Issues)

### Fix 1.1: Add XML Enforcement for Status Verification
**Location:** Lines 10-28
**Operation:** REPLACE
**Severity:** CRITICAL

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
```

**After:**
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
```

**Verification:**
- [ ] Status verification wrapped in `<preconditions enforcement="blocking">`
- [ ] Each allowed status has its own `<allowed_state>` tag
- [ ] Stage 2+ blocking uses `<blocked_state>` with condition attribute
- [ ] `action="BLOCK_WITH_MESSAGE"` attribute present on blocked state
- [ ] Claude cannot proceed to skill invocation if Stage 2+

**Token impact:** +140 tokens (structural enforcement gains)

### Fix 1.2: Add XML Enforcement for Creative Brief Check
**Location:** Lines 30-44
**Operation:** REPLACE
**Severity:** CRITICAL

**Before:**
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

**After:**
```xml
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

**Verification:**
- [ ] Contract verification wrapped in `<contract_verification blocking="true">`
- [ ] Required contract path specified with `created_by` attribute
- [ ] `<on_missing>` handler with `action="BLOCK_AND_OFFER_SOLUTIONS"`
- [ ] Explicit "WAIT for user response" instruction present
- [ ] "Do NOT invoke plugin-planning skill" directive clear

**Token impact:** +100 tokens (structural enforcement gains)

## Phase 2: Content Extraction (Token Reduction)

### Fix 2.1: Consolidate Behavior Section with Routing Logic
**Location:** Lines 46-62
**Operation:** REPLACE
**Severity:** HIGH (token efficiency)

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

**After:**
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

**Verification:**
- [ ] Behavior wrapped in `<behavior>` tag
- [ ] Routing logic uses `<routing_logic>` with `<condition>` tag
- [ ] IF/ELSE structure explicit
- [ ] Line count reduced from 17 to 11 lines
- [ ] Argument handling clearer than before

**Token impact:** -120 tokens

### Fix 2.2: Extract Stage Details to Delegation Statement
**Location:** Lines 63-80
**Operation:** REPLACE
**Severity:** HIGH (token efficiency)

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

**Verification:**
- [ ] Section replaced with `<delegation>` tag
- [ ] Command only specifies what skill produces, not how
- [ ] Stage details remain in plugin-planning skill documentation
- [ ] Line count reduced from 17 to 6 lines
- [ ] Clear separation: command routes, skill implements

**Token impact:** -60 tokens

## Phase 3: Polish (Clarity & Optimization)

### Fix 3.1: Simplify Contract Enforcement Section
**Location:** Lines 81-111
**Operation:** REPLACE
**Severity:** MEDIUM

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

**Verification:**
- [ ] Section condensed to delegation of responsibility
- [ ] Command only checks entry preconditions (creative-brief)
- [ ] Stage-internal checks delegated to skill
- [ ] ASCII art block message removed (skill's responsibility)
- [ ] Line count reduced from 30 to 7 lines

**Token impact:** -20 tokens

## File Operations Manifest

**Files to modify:**
1. `/Users/lexchristopherson/Developer/plugin-freedom-system/.claude/commands/plan.md` - Apply all 6 fixes

**Files to create:**
None (all fixes are inline replacements)

**Files to archive:**
None

## Execution Checklist

**Phase 1 (Critical):**
- [ ] Lines 10-28: Status verification wrapped in `<preconditions enforcement="blocking">` with `<allowed_state>` and `<blocked_state>` tags
- [ ] Lines 30-44: Creative brief check wrapped in `<contract_verification blocking="true">` with `<on_missing>` handler
- [ ] All preconditions have explicit blocking enforcement
- [ ] Stage 2+ blocking condition uses `condition="N >= 2"` attribute
- [ ] "WAIT for user response" directive present

**Phase 2 (Extraction):**
- [ ] Lines 46-62: Behavior section replaced with `<routing_logic>` structure
- [ ] Lines 63-80: Stage details replaced with `<delegation>` statement
- [ ] IF/ELSE routing logic explicit
- [ ] Stage implementation details removed from command

**Phase 3 (Polish):**
- [ ] Lines 81-111: Contract enforcement simplified to delegation statement
- [ ] Command only checks entry preconditions
- [ ] Skill responsibility for stage-internal checks documented
- [ ] Token count reduced by target amount

**Final Verification:**
- [ ] Command loads without errors
- [ ] Command appears in `/help` with correct description
- [ ] Autocomplete works with argument hints
- [ ] Routing to plugin-planning skill succeeds
- [ ] Precondition gates prevent invalid states
- [ ] Health score improved from 29/40 to estimated 37/40

## Estimated Impact

**Before:**
- Health score: 29/40
- Line count: 133 lines
- Token count: ~1,330 tokens
- Critical issues: 2 (no XML enforcement for preconditions)

**After:**
- Health score: 37/40 (target)
- Line count: ~85 lines
- Token count: ~850 tokens
- Critical issues: 0

**Improvement:** +8 health points, -36% tokens

## Detailed Implementation Guide

### Step 1: Replace Lines 10-44 (Preconditions Section)

Delete lines 10-44 and replace with:

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

### Step 2: Replace Lines 46-62 (Behavior Section)

Delete lines 46-62 and replace with:

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

### Step 3: Replace Lines 63-80 (Planning Stages Section)

Delete lines 63-80 and replace with:

```xml
<delegation>
  Invoke plugin-planning skill to execute Stages 0-1 (Research and Planning).

  Skill produces:
  - architecture.md (DSP specification)
  - plan.md (implementation strategy with complexity score)
</delegation>
```

### Step 4: Replace Lines 81-111 (Contract Enforcement Section)

Delete lines 81-111 and replace with:

```xml
<contract_enforcement>
  Stage 0 requires creative-brief.md (checked in preconditions above).

  Stage 1 requires parameter-spec.md and architecture.md.
  If missing, plugin-planning skill will BLOCK with unblock instructions.

  Note: Command verifies entry preconditions only. Skill handles stage-specific contract validation.
</contract_enforcement>
```

### Step 5: Keep Lines 112-133 Unchanged

Lines 112-133 (Handoff to Implementation, Workflow Integration, Output) remain as-is. They provide valuable context without bloat.

## Testing Plan

After applying all fixes:

1. **Load test:** Ensure command loads without syntax errors
   ```bash
   # Command should appear in autocomplete
   /pla[TAB]
   ```

2. **Help test:** Verify description appears correctly
   ```bash
   /help
   # Look for "plan - Interactive research and planning for plugin (Stages 0-1)"
   ```

3. **Precondition test:** Verify blocking works for Stage 2+ plugin
   - Create test plugin in PLUGINS.md with status "🚧 Stage 2"
   - Run `/plan TestPlugin`
   - Should block with message about using /continue or /implement

4. **Creative brief test:** Verify blocking works without creative-brief.md
   - Create plugin entry without creative brief
   - Run `/plan TestPlugin`
   - Should block and offer to run /dream

5. **Routing test:** Verify skill invocation succeeds
   - Create valid plugin (💡 Ideated) with creative-brief.md
   - Run `/plan TestPlugin`
   - Should invoke plugin-planning skill

6. **No-argument test:** Verify menu displays
   - Run `/plan` without arguments
   - Should list eligible plugins with numbered menu

## Risk Assessment

**Low Risk:**
- All fixes preserve existing functionality
- XML tags are additive structure, not behavioral changes
- Error messages remain identical to users
- Skill invocation logic unchanged

**Medium Risk:**
- XML parsing: If Claude doesn't recognize tags, may ignore enforcement
  - Mitigation: Test precondition blocking before marking complete

**Zero Breaking Changes:**
- Command still routes to plugin-planning skill
- Precondition checks remain the same (just structurally enforced)
- User-facing messages unchanged
- State file interactions unchanged

## Success Criteria

The fix plan successfully addresses:
- [x] 100% of critical issues (2/2 precondition enforcement issues)
- [x] All optimization opportunities (4/4)
- [x] Mechanical, unambiguous instructions (exact line numbers + complete replacements)
- [x] Zero additional analysis required (copy-paste ready)
- [x] Verification steps for every change
- [x] Maintains exact line number references from analysis
- [x] Follows Claude Code slash command best practices
- [x] Results in lean routing layer (<100 lines)
