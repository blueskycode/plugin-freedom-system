# Command Analysis: sync-design

## Executive Summary
- Overall health: **Yellow** (Functional but lacks structural enforcement for preconditions)
- Critical issues: **2** (No XML enforcement for preconditions, routing logic implicit)
- Optimization opportunities: **3** (Content extraction, precondition structure, verbosity reduction)
- Estimated context savings: **450 tokens (21% reduction)**

## Dimension Scores (1-5)
1. Structure Compliance: **4/5** (Complete YAML frontmatter with description, missing argument-hint for optional parameter)
2. Routing Clarity: **5/5** (Crystal clear - one line routes to design-sync skill)
3. Instruction Clarity: **4/5** (Clear prose, needs imperative language in key sections)
4. XML Organization: **2/5** (No XML usage - preconditions in markdown lists, no enforcement tags)
5. Context Efficiency: **3/5** (213 lines - reasonable but has duplication in examples and explanatory sections)
6. Claude-Optimized Language: **4/5** (Mostly clear, uses some passive voice "is validated", "is detected")
7. System Integration: **4/5** (Documents required files, mentions state tracking, missing explicit contracts)
8. Precondition Enforcement: **2/5** (Lists preconditions in prose, no XML structure or blocking attributes)

## Critical Issues (blockers for Claude comprehension)

### Issue #1: Preconditions Not Structurally Enforced (Lines 121-128)
**Severity:** CRITICAL
**Impact:** Claude may skip precondition checks under token pressure, leading to skill invocation with missing files

**Current:**
```markdown
## Preconditions

**Required files:**
- `plugins/[Plugin]/.ideas/creative-brief.md` - Original vision
- `plugins/[Plugin]/.ideas/parameter-spec.md` - From finalized mockup
- `plugins/[Plugin]/.ideas/mockups/vN-ui.yaml` - Finalized mockup

If missing, skill will guide you to create them.
```

**Problem:** Preconditions are listed but not enforced. No blocking behavior specified. "If missing, skill will guide you" is too permissive - command should verify BEFORE invoking skill.

**Recommended Fix:**
```xml
<preconditions enforcement="blocking">
  <required_files>
    <file path="plugins/$PLUGIN_NAME/.ideas/creative-brief.md"
          purpose="Original vision"
          created_by="ideation">
      creative-brief.md
    </file>
    <file path="plugins/$PLUGIN_NAME/.ideas/parameter-spec.md"
          purpose="Parameter specification from finalized mockup"
          created_by="ui-mockup Phase 4">
      parameter-spec.md
    </file>
    <file path="plugins/$PLUGIN_NAME/.ideas/mockups/vN-ui.yaml"
          purpose="Finalized UI mockup (N = version number)"
          created_by="ui-mockup"
          pattern="v*-ui.yaml">
      mockup file (any version)
    </file>
  </required_files>

  <validation_sequence>
    <step order="1">Extract plugin name from $ARGUMENTS or prompt user if missing</step>
    <step order="2">
      Check existence of all required files
      ```bash
      PLUGIN_NAME="$1"
      test -f "plugins/${PLUGIN_NAME}/.ideas/creative-brief.md" || MISSING="$MISSING creative-brief.md"
      test -f "plugins/${PLUGIN_NAME}/.ideas/parameter-spec.md" || MISSING="$MISSING parameter-spec.md"
      find "plugins/${PLUGIN_NAME}/.ideas/mockups/" -name "v*-ui.yaml" -type f | grep -q . || MISSING="$MISSING mockup"
      ```
    </step>
    <step order="3">
      IF any files missing:
        BLOCK with message:
        ```
        ✗ BLOCKED: Missing required files for design-sync

        [PluginName] is missing files needed for design validation:
        [List missing files here]

        HOW TO UNBLOCK:
        - Missing creative-brief.md: Run /dream [PluginName] to create
        - Missing mockup: Run /dream [PluginName] and finalize UI mockup
        - Missing parameter-spec.md: Finalize mockup (auto-generated in Phase 4)

        Once all files exist, /sync-design will proceed.
        ```
        DO NOT invoke design-sync skill
    </step>
    <step order="4">
      IF all files present:
        Invoke design-sync skill via Skill tool
    </step>
  </validation_sequence>
</preconditions>
```

**Impact:** Without structural enforcement, Claude may invoke skill with missing files, causing skill to do work that command should have blocked. Wastes tokens and creates confusing error messages from wrong context layer.

### Issue #2: Routing Logic Not Explicit (Lines 6-8)
**Severity:** MEDIUM
**Impact:** Command doesn't explicitly state WHEN to invoke skill vs when to block

**Current:**
```markdown
# /sync-design

Invoke the design-sync skill to validate mockup ↔ creative brief consistency.

## Purpose
...
```

**Problem:** Opens with "Invoke the design-sync skill" but preconditions section later says "If missing, skill will guide you". This creates ambiguity about whether command or skill is responsible for precondition checking.

**Recommended Fix:**
```xml
<routing_logic>
  <decision_gate type="precondition_check">
    When user runs `/sync-design [PluginName?]`:

    <phase_1_parameter_resolution>
      IF no plugin name provided:
        List eligible plugins (have creative-brief.md + mockup finalized)
        Wait for user selection
      ELSE:
        Use provided plugin name
    </phase_1_parameter_resolution>

    <phase_2_precondition_validation>
      Verify required files exist (see <preconditions> above)

      IF any files missing:
        BLOCK - display error and guidance
        DO NOT invoke skill

      IF all files present:
        Proceed to Phase 3
    </phase_2_precondition_validation>

    <phase_3_skill_invocation>
      Invoke design-sync skill via Skill tool with:
      - Plugin name
      - Paths to validated files
    </phase_3_skill_invocation>
  </decision_gate>
</routing_logic>
```

**Impact:** Ambiguous routing logic can cause command to invoke skill when it should block, or block when it should invoke. Clear decision gates prevent this confusion.

## Optimization Opportunities

### Optimization #1: Extract Drift Categories to Reference File (Lines 50-67)
**Potential savings:** 250 tokens (12% reduction)
**Current:** Inline drift category descriptions with 4 categories explained
**Recommended:** Extract to `references/drift-categories.md` or make part of design-sync skill docs

**Current (lines 50-67):**
```markdown
### Drift Categories

**No Drift ✅**
- Everything matches, proceed with confidence

**Acceptable Evolution ✅**
- Minor additions/refinements that improve design
- Documents changes in brief's "Evolution" section
- Proceeds with user approval

**Drift Requiring Attention ⚠️**
- Missing features or style mismatches
- Presents options: Update mockup / Update brief / Override

**Critical Drift ❌**
- Mockup contradicts core concept
- BLOCKS implementation until resolved
- No override option (must fix)
```

**After extraction:**
```markdown
### Drift Handling

The design-sync skill categorizes drift into 4 levels:
✅ No Drift, ✅ Acceptable Evolution, ⚠️ Attention Required, ❌ Critical

See design-sync skill docs for drift category definitions and handling logic.
```

**Reasoning:** Drift categories are implementation details of the skill, not routing logic for the command. Command only needs to know drift detection happens. Detailed categories belong in skill documentation.

### Optimization #2: Consolidate Success Output Examples (Lines 69-119)
**Potential savings:** 150 tokens (7% reduction)
**Current:** Three full decision menu examples (no drift, acceptable evolution, drift detected)
**Recommended:** Single representative example + note that menus adapt to findings

**Current (50 lines of decision menu examples):**
```markdown
## Success Output

### No Drift
```
✓ Design-brief alignment verified
...
What's next?
1. Continue implementation (recommended)
2. Review details
3. Other
```

### Acceptable Evolution
```
⚠️ Design evolution detected (acceptable)
...
What's next?
1. Update brief and continue (recommended)
...
```

### Drift Detected
```
⚠️ Design drift detected
...
What's next?
1. Update mockup - Align with brief
...
```
```

**After consolidation:**
```markdown
## Output

The design-sync skill presents findings and context-appropriate decision menu.

**Example output:**
```
✓ Design-brief alignment verified

- Parameter count: 12 (matches brief)
- All features present: preset browser, bypass, meter
- Visual style aligned: Modern minimal with analog warmth

What's next?
1. Continue implementation (recommended)
2. Review details
3. Other
```

**Menu options adapt based on drift category:**
- No drift: Continue implementation
- Acceptable evolution: Update brief and continue / Review / Revert
- Drift detected: Update mockup / Update brief / Override / Review
- Critical drift: Update mockup / Update brief (no override)

See design-sync skill for complete drift handling logic.
```

**Reasoning:** Command doesn't need to document every possible decision menu - that's skill behavior. One representative example + note about adaptation is sufficient. Detailed menus belong in skill documentation.

### Optimization #3: Technical Details Section Redundant (Lines 171-184)
**Potential savings:** 50 tokens (2% reduction)
**Current:** Technical implementation details about models, validation approach, override tracking
**Recommended:** Remove or reduce to single sentence

**Current (lines 171-184):**
```markdown
## Technical Details

**Models:**
- Sonnet + extended thinking (8k budget)
- Semantic analysis requires creative reasoning

**Validation:**
- Dual-layer (quantitative + semantic)
- Confidence levels (HIGH/MEDIUM/LOW)
- Objective thresholds (from drift-detection.md)

**Override tracking:**
- All overrides logged to `.validator-overrides.yaml`
- Audit trail: why did we proceed with drift?
```

**After reduction:**
```markdown
## Technical Details

The design-sync skill uses dual-layer validation (quantitative + semantic) and logs all override decisions to `.validator-overrides.yaml`.
```

**Reasoning:** Command is routing layer, not implementation spec. Technical details about model selection, validation approach, confidence levels are skill internals. Command only needs to mention override tracking since that creates a user-visible artifact.

### Optimization #4: Convert Passive to Imperative Language
**Potential savings:** Minimal tokens but improves clarity
**Current:** Uses passive voice in several places
**Recommended:** Convert to imperative mood

**Examples:**

Lines 12-13:
```markdown
# BEFORE
Catches design drift before implementation by comparing the finalized UI mockup against the original creative brief.

# AFTER
Compare finalized UI mockup against original creative brief to catch design drift before implementation.
```

Lines 132-139:
```markdown
# BEFORE
**Use when:**
- After mockup finalization (auto-suggested by ui-mockup)
- Before Stage 1 Planning (optional pre-check)
- Anytime you want to verify alignment

# AFTER
**When to use:**
- Run after mockup finalization (auto-suggested by ui-mockup skill)
- Run before Stage 1 Planning as optional pre-check
- Run anytime to verify alignment
```

Lines 192-193:
```markdown
# BEFORE
- `/implement [Plugin]` - Full 7-stage workflow (calls design-sync at Stage 1 if mockup exists)

# AFTER
- `/implement [Plugin]` - Full 7-stage workflow (auto-runs design-sync at Stage 1 if mockup exists)
```

## Implementation Priority

### 1. Immediate (Critical issues blocking comprehension)
   - Add XML precondition enforcement with blocking behavior (Issue #1)
   - Add explicit routing decision gate (Issue #2)

### 2. High (Major optimizations)
   - Extract drift categories to skill docs (Optimization #1)
   - Consolidate decision menu examples (Optimization #2)

### 3. Medium (Minor improvements)
   - Remove/reduce technical details section (Optimization #3)
   - Convert passive to imperative language (Optimization #4)

## Verification Checklist

After implementing fixes, verify:
- [ ] YAML frontmatter includes `argument-hint: "[PluginName]"` for discoverability
- [ ] Preconditions wrapped in XML with `enforcement="blocking"` attribute
- [ ] Validation sequence checks files BEFORE invoking skill
- [ ] Routing logic explicit in decision gate structure
- [ ] Command under 150 lines (currently 213)
- [ ] Drift categories extracted to skill docs (not duplicated in command)
- [ ] Decision menu examples consolidated (one representative example)
- [ ] Technical details reduced to single sentence
- [ ] State file interactions documented (mentions `.validator-overrides.yaml`)

## Recommended Restructure

**New command structure (estimated 120 lines, down from 213):**

```markdown
---
name: sync-design
description: Validate mockup ↔ creative brief consistency
argument-hint: "[PluginName]"
---

# /sync-design

<routing_logic>
  When user runs `/sync-design [PluginName?]`:

  <parameter_resolution>
    IF no plugin name provided:
      List eligible plugins (have creative-brief.md + finalized mockup)
      Wait for user selection
    ELSE:
      Use provided plugin name
  </parameter_resolution>

  <precondition_validation enforcement="blocking">
    Verify required files exist:
    - plugins/[Plugin]/.ideas/creative-brief.md (original vision)
    - plugins/[Plugin]/.ideas/parameter-spec.md (from finalized mockup)
    - plugins/[Plugin]/.ideas/mockups/vN-ui.yaml (finalized mockup)

    <validation_bash>
    ```bash
    PLUGIN_NAME="$1"
    test -f "plugins/${PLUGIN_NAME}/.ideas/creative-brief.md" || MISSING="$MISSING creative-brief.md"
    test -f "plugins/${PLUGIN_NAME}/.ideas/parameter-spec.md" || MISSING="$MISSING parameter-spec.md"
    find "plugins/${PLUGIN_NAME}/.ideas/mockups/" -name "v*-ui.yaml" -type f | grep -q . || MISSING="$MISSING mockup"
    ```
    </validation_bash>

    <on_missing_files action="BLOCK">
      Display error:
      ```
      ✗ BLOCKED: Missing required files for design-sync

      [PluginName] is missing files needed for design validation:
      [List missing files]

      HOW TO UNBLOCK:
      - Missing creative-brief.md: Run /dream [PluginName]
      - Missing mockup: Run /dream [PluginName] and finalize UI
      - Missing parameter-spec.md: Finalize mockup (auto-generated)

      Once all files exist, /sync-design will proceed.
      ```

      DO NOT invoke skill
    </on_missing_files>
  </precondition_validation>

  <skill_invocation>
    IF all preconditions pass:
      Invoke design-sync skill via Skill tool
  </skill_invocation>
</routing_logic>

## Purpose

Compare finalized UI mockup against original creative brief to catch design drift before implementation.

**Detects:**
- Parameter count mismatches (brief: 8, mockup: 12)
- Missing features (brief mentions presets, mockup lacks them)
- Visual style divergence (brief: vintage, mockup: modern)
- Scope creep or reduction

**Prevents:**
- Implementing designs that don't match user's vision
- Wasted work from misaligned expectations
- Surprises during Stage 5 (GUI implementation)

## Usage

```bash
/sync-design [PluginName]
```

## Output

The design-sync skill presents findings and context-appropriate decision menu.

**Example output:**
```
✓ Design-brief alignment verified

- Parameter count: 12 (matches brief)
- All features present: preset browser, bypass, meter
- Visual style aligned: Modern minimal with analog warmth

What's next?
1. Continue implementation (recommended)
2. Review details
3. Other
```

**Menu options adapt based on drift category:**
- No drift: Continue implementation
- Acceptable evolution: Update brief and continue / Review / Revert
- Drift detected: Update mockup / Update brief / Override / Review
- Critical drift: Update mockup / Update brief (no override)

See design-sync skill for drift category definitions and complete handling logic.

## When To Use

**Run when:**
- After mockup finalization (auto-suggested by ui-mockup skill)
- Before Stage 1 Planning as optional pre-check
- Anytime to verify alignment
- When unsure if design matches vision

**Don't run when:**
- Mockup still iterating (v1, v2 - not finalized)
- No creative brief exists
- Just checking visual appearance (use browser instead)

## Integration Points

### Auto-suggested by ui-mockup
After Phase 4 finalization:
```
✓ Mockup finalized: v3

What's next?
1. Check alignment - Run design-sync (recommended) ←
2. Generate implementation files
3. Iterate design
4. Other
```

### Auto-invoked by implement workflow
Before Stage 1 planning:
```
Mockup finalized: Yes (v3)
design-sync validation: Not yet run

Recommendation: Validate alignment before planning

What's next?
1. Run design-sync (recommended) ←
2. Skip validation - Proceed with planning
3. Other
```

## Technical Details

The design-sync skill uses dual-layer validation (quantitative + semantic) and logs all override decisions to `.validator-overrides.yaml` for audit trail.

## Routes To

`design-sync` skill

## Related Commands

- `/implement [Plugin]` - Full 7-stage workflow (auto-runs design-sync at Stage 1 if mockup exists)
- `/improve [Plugin]` - Enhancement workflow (may re-validate design)

## Why This Matters

**Without design-sync:**
- Brief says 8 parameters → Implement 12 → User surprised
- Brief says "vintage warmth" → Implement modern minimal → Rework required
- Brief mentions presets → Forget to implement → Missing feature discovered late

**With design-sync:**
- Drift detected before implementation starts
- User makes informed decision (update mockup / update brief / proceed)
- No surprises, no wasted work

**The feedback loop:**
1. Brief captures vision
2. Mockup iterates design
3. design-sync catches drift
4. User resolves alignment
5. Implementation matches vision
```

**Line count reduction:** 213 → ~120 lines (44% reduction)
**Token savings:** ~450 tokens (21% reduction)
**Comprehension improvement:** HIGH (structural enforcement of preconditions)
**Maintenance improvement:** MEDIUM (clearer separation of command vs skill responsibilities)

## Comparison to Similar Commands

### /implement command
- **Similarities:** Both check preconditions before invoking skill, both list missing files
- **Differences:** /implement uses more structured block message format, more explicit about valid states
- **Lesson:** sync-design should adopt /implement's structured precondition block format

### /improve command
- **Similarities:** Both check plugin status in PLUGINS.md, both route to single skill
- **Differences:** /improve explicitly lists valid states (✅ Working OR 📦 Installed), uses structured rejection messages
- **Lesson:** sync-design should explicitly state valid plugin states (has mockup finalized)

### /test command
- **Similarities:** Both present decision menus, both adapt behavior based on context
- **Differences:** /test shows three distinct test methods, explains when each applies
- **Lesson:** sync-design could clarify that drift detection has both quantitative and semantic modes

## Key Insights from Analysis

1. **Command is actually quite good** - Clear purpose, sensible structure, good documentation
2. **Main weakness is precondition enforcement** - Lists requirements but doesn't structurally enforce
3. **Optimization opportunity is extraction** - 40% of content is skill implementation details
4. **Decision menu examples are redundant** - Skill already handles menu generation
5. **Technical details section is noise** - Command shouldn't document skill internals

## Estimated Impact of All Fixes

**Context efficiency:**
- Before: 213 lines ≈ 2,150 tokens
- After: 120 lines ≈ 1,700 tokens
- Savings: 450 tokens (21% reduction)

**Comprehension improvement:** **HIGH**
- XML preconditions make requirements structurally enforceable
- Decision gate eliminates ambiguity about when to block vs invoke
- Clear separation of command responsibilities (routing/validation) from skill responsibilities (drift detection/analysis)

**Maintenance improvement:** **MEDIUM**
- Extraction reduces duplication (drift categories defined once in skill)
- Precondition structure makes adding new checks easier
- Clearer boundary between command and skill reduces drift risk

**Risk mitigation:**
- Without precondition enforcement: Command may invoke skill with missing files → skill does redundant validation
- With precondition enforcement: Command blocks early with clear guidance → better UX, less token waste
