# Commands Final Fixes

Final optimization pass to squeeze maximum value from command refactoring.

## Scope

Excludes reconcile and sync-design (retroactive system fixes, not architectural issues).

**Commands to optimize:** 15 remaining commands

## Fix Categories

### Category 1: Critical Bugs (Must Fix)

#### 1. reset-to-ideation - Broken File Paths
**Issue:** Lines 109, 120 use wrong path syntax
- Current: `../.skills/plugin-lifecycle/`
- Correct: `../skills/plugin-lifecycle/`

**Fix:**
```bash
# Line 109
- See confirmation example in `../.skills/plugin-lifecycle/assets/reset-confirmation-example.txt`
+ See confirmation example in `.claude/skills/plugin-lifecycle/assets/reset-confirmation-example.txt`

# Line 120
- See success example in `../.skills/plugin-lifecycle/assets/reset-success-example.txt`
+ See success example in `.claude/skills/plugin-lifecycle/assets/reset-success-example.txt`
```

**Time:** 2 minutes
**Impact:** Fixes 404 errors on documentation links

---

### Category 2: Line Count Violations (Architectural Principle)

#### 2. implement - Exceeds 200-Line Threshold
**Current:** 201 lines (1 line over)

**Options:**
- **A.** Remove 1 blank line (1 min)
- **B.** Extract decision menu details to plugin-workflow skill docs (10 min, better progressive disclosure)

**Recommendation:** Option B - aligns with progressive disclosure pattern

**Fix:**
Extract lines 165-180 (decision menu format) to:
`.claude/skills/plugin-workflow/references/checkpoint-menus.md`

Replace with:
```markdown
Decision menu format follows checkpoint protocol (see plugin-workflow skill documentation).
```

**Time:** 10 minutes
**Impact:** Under 200 lines, better skill documentation

#### 3. improve - Exceeds 200-Line Threshold
**Current:** 224 lines (12% over)

**Fix:**
Extract lines 206-224 (state management details) to:
`.claude/skills/plugin-improve/references/state-management.md`

Replace with:
```markdown
## State Management

State operations documented in plugin-improve skill references.
```

**Time:** 15 minutes
**Impact:** Under 200 lines, progressive disclosure improvement

---

### Category 3: Ceremonial XML Reduction (Debatable - Your Call)

Commands with XML structure that doesn't enforce actual preconditions:

#### 4. dream - No Actual Preconditions
**Current:** 93 lines, 850 tokens
**Issue:** 11-line XML block documents "no preconditions" (ceremony, not enforcement)

**Evidence:**
```xml
<preconditions enforcement="advisory">
  <note>Brainstorming is always available - no blocking preconditions</note>
  ...
</preconditions>
```

"Advisory" enforcement = documentation, not validation.

**Fix Option:**
Replace lines 40-50 with:
```markdown
## Preconditions

None - brainstorming is always available.
```

**Time:** 15 minutes
**Token Impact:** -200 tokens (~23% reduction)
**Risk:** Creates inconsistency (some commands have XML, some don't)

**Decision needed:** Consistency vs appropriate complexity?

#### 5. setup - Bootstrap Documentation as XML
**Current:** 51 lines
**Issue:** XML wraps rationale for "no preconditions"

**Evidence:**
```xml
<preconditions>
  <rationale>
    Bootstrap nature means no system prerequisites required.
    ...
  </rationale>
</preconditions>
```

Explains WHY there are no preconditions, doesn't enforce preconditions.

**Fix Option:**
Replace with prose rationale (5 lines vs 15 lines)

**Time:** 10 minutes
**Token Impact:** -50 tokens (~10% reduction)

#### 6. doc-fix - Advisory Enforcement
**Current:** 114 lines
**Issue:** `enforcement="advisory"` doesn't block anything

**Fix Option:**
Simplify preconditions to markdown prose

**Time:** 10 minutes
**Token Impact:** -40 tokens (~5% reduction)

**Total Category 3:** 35 minutes, -290 tokens if all applied

---

### Category 4: Content Restoration (Lost Value)

#### 7. doc-fix - Lost Educational Content
**Issue:** QA found "content clarity REDUCED" - 7 explanatory concepts lost when consolidating feedback loop

**Original (backup lines 45-65):**
```markdown
## Why This Matters

This creates a compounding knowledge system:

1. First time you solve "Plugin X crashes on parameter change" → Research (30 min)
2. Document the solution → troubleshooting/runtime-issues/crashes-on-param.md (5 min)
3. Next time similar issue occurs → Quick lookup (2 min)
4. Knowledge compounds → System gets smarter

The feedback loop:
Build → Test → Find Issue → Research → Improve → Document → Validate → Deploy
    ↑                                                                      ↓
    └──────────────────────────────────────────────────────────────────────┘
```

**Current (line 47):**
```markdown
This creates a compounding knowledge system where research time investment (30 min first time) becomes instant lookup (2 min) for similar issues.
```

**Fix:**
Restore the 4-step breakdown and feedback loop diagram (educational value worth 100 tokens)

**Time:** 5 minutes
**Impact:** Restores lost explanatory value

---

## Summary

### Must Fix (30 min total)
1. reset-to-ideation: Fix broken paths (2 min)
2. implement: Extract to skill docs (10 min)
3. improve: Extract state management (15 min)
4. doc-fix: Restore educational content (5 min)

**Impact:** 4 commands fixed, 0 Yellow remaining (excluding reconcile/sync-design)

### Optional Simplification (35 min total)
5. dream: Remove ceremonial XML (15 min, -200 tokens)
6. setup: Simplify preconditions (10 min, -50 tokens)
7. doc-fix: Remove advisory enforcement (10 min, -40 tokens)

**Impact:** -290 tokens across 3 commands

**Trade-off:** Consistency (uniform XML) vs Appropriate Complexity (simple commands stay simple)

### Decision Required

**Apply optional simplifications?**

**Yes if:** You value minimal complexity and appropriate patterns
**No if:** You value consistency and machine-parseable structure everywhere

---

## Execution Plan (If All Applied)

**Time:** 65 minutes total
**Token Impact:** -290 tokens net
**Commands Fixed:** 7 (4 must-fix, 3 optional)
**Final Grade Distribution:** All Green (excluding reconcile/sync-design)

## Verification

After fixes, re-run QA audits on modified commands:
```bash
# Must-fix commands
@prompts/008-qa-audit-refactored-command.md @.claude/commands/reset-to-ideation.md
@prompts/008-qa-audit-refactored-command.md @.claude/commands/implement.md
@prompts/008-qa-audit-refactored-command.md @.claude/commands/improve.md
@prompts/008-qa-audit-refactored-command.md @.claude/commands/doc-fix.md

# Optional simplifications (if applied)
@prompts/008-qa-audit-refactored-command.md @.claude/commands/dream.md
@prompts/008-qa-audit-refactored-command.md @.claude/commands/setup.md
```

## Architectural Guideline (Prevent Future Over-Engineering)

Add to `.claude/CLAUDE.md` under Commands section:

```markdown
### Command XML Enforcement Guidelines

**Use XML enforcement when commands have:**
- 3+ preconditions with blocking logic
- Multi-path routing (3+ branches)
- State mutations (write to PLUGINS.md, .continue-here.md)
- Safety-critical operations (destructive, irreversible)

**Use lean markdown when commands have:**
- 0-2 preconditions (or none)
- Single skill invocation
- Simple menu selection
- Read-only state access
- Straightforward routing

**Rationale:** XML enforcement adds value through structural validation. When there's nothing to validate or enforce, XML becomes ceremony that reduces clarity while increasing token usage.
```
