# Command Analysis: continue

## Executive Summary
- Overall health: **Green** (Lean, clear routing layer with good structure)
- Critical issues: **0** (No blockers for Claude comprehension)
- Optimization opportunities: **3** (Minor improvements for consistency)
- Estimated context savings: **120 tokens (10% reduction)**

## Dimension Scores (1-5)

1. Structure Compliance: **5/5** (Complete YAML frontmatter with description and allowed-tools)
2. Routing Clarity: **5/5** (Crystal clear delegation to context-resume skill)
3. Instruction Clarity: **5/5** (Imperative language, explicit single instruction)
4. XML Organization: **5/5** (Not needed - command is pure routing layer)
5. Context Efficiency: **5/5** (Optimal length at 123 lines, zero bloat)
6. Claude-Optimized Language: **5/5** (Clear imperative, no ambiguity)
7. System Integration: **4/5** (Documents handoff locations well, could clarify state file contracts)
8. Precondition Enforcement: **4/5** (Lists handoff locations, could add XML precondition check)

**Overall Score: 38/40 (95%)**

## Critical Issues (blockers for Claude comprehension)

**None identified.** This command follows best practices exemplified in the analysis framework.

## Optimization Opportunities

### Optimization #1: Consolidate Error Examples (Lines 83-110)
**Potential savings:** 80 tokens (8% reduction)
**Current:** Two separate error blocks with overlapping structure
**Recommended:** Combine into single error handling section

**Before:**
```markdown
**No handoff files exist:**
```
No resumable work found.

Handoff files are created throughout the plugin lifecycle:
- After ideation (creative brief complete)
- After mockup creation (design ready)
- During implementation (plugin-workflow stages)
- After improvements (version releases)

Start new work:
- /dream - Explore plugin ideas
- /implement - Build new plugin
```

**Plugin doesn't have handoff:**
```
[PluginName] doesn't have a handoff file.

Possible reasons:
- Plugin is already complete (Stage 6 done)
- Plugin hasn't been started yet
- Development finished and handoff removed

Check status: Look in PLUGINS.md
Modify complete plugin: /improve [PluginName]
Start new plugin: /implement [PluginName]
```
```

**After:**
```markdown
## Error Handling

**No handoff files found:**

IF no handoff exists for any plugin:
- Display: "No resumable work found"
- List when handoffs are created (ideation, mockup, implementation, improvements)
- Suggest: /dream or /implement

IF specific [PluginName] doesn't have handoff:
- Display: "[PluginName] doesn't have a handoff file"
- List possible reasons (complete, not started, removed)
- Suggest: Check PLUGINS.md, /improve, or /implement

See context-resume skill's error-recovery.md for additional scenarios.
```

**Impact:** More scannable, less redundant phrasing, maintains all information

### Optimization #2: Add Precondition XML (Lines 20-41)
**Potential savings:** 0 tokens (clarification improvement)
**Current:** Lists handoff locations in prose under "Behavior"
**Recommended:** Wrap in XML precondition check for consistency with skill pattern

**Before:**
```markdown
## Behavior

**Without plugin name:**
Search for all `.continue-here.md` handoff files in:
- `plugins/[Name]/.continue-here.md` (implementation)
- `plugins/[Name]/.ideas/.continue-here.md` (ideation/mockup)

Present interactive menu:
```

**After:**
```xml
<preconditions enforcement="blocking">
  <check target="handoff_files" condition="at_least_one_exists">
    Search for `.continue-here.md` files in priority order:
    1. `plugins/[Name]/.continue-here.md` (implementation)
    2. `plugins/[Name]/.ideas/.continue-here.md` (ideation)

    IF none found: Display error (see Error Handling section)
    IF multiple found: Present disambiguation menu
  </check>
</preconditions>
```

**Impact:** Makes precondition checking explicit, aligns with skill's handoff_location structure

### Optimization #3: State File Documentation (Lines 42-80)
**Potential savings:** 40 tokens (4% reduction)
**Current:** Implicit state file contracts in "What Gets Loaded" and "After Loading"
**Recommended:** Explicit state contract section

**Before:**
```markdown
## What Gets Loaded

Context automatically loaded:
- Handoff file content (current state, completed work, next steps)
- Recent commits for this plugin
- Source files mentioned in handoff
- Research notes (if Stage 0-1)
- UI mockups (if applicable)

## After Loading

Present summary:
```
Resuming [PluginName] at Stage [N]...
...
```
```

**After:**
```xml
<state_contract>
  <reads>
    - `.continue-here.md` (one of 3 locations)
    - PLUGINS.md (status verification)
    - Recent git commits (for plugin)
    - Contract files (if workflow stage)
    - Source files (if mentioned in handoff)
  </reads>

  <writes>
    NONE - This command is READ-ONLY for state files.
    Continuation skills handle all writes.
  </writes>

  <loads_before_routing>
    Load contracts and context files BEFORE invoking continuation skill.
    This provides context for skill execution.
  </loads_before_routing>
</state_contract>
```

**Impact:** Clarifies read-only nature, makes state contracts explicit

## Implementation Priority

### 1. **High** (Major clarity improvement)
   - Optimization #2: Add precondition XML wrapper
   - Makes precondition logic structurally explicit

### 2. **Medium** (Token savings)
   - Optimization #1: Consolidate error examples
   - Removes redundant phrasing, improves scannability

### 3. **Low** (Documentation improvement)
   - Optimization #3: Add state contract section
   - Already implied by skill documentation, but explicit is better

## Comparison with plugin-workflow Skill

### What /continue Does Right

1. **Pure routing layer**: 123 lines vs plugin-workflow's 411 lines
2. **Single clear instruction**: "YOU MUST invoke context-resume skill"
3. **Zero implementation details**: All logic delegated to skill
4. **Complete frontmatter**: Includes allowed-tools field
5. **Graceful error messages**: Clear recovery paths for missing handoffs

### Alignment with Best Practices

The `/continue` command exemplifies the ideal command structure:

**From analysis framework:**
> Commands should be:
> - Lean routing layers (50-200 lines typical)
> - Clear about which skill to invoke and when
> - Structurally enforcing preconditions via XML
> - Token-efficient (they execute frequently)

**continue command scores:**
- ✅ Lean: 123 lines (well within 50-200 range)
- ✅ Clear: "YOU MUST invoke context-resume skill" (explicit)
- ⚠️ Structural enforcement: Could add XML precondition wrapper (score: 4/5)
- ✅ Token-efficient: Minimal duplication, delegates complexity to skill

### Pattern to Replicate

Other commands should follow this structure:

```markdown
---
name: [command-name]
description: [One-line description]
allowed-tools:
  - [List of tools if needed]
---

# /[command-name]

When user runs `/[command-name] [args?]`, YOU MUST invoke the [skill-name] skill using the Skill tool.

**IMPORTANT: Use this exact invocation:**

```
Skill({ skill: "[skill-name]" })
```

DO NOT [anti-pattern]. The [skill-name] skill handles all of this.

## Behavior

**Without [arg]:**
[Description of default behavior]

**With [arg]:**
[Description of parameterized behavior]

## Routes To

**Skill:** [skill-name]

The skill handles:
- [Responsibility 1]
- [Responsibility 2]
- [Responsibility 3]

## Error Handling

**[Error Scenario]:**
[Clear error message]
[Recovery options]
```

## Verification Checklist

After implementing fixes, verify:
- [x] YAML frontmatter includes required fields (name, description)
- [x] YAML frontmatter includes optional fields (allowed-tools)
- [ ] Preconditions use XML enforcement (current: prose, target: XML)
- [x] Critical sequences are structurally enforced (N/A - pure routing)
- [x] Command is under 200 lines (current: 123 lines)
- [x] Routing to skills is explicit ("YOU MUST invoke context-resume skill")
- [ ] State file interactions documented (current: implicit, target: explicit)
- [x] Error messages provide clear recovery paths

## Recommended Actions

### Immediate (5 minutes)
None required - command is already highly functional

### Short-term (15 minutes)
1. Add `<preconditions>` XML wrapper around handoff file search logic
2. Add explicit `<state_contract>` section documenting read-only nature

### Optional (10 minutes)
1. Consolidate error examples to reduce redundancy

## Notes

This command demonstrates the **ideal command pattern** for the Plugin Freedom System:
- Minimal routing layer (123 lines)
- Single clear delegation to skill
- Zero implementation details in command
- All complexity delegated to context-resume skill
- Follows instructed routing pattern perfectly

**Recommendation:** Use `/continue` as the reference template when refactoring other commands.

## Token Analysis

**Current size:** ~1,200 tokens
**After optimizations:** ~1,080 tokens
**Reduction:** 120 tokens (10%)

**Breakdown:**
- Optimization #1 (error consolidation): 80 tokens
- Optimization #2 (XML preconditions): 0 tokens (clarification only)
- Optimization #3 (state contracts): 40 tokens

**Conclusion:** Command is already well-optimized. Suggested changes focus on **clarity and structural consistency** rather than token reduction.
