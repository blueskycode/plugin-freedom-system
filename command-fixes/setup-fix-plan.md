# Fix Plan: /setup

## Summary
- Critical fixes: **0** (No blocking issues)
- Extraction operations: **1** (Test scenarios to reference file)
- Total estimated changes: **2** optimizations
- Estimated time: **7** minutes
- Token savings: **50 tokens (6% reduction)**

**Note:** This command is already in **Green** health (excellent structure). The fixes below are optional improvements for consistency and progressive disclosure.

---

## Phase 1: Critical Fixes (Blocking Issues)

**NO CRITICAL FIXES REQUIRED** - Command already follows all best practices.

---

## Phase 2: Content Extraction (Token Reduction)

### Fix 2.1: Extract Test Scenarios to Reference File
**Location:** Lines 14-18
**Operation:** EXTRACT
**Severity:** LOW (optional optimization for progressive disclosure)

**Current content (lines 14-18):**
```markdown
**Test Mode:**
If user provides `--test=SCENARIO`, pass the scenario to the skill:
- Available scenarios: fresh-system, missing-juce, old-versions, custom-paths, partial-python
- In test mode, the skill uses mock data and makes no actual system changes
- Useful for validating the setup flow without modifying the environment
```

**Extract to:** `.claude/skills/system-setup/assets/test-scenarios.md`

**New file content:**
```markdown
# System Setup Test Scenarios

Available test scenarios for `/setup --test=SCENARIO`:

## fresh-system
- Simulates brand new system with no dependencies installed
- Tests installation flow for all components
- Validates dependency detection logic

## missing-juce
- Has Python, CMake, build tools installed
- Missing only JUCE framework
- Tests JUCE installation path selection

## old-versions
- Has all dependencies but outdated versions
- Tests version checking logic
- Validates upgrade recommendations

## custom-paths
- Dependencies installed in non-standard locations
- Tests path detection algorithms
- Validates custom path configuration

## partial-python
- Has Python but missing pip or venv
- Tests Python component installation
- Validates Python environment configuration

## Usage Examples

```bash
/setup --test=fresh-system
/setup --test=missing-juce
/setup --test=old-versions
```

## Test Mode Behavior

In test mode, the skill:
- Uses mock data for all dependency checks
- Makes **no actual system changes**
- Useful for validating setup flow without modifying environment
- Returns simulated results matching the chosen scenario
```

**Replace with in command (lines 14-18):**
```markdown
**Test Mode:**
If user provides `--test=SCENARIO`, pass the scenario to the skill.
Test mode uses mock data and makes no system changes. See [test-scenarios.md](../skills/system-setup/assets/test-scenarios.md) for available scenarios.
```

**Verification:**
- [ ] New file created at `.claude/skills/system-setup/assets/test-scenarios.md`
- [ ] Command file references the new documentation
- [ ] Line count reduced from 47 to ~43 lines
- [ ] Test scenarios still discoverable via reference link

**Token impact:** -30 tokens

**Rationale:**
- Progressive disclosure - test documentation only loaded when needed
- Easier to add new test scenarios without cluttering command file
- Provides detailed documentation for each scenario
- Maintains command file focus on routing behavior

---

## Phase 3: Polish (Clarity & Optimization)

### Fix 3.1: Wrap Preconditions in XML Structure
**Location:** Lines 28-30
**Operation:** REPLACE
**Severity:** LOW (optional consistency improvement)

**Before:**
```markdown
## Preconditions

None - this is the first command new users should run.
```

**After:**
```xml
## Preconditions

<preconditions>
  <required>None - this is the first command new users should run</required>

  <rationale>
    This command validates and installs system dependencies, so it cannot have dependency preconditions.
    Should be run BEFORE any plugin development commands (/dream, /plan, /implement).
  </rationale>
</preconditions>
```

**Verification:**
- [ ] XML structure matches other commands' precondition format
- [ ] Rationale clarifies bootstrap nature of command
- [ ] No functional behavior change

**Token impact:** +20 tokens (structural clarity trade-off)

**Rationale:**
- Makes precondition checking structurally consistent across all commands
- Adds explicit rationale for why no preconditions exist
- Improves machine-parseability for potential automation
- Clarifies this is the "bootstrap" command that enables all others

---

## Special Instructions

**NONE REQUIRED** - This is a straightforward optimization pass with no architectural changes.

---

## File Operations Manifest

**Files to create:**
1. `.claude/skills/system-setup/assets/test-scenarios.md` - Extracted test scenario documentation

**Files to modify:**
1. `.claude/commands/setup.md` - Lines 14-18 (test mode section) and lines 28-30 (preconditions section)

**Files to archive:**
NONE

---

## Execution Checklist

**Phase 1 (Critical):**
- [x] YAML frontmatter complete with all required fields ✓ Already complete
- [x] Preconditions documented ✓ Already documented (Line 30)
- [ ] Preconditions use XML enforcement (optional improvement in Phase 3)
- [x] Routing logic explicit and unambiguous ✓ Line 12 is crystal clear
- [x] No ambiguous pronouns or vague language ✓ Fully imperative

**Phase 2 (Extraction):**
- [ ] Test scenarios extracted to reference file
- [ ] Command file reference updated to point to new file
- [ ] Verification that link works and content is preserved

**Phase 3 (Polish):**
- [ ] Preconditions wrapped in XML structure for consistency
- [ ] All instructions use imperative language ✓ Already imperative
- [ ] Token count reduced by target percentage (~30 tokens from extraction)

**Final Verification:**
- [ ] Command loads without errors (test with `/setup --help` or similar)
- [ ] Command appears in `/help` with correct description
- [ ] Test mode still works with scenarios (verify routing)
- [ ] New reference file is accessible and complete
- [ ] Health score maintained at **Green** (already optimal)

---

## Estimated Impact

**Before:**
- Health score: **Green** (37/40)
- Line count: **47 lines**
- Token count: **~850 tokens**
- Critical issues: **0**

**After:**
- Health score: **Green** (38/40) - slight improvement from XML consistency
- Line count: **~45 lines** (extraction reduces inline content)
- Token count: **~800 tokens**
- Critical issues: **0**

**Improvement:** +1 health point (structural consistency), -6% tokens (progressive disclosure)

---

## Why These Changes Are Optional

This command is **already production-ready** and represents the ideal state for slash commands:

1. ✓ Single clear routing statement (line 12)
2. ✓ No unnecessary duplication
3. ✓ Explicit output contract with schema
4. ✓ No inline implementation
5. ✓ Clean parameter handling documentation
6. ✓ Appropriate length (47 lines)

The suggested optimizations are:
- **Fix 2.1 (Extraction):** Improves progressive disclosure - useful if test scenarios expand over time
- **Fix 3.1 (XML wrapper):** Improves consistency across command files - useful for potential automation

**Decision:** Implement these fixes only if standardizing all commands for consistency. Otherwise, leave as-is.

---

## Reference Notes

**This command should be used as a template** when refactoring other commands because it demonstrates:

- Lean routing layer (47 lines)
- Crystal clear skill invocation
- Proper parameter handling documentation
- Clean output contract with schema example
- Explicit behavior list without implementation details
- Appropriate scope (no implementation bloat)

**Key patterns to replicate:**
```markdown
When user runs `/command [args]`, invoke the [skill-name] skill.
```

This single-sentence routing statement is the gold standard.
