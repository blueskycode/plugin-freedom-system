# Fix Plan: /doc-fix

## Summary
- Critical fixes: **0** (No blocking issues)
- Optimization operations: **4** (Discoverability, structure, efficiency)
- Total estimated changes: **4 edits**
- Estimated time: **15 minutes**
- Token savings: **80 tokens (8% reduction)**
- Health improvement: **34/40 → 38/40** (+4 points)

## Phase 1: Critical Fixes (Blocking Issues)

**None identified.** This command is structurally sound. All changes are optimizations.

## Phase 2: High-Priority Optimizations

### Fix 2.1: Add argument-hint to YAML frontmatter
**Location:** Lines 1-4
**Operation:** REPLACE
**Severity:** HIGH (discoverability)

**Before:**
```yaml
---
name: doc-fix
description: Document a recently solved problem for the knowledge base
---
```

**After:**
```yaml
---
name: doc-fix
description: Document a recently solved problem for the knowledge base
argument-hint: "[optional: brief context about the fix]"
---
```

**Verification:**
- [ ] YAML frontmatter parses correctly
- [ ] `/help` displays command with description
- [ ] Autocomplete shows argument hint for optional context parameter

**Token impact:** +10 tokens (improved discoverability)

### Fix 2.2: Condense "Why This Matters" section
**Location:** Lines 72-84
**Operation:** REPLACE
**Severity:** HIGH (token efficiency)

**Before:**
```markdown
## Why This Matters

**Builds knowledge base:**
- Future sessions find solutions faster
- deep-research searches local docs first (Level 1 Fast Path)
- No solving same problem repeatedly
- Institutional knowledge compounds over time

**The feedback loop:**
1. Hit problem → deep-research searches local troubleshooting/
2. Fix problem → troubleshooting-docs creates documentation
3. Hit similar problem → Found instantly in Level 1
4. Knowledge grows organically
```

**After:**
```markdown
## Why This Matters

**Feedback loop:** Hit problem → Fix → Document → Next time finds solution instantly

**Impact:**
- deep-research searches local docs first (Level 1 Fast Path)
- No solving same problem repeatedly
- Institutional knowledge compounds over time

**Integration:** Documentation feeds back into deep-research skill's Level 1 search.
```

**Verification:**
- [ ] Section reduced from 13 lines to 7 lines
- [ ] Key insight about feedback loop preserved
- [ ] Redundancy eliminated (line 75 and line 77 both mentioned "finding solutions faster")
- [ ] Integration with deep-research skill still documented

**Token impact:** -70 tokens (20% reduction of this section)

## Phase 3: Medium-Priority Polish

### Fix 3.1: Wrap preconditions in XML enforcement structure
**Location:** Lines 30-35
**Operation:** REPLACE
**Severity:** MEDIUM (structural consistency)

**Before:**
```markdown
## Preconditions

- Problem has been solved (not in-progress)
- Solution has been verified working
- Non-trivial problem (not simple typo or obvious error)
```

**After:**
```markdown
## Preconditions

<preconditions enforcement="advisory">
  <check condition="problem_solved">
    Problem has been solved (not in-progress)
  </check>
  <check condition="solution_verified">
    Solution has been verified working
  </check>
  <check condition="non_trivial">
    Non-trivial problem (not simple typo or obvious error)
  </check>
</preconditions>
```

**Verification:**
- [ ] XML structure is well-formed
- [ ] `enforcement="advisory"` indicates soft checks (don't block execution)
- [ ] Preconditions remain human-readable
- [ ] Pattern matches other commands in the system

**Token impact:** +10 tokens (structural overhead, but improves machine-parseability)

**Note:** These are advisory preconditions. The troubleshooting-docs skill handles actual validation and can ask clarifying questions if needed.

### Fix 3.2: Structure auto-invoke section with XML
**Location:** Lines 86-94
**Operation:** REPLACE
**Severity:** MEDIUM (structural consistency)

**Before:**
```markdown
## Auto-Invoke

Skill automatically activates after phrases:
- "that worked"
- "it's fixed"
- "working now"
- "problem solved"

Manual invocation via `/doc-fix` when you want to document without waiting for auto-detection.
```

**After:**
```markdown
## Auto-Invoke

<auto_invoke>
  <trigger_phrases>
    - "that worked"
    - "it's fixed"
    - "working now"
    - "problem solved"
  </trigger_phrases>

  <manual_override>
    Use /doc-fix [context] to document immediately without waiting for auto-detection.
  </manual_override>
</auto_invoke>
```

**Verification:**
- [ ] XML structure is well-formed
- [ ] Trigger phrases remain as markdown list (parseable within XML)
- [ ] Manual override clearly distinguished from auto-triggers
- [ ] Pattern consistent with XML usage elsewhere in system

**Token impact:** Neutral (slightly more structure, slightly less prose)

## File Operations Manifest

**Files to modify:**
1. `.claude/commands/doc-fix.md` - All 4 optimizations listed above

**Files to create:**
None

**Files to archive:**
None

## Execution Checklist

**Phase 1 (Critical):**
- [x] YAML frontmatter includes required `description` field (already present)
- [x] Routing to skills is explicit (line 8: "Invoke the troubleshooting-docs skill")
- [x] State file interactions documented (lines 38-51)
- [x] Decision menu follows checkpoint protocol format (lines 54-70)
- [x] No ambiguous pronouns or vague language

**Phase 2 (High-Priority Optimizations):**
- [ ] YAML frontmatter includes `argument-hint` for optional parameter
- [ ] "Why This Matters" section condensed from 13 lines to 7 lines
- [ ] Key feedback loop insight preserved
- [ ] Token count reduced by ~60 net tokens

**Phase 3 (Medium-Priority Polish):**
- [ ] Preconditions wrapped in `<preconditions enforcement="advisory">` XML structure
- [ ] Auto-invoke section structured with `<auto_invoke>` XML tags
- [ ] XML patterns machine-parseable
- [ ] Consistency with system-wide patterns improved

**Final Verification:**
- [ ] Command loads without errors
- [ ] Command appears in `/help` with correct description
- [ ] Autocomplete shows argument hint
- [ ] Routing to troubleshooting-docs skill succeeds
- [ ] Health score improved from 34/40 to 38/40 (estimated)
- [ ] All original functionality preserved

## Estimated Impact

**Before:**
- Health score: 34/40
- Line count: 104 lines
- Token count: ~1000 tokens
- Critical issues: 0
- Optimization opportunities: 4

**After:**
- Health score: **38/40** (target, +4 points)
- Line count: **102 lines** (minor reduction)
- Token count: **~920 tokens** (8% reduction)
- Critical issues: **0**
- Optimization opportunities: **0**

**Improvement:** +4 health points, -80 tokens (8% reduction)

**Score breakdown (after fixes):**
1. Structure Compliance: 4 → **5** (added argument-hint)
2. Routing Clarity: 5 → **5** (no change, already excellent)
3. Instruction Clarity: 5 → **5** (no change, already excellent)
4. XML Organization: 3 → **5** (added XML wrapping for preconditions and auto-invoke)
5. Context Efficiency: 4 → **5** (condensed verbose section)
6. Claude-Optimized Language: 5 → **5** (no change, already excellent)
7. System Integration: 5 → **5** (no change, already excellent)
8. Precondition Enforcement: 3 → **3** (advisory enforcement, appropriate for this command)

**Total: 38/40 (Green - Excellent)**

## Examples of Good Patterns to Preserve

### Pattern 1: Crystal Clear Routing (Line 8)
```markdown
Invoke the troubleshooting-docs skill to document a recently solved problem.
```

**Why this is excellent:**
- One sentence, one instruction
- Imperative mood ("Invoke")
- Explicit skill name
- Clear purpose

**ACTION:** Preserve this exactly. This is the gold standard for command routing.

### Pattern 2: Decision Menu Format (Lines 54-70)
```markdown
✓ Solution documented

File created:
- Real: troubleshooting/by-plugin/ReverbPlugin/parameter-issues/[filename].md
- Symlink: troubleshooting/by-symptom/parameter-issues/[filename].md

This documentation will be searched by deep-research skill as Level 1 (Fast Path)
when similar issues occur.

What's next?
1. Continue workflow (recommended)
2. Link related issues
3. Update common patterns
4. View documentation
5. Other
```

**Why this is excellent:**
- Follows checkpoint protocol format exactly
- Inline numbered list (not AskUserQuestion tool)
- Completion statement at top
- Context about what was created
- Discovery feature hint ("Link related issues")
- "Other" escape hatch at end

**ACTION:** Preserve this exactly. This matches system-wide checkpoint protocol.

### Pattern 3: Dual-Indexing Documentation (Lines 38-51)
```markdown
**Dual-indexed documentation:**
- Real file: `troubleshooting/by-plugin/[Plugin]/[category]/[filename].md`
- Symlink: `troubleshooting/by-symptom/[category]/[filename].md`

**Categories auto-detected from problem:**
- build-failures/
- runtime-issues/
- validation-problems/
- webview-issues/
- dsp-issues/
- gui-issues/
- parameter-issues/
- api-usage/
```

**Why this is excellent:**
- Shows actual file structure
- Explains dual-indexing pattern clearly
- Lists all supported categories
- Helps user understand knowledge base organization

**ACTION:** Preserve this exactly. This is valuable system documentation.

## Implementation Notes

### Order of Operations

Execute fixes in this order to avoid line number shifts:

1. **Fix 3.2** (Lines 86-94) - Auto-invoke section (bottom of file)
2. **Fix 2.2** (Lines 72-84) - Why This Matters section (middle)
3. **Fix 3.1** (Lines 30-35) - Preconditions (middle)
4. **Fix 2.1** (Lines 1-4) - YAML frontmatter (top)

By working bottom-to-top, line numbers remain accurate throughout the editing process.

### Testing After Implementation

After applying all fixes, test the command:

```bash
# Test 1: Command loads without errors
/doc-fix

# Test 2: Verify autocomplete shows argument hint
# Type /doc-fix and press tab - should show "[optional: brief context about the fix]"

# Test 3: Verify help text displays correctly
/help | grep doc-fix

# Test 4: Verify routing works
# Run the command in a real scenario and confirm troubleshooting-docs skill is invoked
```

## Final Assessment

This command is **already excellent** (34/40 Green status). The proposed fixes are **pure optimizations**, not critical corrections.

**Key strengths to preserve:**
- Clear routing logic (line 8)
- Excellent system integration documentation
- Follows checkpoint protocol perfectly
- Lean and focused (104 lines)
- Imperative language throughout

**What these fixes add:**
- Discoverability (argument-hint visible in autocomplete)
- Token efficiency (8% reduction)
- Structural consistency (XML patterns match other commands)
- Machine-parseability (structured data easier to process)

**Risk level:** **Very low**. All changes are additive or condensing, not restructuring.

**Recommendation:** Implement Phase 2 (high-priority) first. Phase 3 (medium-priority) can be deferred if time is limited, as the prose format already works well.
