---
name: sync-design
description: Validate mockup ↔ creative brief consistency
---

# /sync-design

Invoke the design-sync skill to validate mockup ↔ creative brief consistency.

## Purpose

Catches design drift before implementation by comparing the finalized UI mockup against the original creative brief.

**Detects:**
- Parameter count mismatches (brief says 8, mockup has 12)
- Missing features from brief (brief mentions presets, mockup lacks them)
- Visual style divergence (brief says vintage, mockup is modern)
- Scope creep or reduction

**Prevents:**
- Implementing designs that don't match user's vision
- Wasted work from misaligned expectations
- Surprises during Stage 5 (GUI implementation)

## Usage

```bash
/sync-design [PluginName]
```

## Examples

```bash
/sync-design DelayPlugin
/sync-design ReverbPlugin
```

## What It Does

### Quantitative Checks (Fast)
- Compares parameter counts (brief vs parameter-spec.md)
- Detects missing features (grep brief for keywords, check mockup)
- Measures scope changes (+/- parameters)

### Semantic Validation (LLM)
- Analyzes visual style alignment (brief aesthetic vs mockup design)
- Assesses feature completeness (brief promises vs mockup delivery)
- Evaluates scope changes (justified evolution vs drift)

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

## Success Output

### No Drift
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

### Acceptable Evolution
```
⚠️ Design evolution detected (acceptable)

**Changes from brief:**
- Parameter count: 12 (brief: 8) +4 parameters
- Added: Visual feedback meter

**Assessment:** Reasonable evolution

What's next?
1. Update brief and continue (recommended)
2. Review changes
3. Revert to original
4. Other
```

### Drift Detected
```
⚠️ Design drift detected

**Issues:**
1. Missing feature: "Preset browser" from brief
2. Visual mismatch: Brief is vintage, mockup is modern
3. Scope reduction: 5 parameters (brief: 12)

**Recommendation:** Address before implementation

What's next?
1. Update mockup - Align with brief
2. Update brief - Adjust vision
3. Continue anyway (override)
4. Review comparison
5. Other
```

## Preconditions

**Required files:**
- `plugins/[Plugin]/.ideas/creative-brief.md` - Original vision
- `plugins/[Plugin]/.ideas/parameter-spec.md` - From finalized mockup
- `plugins/[Plugin]/.ideas/mockups/vN-ui.yaml` - Finalized mockup

If missing, skill will guide you to create them.

## When To Use

**Use when:**
- After mockup finalization (auto-suggested by ui-mockup)
- Before Stage 1 Planning (optional pre-check)
- Anytime you want to verify alignment
- When unsure if design matches vision

**Don't use when:**
- Mockup still iterating (v1, v2 - not finalized)
- No creative brief exists
- Just checking visual appearance (open in browser instead)

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

### Optional Stage 1 pre-check
Before planning:
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

## Routes To

`design-sync` skill

## Related Commands

- `/implement [Plugin]` - Full 7-stage workflow (calls design-sync at Stage 1 if mockup exists)
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
