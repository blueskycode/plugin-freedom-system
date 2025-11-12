# Fix Plan: /add-critical-pattern

## Summary
- Critical fixes: 1 (frontmatter field name)
- Structural improvements: 3 (preconditions, critical sequence, state documentation)
- Optimization operations: 1 (consolidate duplicate content)
- Total estimated changes: 5
- Estimated time: 15 minutes
- Token savings: ~100 tokens (10% reduction)

## Phase 1: Critical Fixes (Correctness)

### Fix 1.1: Correct Frontmatter Field Name
**Location:** Line 3
**Operation:** REPLACE
**Severity:** CRITICAL (Standards compliance)

**Before:**
```yaml
args: "[optional: pattern name]"
```

**After:**
```yaml
argument-hint: "[optional: pattern name]"
```

**Verification:**
- [ ] YAML frontmatter parses correctly
- [ ] `/help` displays command with description
- [ ] Autocomplete shows argument hint correctly
- [ ] Matches Claude Code documentation standards

**Token impact:** 0 tokens (field name only)

---

## Phase 2: Structural Enforcement (XML Organization)

### Fix 2.1: Add XML Precondition Enforcement
**Location:** After line 14 (before "## Task" section)
**Operation:** INSERT
**Severity:** HIGH (Execution quality)

**Insert:**
```xml
<preconditions enforcement="blocking">
  <check target="conversation_context" condition="has_problem_solution">
    Current conversation MUST contain a solved problem with:
    - Clear description of what was wrong
    - Working solution with code examples
    - Explanation of why the fix works
  </check>

  <check target="file_exists" condition="target_file">
    Target file MUST exist: troubleshooting/patterns/juce8-critical-patterns.md
  </check>
</preconditions>
```

**Verification:**
- [ ] Preconditions block exists with `enforcement="blocking"` attribute
- [ ] Conversation context check clearly defined
- [ ] File existence check references correct path
- [ ] Prevents execution without sufficient context

**Token impact:** +50 tokens (prevents ~200 tokens of error recovery)

---

### Fix 2.2: Wrap Steps in Critical Sequence XML
**Location:** Lines 19-69 (entire "## Steps" section)
**Operation:** WRAP
**Severity:** HIGH (Execution enforcement)

**Before:**
```markdown
## Steps

1. **Review conversation** - Extract:
   - What was wrong (❌ WRONG example with code)
   - What's correct (✅ CORRECT example with code)
   - Why this is required (technical explanation)
   - When this applies (placement/context)

2. **Determine pattern number:**
   ```bash
   # Count existing patterns
   grep -c "^## [0-9]" troubleshooting/patterns/juce8-critical-patterns.md
   # Next number = count + 1
   ```

3. **Format pattern:**
   ```markdown
   ## N. [Pattern Name] (ALWAYS REQUIRED)

   ### ❌ WRONG ([Will cause X error])
   ```[language]
   [code showing wrong approach]
   ```

   ### ✅ CORRECT
   ```[language]
   [code showing correct approach]
   ```

   **Why:** [Technical explanation]

   **Placement/Context:** [When this applies]

   **Documented in:** [If there's a troubleshooting doc, link it]

   ---
   ```

4. **Add to file:**
   - Append pattern before "## Usage Instructions" section
   - Update numbering if needed

5. **Confirm:**
   ```
   ✓ Added to Required Reading

   Pattern #N: [Pattern Name]
   Location: troubleshooting/patterns/juce8-critical-patterns.md

   All subagents (Stages 2-5) will see this pattern before code generation.
   ```
```

**After:**
```markdown
## Steps

<critical_sequence>
  <step order="1" required="true">
    Review conversation and extract:
    - ❌ WRONG example (with code)
    - ✅ CORRECT example (with code)
    - Technical explanation (why required)
    - Context (when this applies)
  </step>

  <step order="2" required="true" tool="Bash">
    Determine pattern number:
    ```bash
    # Count existing patterns
    grep -c "^## [0-9]" troubleshooting/patterns/juce8-critical-patterns.md
    # Next number = count + 1
    ```
  </step>

  <step order="3" required="true">
    Format pattern using template:
    ```markdown
    ## N. [Pattern Name] (ALWAYS REQUIRED)

    ### ❌ WRONG ([Will cause X error])
    ```[language]
    [code showing wrong approach]
    ```

    ### ✅ CORRECT
    ```[language]
    [code showing correct approach]
    ```

    **Why:** [Technical explanation]

    **Placement/Context:** [When this applies]

    **Documented in:** [If there's a troubleshooting doc, link it]

    ---
    ```
  </step>

  <step order="4" required="true" tool="Edit">
    Add pattern to file:
    - Append before "## Usage Instructions" section
    - Update numbering if needed
  </step>

  <step order="5" required="true" blocking="true">
    Confirm completion:
    ```
    ✓ Added to Required Reading

    Pattern #N: [Pattern Name]
    Location: troubleshooting/patterns/juce8-critical-patterns.md

    All subagents (Stages 2-5) will see this pattern before code generation.
    ```
  </step>
</critical_sequence>
```

**Verification:**
- [ ] `<critical_sequence>` tags wrap entire step section
- [ ] Each step has `order` and `required` attributes
- [ ] Steps that use tools have `tool="Bash"` or `tool="Edit"` attributes
- [ ] Final step has `blocking="true"` attribute
- [ ] Template formatting preserved within step 3
- [ ] No content lost during restructuring

**Token impact:** -100 tokens (more efficient structure)

---

### Fix 2.3: Add State File Documentation
**Location:** After line 4 (after frontmatter, before "# Add Critical Pattern Command")
**Operation:** INSERT
**Severity:** MEDIUM (Clarity + maintainability)

**Insert:**
```xml
<state_files>
  <file path="troubleshooting/patterns/juce8-critical-patterns.md" mode="read_write">
    Read: Count existing patterns via grep (determine next number)
    Write: Append new pattern before "## Usage Instructions" section
    Contract: Each pattern numbered sequentially (## N. Title)
  </file>
</state_files>
```

**Verification:**
- [ ] `<state_files>` block exists after frontmatter
- [ ] File path matches target file
- [ ] Mode correctly set to `read_write`
- [ ] Read and Write operations clearly documented
- [ ] Contract specifies numbering convention

**Token impact:** +30 tokens (documentation clarity)

---

## Phase 3: Content Optimization (Token Efficiency)

### Fix 3.1: Consolidate Duplicate Purpose Descriptions
**Location:** Lines 7-14 and lines 71-98
**Operation:** REPLACE (consolidate)
**Severity:** MEDIUM (Token efficiency)

**Current duplicated content:**
- Lines 7-14: Purpose and "When to use"
- Lines 71-98: Example Usage, Integration, Notes (repeats context)

**Before (Lines 7-14):**
```markdown
# Add Critical Pattern Command

**Purpose:** Directly promote the current problem to Required Reading without going through full documentation workflow.

**When to use:**
- System made this mistake multiple times
- You know it's critical and needs to be in every subagent's context
- Want to skip documentation ceremony and go straight to pattern capture
```

**Before (Lines 71-98):**
```markdown
## Example Usage

```bash
# After solving a problem:
User: "add that to required reading"
# Command auto-invokes

# Or explicitly:
User: "/add-critical-pattern WebView Setup"
```

## Integration

**Invoked by:**
- User phrases: "add to required reading", "make this critical", "add critical pattern"
- Explicit: `/add-critical-pattern [name]`
- Option 2 from `/doc-fix` decision menu

**Related commands:**
- `/doc-fix` - Full documentation workflow with option to promote
- This command - Direct promotion (faster path)

## Notes

- Use when you're confident it's critical (affects all future plugins)
- If unsure, use `/doc-fix` and choose Option 2 from menu
- Pattern name optional (Claude will infer from context)
- Can be run after `/doc-fix` completes if you change your mind
```

**After (Consolidated - replace lines 7-14 and lines 71-98):**
```markdown
# Add Critical Pattern Command

Directly promote current problem to Required Reading (juce8-critical-patterns.md) without full documentation workflow.

**Use when:**
- System made this mistake multiple times
- Critical pattern affects all future plugins
- Want fast path (skip documentation ceremony)

## Integration

**Invoked by:**
- User phrases: "add to required reading", "make this critical", "add critical pattern"
- Explicit: `/add-critical-pattern [name]`
- Option 2 from `/doc-fix` decision menu

**Related:** `/doc-fix` provides full documentation workflow with promotion option

**Notes:** Pattern name optional (inferred from context). If unsure whether critical, use `/doc-fix` instead.
```

**Verification:**
- [ ] Single purpose statement (no duplication)
- [ ] Integration section covers invocation methods
- [ ] Related commands documented
- [ ] Notes section consolidated
- [ ] Example usage removed (implicit from integration section)
- [ ] No information lost

**Token impact:** -50 tokens (consolidation)

---

## File Operations Manifest

**Files to modify:**
1. `.claude/commands/add-critical-pattern.md` - Apply all fixes above

**No files to create** (command is self-contained)

**No files to archive** (command is functional)

---

## Execution Checklist

**Phase 1 (Correctness):**
- [ ] YAML frontmatter uses `argument-hint` (not `args`)

**Phase 2 (Structural Enforcement):**
- [ ] Preconditions wrapped in `<preconditions enforcement="blocking">`
- [ ] Conversation context check defined
- [ ] File existence check defined
- [ ] Critical sequence wrapped in `<critical_sequence>` tags
- [ ] All steps have `order` and `required` attributes
- [ ] Tool-using steps have `tool="[ToolName]"` attribute
- [ ] Final step has `blocking="true"` attribute
- [ ] State file documentation added with `<state_files>` block
- [ ] Read/write operations documented
- [ ] File contract specified

**Phase 3 (Optimization):**
- [ ] Purpose description consolidated (single source)
- [ ] Integration section covers all invocation methods
- [ ] Related commands documented
- [ ] Notes section consolidated
- [ ] Duplicate content removed

**Final Verification:**
- [ ] Command loads without errors
- [ ] Command appears in `/help` with correct description
- [ ] Autocomplete works with argument hint
- [ ] Preconditions prevent execution without context
- [ ] Critical sequence enforces step order
- [ ] Health score improved from 27/40 to estimated 35+/40

---

## Estimated Impact

**Before:**
- Health score: 27/40
- Line count: 99 lines
- Token count: ~980 tokens
- Critical issues: 1 (incorrect frontmatter field)
- Structural issues: 3 (no preconditions, no XML sequence, no state docs)

**After:**
- Health score: 35/40 (target) - improvements:
  - Structure Compliance: 4/5 → 5/5 (correct field name)
  - XML Organization: 2/5 → 4/5 (preconditions + critical sequence)
  - System Integration: 3/5 → 4/5 (state file docs)
  - Context Efficiency: 4/5 → 4/5 (consolidation maintains score)
- Line count: ~95 lines
- Token count: ~880 tokens
- Critical issues: 0
- Structural issues: 0

**Improvement:** +8 health points, -10% tokens, +structural enforcement guarantees

---

## Implementation Notes

1. **Order matters:** Apply fixes in phase order (correctness → structure → optimization)
2. **Preserve formatting:** Keep markdown template in step 3 exactly as-is
3. **Test after Phase 1:** Verify frontmatter loads correctly before proceeding
4. **Test after Phase 2:** Verify XML structure doesn't break command parsing
5. **Verify after Phase 3:** Ensure no information lost during consolidation

---

## Success Criteria

The fix plan successfully addresses:
- [x] 100% of critical issues (frontmatter field name)
- [x] 100% of structural improvements (preconditions, sequence, state docs)
- [x] Token efficiency optimization (consolidation)
- [x] Mechanical, unambiguous instructions provided
- [x] Before/after diffs show exact transformations
- [x] Verification checklist covers all changes
- [x] Maintains command functionality (self-contained implementation)
- [x] Results in lean, enforceable routing layer

**Final result:** Command remains functionally identical but with stronger execution guarantees, clearer structure, and improved token efficiency.
