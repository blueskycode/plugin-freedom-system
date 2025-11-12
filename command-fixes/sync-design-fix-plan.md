# Fix Plan: /sync-design

## Summary
- Critical fixes: **2**
- Extraction operations: **3**
- Total estimated changes: **8**
- Estimated time: **25** minutes
- Token savings: **450 tokens (21% reduction)**

## Phase 1: Critical Fixes (Blocking Issues)

### Fix 1.1: Add XML Precondition Enforcement
**Location:** Lines 121-128
**Operation:** REPLACE
**Severity:** CRITICAL

**Before:**
```markdown
## Preconditions

**Required files:**
- `plugins/[Plugin]/.ideas/creative-brief.md` - Original vision
- `plugins/[Plugin]/.ideas/parameter-spec.md` - From finalized mockup
- `plugins/[Plugin]/.ideas/mockups/vN-ui.yaml` - Finalized mockup

If missing, skill will guide you to create them.
```

**After:**
```markdown
## Preconditions

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

**Verification:**
- [ ] Preconditions wrapped in XML with `enforcement="blocking"` attribute
- [ ] Validation sequence checks files BEFORE invoking skill
- [ ] BLOCK message provides clear guidance on how to unblock
- [ ] Command does not invoke skill when files missing

**Token impact:** +200 tokens (structural enforcement clarity)

### Fix 1.2: Add YAML frontmatter argument-hint
**Location:** Lines 1-4
**Operation:** REPLACE
**Severity:** CRITICAL

**Before:**
```yaml
---
name: sync-design
description: Validate mockup ↔ creative brief consistency
---
```

**After:**
```yaml
---
name: sync-design
description: Validate mockup ↔ creative brief consistency
argument-hint: "[PluginName]"
---
```

**Verification:**
- [ ] YAML frontmatter parses correctly
- [ ] `/help` displays command with description
- [ ] Autocomplete shows argument hint for plugin name

**Token impact:** +10 tokens (frontmatter clarity)

### Fix 1.3: Add Explicit Routing Decision Gate
**Location:** Lines 6-8
**Operation:** WRAP
**Severity:** CRITICAL

**Before:**
```markdown
# /sync-design

Invoke the design-sync skill to validate mockup ↔ creative brief consistency.

## Purpose
```

**After:**
```markdown
# /sync-design

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
      Verify required files exist (see <preconditions> below)

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

## Purpose
```

**Verification:**
- [ ] Routing logic explicit in decision gate structure
- [ ] Three phases clearly defined: parameter resolution → precondition validation → skill invocation
- [ ] BLOCK behavior explicit when files missing
- [ ] Skill invocation only happens after all preconditions pass

**Token impact:** +120 tokens (routing clarity)

## Phase 2: Content Extraction (Token Reduction)

### Fix 2.1: Extract Drift Categories to Skill Documentation
**Location:** Lines 50-67
**Operation:** EXTRACT
**Severity:** HIGH (token efficiency)

**Extract from command (delete lines 50-67):**
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

**Replace with in command:**
```markdown
### Drift Handling

The design-sync skill categorizes drift into 4 levels:
✅ No Drift, ✅ Acceptable Evolution, ⚠️ Attention Required, ❌ Critical

See design-sync skill docs for drift category definitions and handling logic.
```

**Note:** The drift categories are already defined in `.claude/skills/design-sync/references/drift-detection.md`, so this extraction simply removes duplication from the command file. No new file needs to be created.

**Verification:**
- [ ] Lines 50-67 replaced with 3-line summary
- [ ] Reference to skill docs included
- [ ] Line count reduced by approximately 14 lines
- [ ] Drift categories remain accessible in skill documentation

**Token impact:** -250 tokens (12% reduction)

### Fix 2.2: Consolidate Success Output Examples
**Location:** Lines 69-119
**Operation:** EXTRACT
**Severity:** HIGH (token efficiency)

**Before (50 lines of decision menu examples):**
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

**After (consolidated to 20 lines):**
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

**Verification:**
- [ ] Multiple decision menu examples replaced with single representative example
- [ ] Note about menu adaptation included
- [ ] Reference to skill for complete logic
- [ ] Line count reduced by approximately 30 lines

**Token impact:** -150 tokens (7% reduction)

### Fix 2.3: Reduce Technical Details Section
**Location:** Lines 171-184
**Operation:** REPLACE
**Severity:** MEDIUM (token efficiency)

**Before (14 lines):**
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

**After (3 lines):**
```markdown
## Technical Details

The design-sync skill uses dual-layer validation (quantitative + semantic) and logs all override decisions to `.validator-overrides.yaml` for audit trail.
```

**Verification:**
- [ ] Technical implementation details removed
- [ ] Override tracking retained (user-visible artifact)
- [ ] Line count reduced by approximately 11 lines

**Token impact:** -50 tokens (2% reduction)

## Phase 3: Polish (Clarity & Optimization)

### Fix 3.1: Convert Passive to Imperative Language (Lines 12-13)
**Location:** Line 12
**Operation:** REPLACE
**Severity:** MEDIUM

**Before:**
```markdown
Catches design drift before implementation by comparing the finalized UI mockup against the original creative brief.
```

**After:**
```markdown
Compare finalized UI mockup against original creative brief to catch design drift before implementation.
```

**Verification:**
- [ ] Language is imperative ("Compare" not "Catches")
- [ ] Meaning preserved
- [ ] Clearer action-oriented phrasing

**Token impact:** -2 tokens

### Fix 3.2: Convert Passive to Imperative Language (Lines 132-139)
**Location:** Lines 132-139
**Operation:** REPLACE
**Severity:** MEDIUM

**Before:**
```markdown
**Use when:**
- After mockup finalization (auto-suggested by ui-mockup)
- Before Stage 1 Planning (optional pre-check)
- Anytime you want to verify alignment
```

**After:**
```markdown
**Run when:**
- After mockup finalization (auto-suggested by ui-mockup skill)
- Before Stage 1 Planning as optional pre-check
- Anytime to verify alignment
```

**Verification:**
- [ ] "Use when" → "Run when" (imperative)
- [ ] "you want to" removed (no pronouns)
- [ ] Explicit action verbs ("Run")

**Token impact:** -5 tokens

### Fix 3.3: Convert Passive to Imperative Language (Line 192)
**Location:** Line 192
**Operation:** REPLACE
**Severity:** MEDIUM

**Before:**
```markdown
- `/implement [Plugin]` - Full 7-stage workflow (calls design-sync at Stage 1 if mockup exists)
```

**After:**
```markdown
- `/implement [Plugin]` - Full 7-stage workflow (auto-runs design-sync at Stage 1 if mockup exists)
```

**Verification:**
- [ ] "calls" → "auto-runs" (clearer automation)
- [ ] More precise description of behavior

**Token impact:** -1 token

## File Operations Manifest

**Files to modify:**
1. `.claude/commands/sync-design.md` - Apply all fixes above

**Files referenced (no changes needed):**
1. `.claude/skills/design-sync/references/drift-detection.md` - Already contains drift categories
2. `.claude/skills/design-sync/SKILL.md` - Already contains skill implementation details

## Execution Checklist

**Phase 1 (Critical):**
- [ ] YAML frontmatter includes `argument-hint: "[PluginName]"`
- [ ] Preconditions wrapped in `<preconditions enforcement="blocking">`
- [ ] Validation sequence checks files BEFORE invoking skill
- [ ] Routing logic explicit in decision gate structure
- [ ] BLOCK behavior clear when preconditions fail
- [ ] No ambiguous pronouns or vague language in routing

**Phase 2 (Extraction):**
- [ ] Drift categories section reduced to 3-line summary
- [ ] Reference to skill docs for drift category definitions
- [ ] Decision menu examples consolidated to single representative example
- [ ] Technical details reduced to single sentence
- [ ] All references updated in command file

**Phase 3 (Polish):**
- [ ] All instructions use imperative language ("Compare", "Run", "auto-runs")
- [ ] No passive voice in key sections
- [ ] No pronouns ("you want to" removed)
- [ ] Clear action-oriented phrasing throughout

**Final Verification:**
- [ ] Command loads without errors
- [ ] Command appears in `/help` with correct description
- [ ] Autocomplete works with `[PluginName]` argument hint
- [ ] Routing to skill succeeds after preconditions pass
- [ ] BLOCK message displays when files missing
- [ ] Health score improved from Yellow to Green

## Estimated Impact

**Before:**
- Health score: **Yellow** (functional but lacks structural enforcement)
- Dimension scores: 4/5, 5/5, 4/5, 2/5, 3/5, 4/5, 4/5, 2/5
- Line count: **213 lines**
- Token count: **~2,150 tokens**
- Critical issues: **2**

**After:**
- Health score: **Green** (target)
- Dimension scores: 5/5, 5/5, 5/5, 5/5, 5/5, 5/5, 5/5, 5/5 (target)
- Line count: **~120 lines**
- Token count: **~1,700 tokens**
- Critical issues: **0**

**Improvement:** Yellow → Green health, -450 tokens (21% reduction), -93 lines (44% reduction)

## Phased Execution Timeline

**Phase 1 (Critical): 15 minutes**
- Fix 1.1: XML precondition enforcement (8 min)
- Fix 1.2: YAML frontmatter argument-hint (2 min)
- Fix 1.3: Explicit routing decision gate (5 min)

**Phase 2 (Extraction): 5 minutes**
- Fix 2.1: Extract drift categories (2 min)
- Fix 2.2: Consolidate decision menu examples (2 min)
- Fix 2.3: Reduce technical details (1 min)

**Phase 3 (Polish): 5 minutes**
- Fix 3.1-3.3: Convert passive to imperative (5 min total)

**Total estimated time: 25 minutes**

## Key Success Metrics

1. **Structural Enforcement**: Preconditions now XML-enforced with blocking behavior
2. **Routing Clarity**: Decision gate makes command flow unambiguous
3. **Token Efficiency**: 21% reduction through extraction of skill implementation details
4. **Comprehension**: HIGH improvement - clear separation of command (routing) vs skill (implementation)
5. **Maintenance**: MEDIUM improvement - clearer boundaries reduce drift risk

## Notes

- Command is already well-structured; main issue is lack of XML enforcement for preconditions
- Most optimizations are extractions to skill docs (where content already exists)
- No new files need to be created; drift categories already documented in skill
- Routing logic is clear but needs explicit XML structure for Claude comprehension under token pressure
- After fixes, command will be lean routing layer (~120 lines) with structural enforcement
