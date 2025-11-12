# Command Analysis: research

## Executive Summary
- Overall health: **Yellow** (Command is functional but lacks structural enforcement for preconditions and critical sequences)
- Critical issues: **2** (No XML precondition enforcement, no structured routing logic)
- Optimization opportunities: **3** (Token reduction via XML structure, explicit skill invocation, state documentation)
- Estimated context savings: **~450 tokens (~20% reduction)**

## Dimension Scores (1-5)

1. **Structure Compliance: 5/5** - Complete YAML frontmatter with name and description
2. **Routing Clarity: 3/5** - Routes to `deep-research` skill mentioned at bottom but not structurally enforced
3. **Instruction Clarity: 4/5** - Clear documentation of graduated protocol but lacks imperative routing instructions
4. **XML Organization: 2/5** - Zero XML structure, entirely prose-based documentation
5. **Context Efficiency: 3/5** - 206 lines, reasonable but has duplication in level descriptions
6. **Claude-Optimized Language: 3/5** - Mix of documentation and implicit routing, lacks explicit imperative commands
7. **System Integration: 2/5** - No documentation of state files, knowledge base interactions mentioned but not structured
8. **Precondition Enforcement: 1/5** - No preconditions defined or enforced

**Total Score: 23/40 (Yellow)**

## Critical Issues (blockers for Claude comprehension)

### Issue #1: No Routing Instruction (Lines 1-206)
**Severity:** CRITICAL
**Impact:** Command reads like user documentation instead of Claude execution instructions. No explicit imperative command to invoke the deep-research skill. The routing is implied (line 182 "Routes To") but not structured.

**Current problematic structure:**
```markdown
# /research

Invoke the deep-research skill to investigate complex JUCE plugin development problems.

## Purpose
[User documentation...]

## Routes To
`deep-research` skill
```

**Problem:**
- Claude must infer from line 8 ("Invoke the deep-research skill") that this is an instruction
- No explicit routing logic with preconditions
- No structured enforcement of when/how to invoke skill
- Entire file reads as reference documentation, not execution instruction

**Recommended Fix:**
Add explicit routing section with XML enforcement at the top after frontmatter:

```xml
<routing>
  <instruction>
    Invoke the deep-research skill via the Skill tool.
  </instruction>

  <context_to_pass>
    Pass $ARGUMENTS as the research topic/question.
  </context_to_pass>

  <skill_responsibility>
    The deep-research skill will handle:
    - Graduated research protocol (Level 1-3)
    - Knowledge base search
    - Context7 documentation search
    - Forum/GitHub investigation
    - Parallel research subagents (Level 3)
    - Decision menu presentation
  </skill_responsibility>
</routing>

<background_info>
[Move all current documentation here as reference for Claude to understand context]
</background_info>
```

### Issue #2: No State File Documentation (Lines 1-206)
**Severity:** CRITICAL
**Impact:** Command doesn't document which state files the deep-research skill reads/writes, making integration unclear.

**Current state:** No mention of:
- `troubleshooting/` directory structure (read)
- `.continue-here.md` interactions (if any)
- `PLUGINS.md` dependencies (if any)
- Generated research reports (if any)

**Problem:**
- Unclear what state exists before/after skill execution
- No documentation of troubleshooting knowledge base structure
- Missing integration points with other commands (`/doc-fix`)

**Recommended Fix:**
```xml
<state_management>
  <reads_from>
    <file path="troubleshooting/**/*.md">
      Searches local knowledge base for existing solutions (Level 1)
    </file>
  </reads_from>

  <may_write_to>
    <file path="troubleshooting/[category]/[plugin]/[problem].md">
      If user chooses to document findings after Level 2-3 research
    </file>
  </may_write_to>

  <integration>
    <command name="/doc-fix">
      Complementary: /doc-fix captures immediate solutions, /research investigates complex unknowns
    </command>
    <skill name="troubleshooting-docs">
      May be invoked after successful research to document findings
    </skill>
  </integration>
</state_management>
```

## Optimization Opportunities

### Optimization #1: Reduce Redundant Level Descriptions (Lines 12-59, 64-121)
**Potential savings:** ~200 tokens (~10% reduction)
**Current:** Level protocol described twice - once in "Purpose" section (lines 12-18) and again in detailed "What It Does" section (lines 38-59), then again in example outputs (lines 64-121)
**Recommended:** Consolidate into single structured reference section:

```xml
<graduated_protocol>
  <level number="1" duration="5-10min" model="Sonnet">
    <searches>Local troubleshooting/ knowledge base, Context7 JUCE docs</searches>
    <escalates_if>No confident solution found</escalates_if>
  </level>

  <level number="2" duration="15-30min" model="Sonnet">
    <searches>Context7 deep-dive, JUCE forum, GitHub issues</searches>
    <escalates_if>Multiple partial solutions, need comparison</escalates_if>
  </level>

  <level number="3" duration="30-60min" model="Opus + extended thinking">
    <approach>Parallel research subagents (2-3 concurrent)</approach>
    <searches>Academic papers, comprehensive approach comparison</searches>
    <output>Detailed roadmap with implementation guidance</output>
  </level>
</graduated_protocol>
```

**Token savings:** Remove ~15 lines of redundant explanation = ~200 tokens

### Optimization #2: Consolidate Example Outputs (Lines 64-121)
**Potential savings:** ~150 tokens (~7% reduction)
**Current:** Three full example outputs with complete decision menus
**Recommended:** Reference checkpoint protocol instead of duplicating decision menu format:

```xml
<success_protocol>
  After each level completion:
  1. Present findings summary
  2. Show decision menu per checkpoint protocol (see .claude/CLAUDE.md)
  3. Options include: Apply solution, Review details, Escalate to next level, Other
  4. WAIT for user response before proceeding
</success_protocol>
```

**Token savings:** ~150 tokens by referencing existing protocol instead of showing 3 full examples

### Optimization #3: Structure "When To Use" as XML (Lines 123-138)
**Potential savings:** ~100 tokens (~5% reduction)
**Current:** Prose lists with bold headers
**Recommended:**

```xml
<usage_guidance>
  <appropriate_for>
    <case>Complex DSP algorithm questions</case>
    <case>Novel feature implementation research</case>
    <case>Performance optimization strategies</case>
    <case>JUCE API usage for advanced scenarios</case>
    <case>Unknown errors requiring investigation</case>
    <case>Architectural decisions</case>
  </appropriate_for>

  <not_appropriate_for>
    <case>Simple syntax errors (obvious fixes)</case>
    <case>Known issues (check local docs first with grep)</case>
    <case>Basic JUCE API lookups (use Context7 directly)</case>
  </not_appropriate_for>
</usage_guidance>
```

**Token savings:** More concise, easier to parse = ~100 tokens

## Implementation Priority

### 1. Immediate (Critical issues blocking comprehension)
- **Issue #1:** Add explicit routing instruction with XML structure (lines 1-10)
- **Issue #2:** Document state file interactions (add after routing section)

### 2. High (Major optimizations)
- **Optimization #1:** Consolidate redundant level descriptions into single XML structure
- **Optimization #2:** Replace example outputs with protocol reference

### 3. Medium (Minor improvements)
- **Optimization #3:** Convert "When To Use" section to XML
- Consider removing lines 140-178 ("Why Graduated Protocol", "Integration with Knowledge Base") as this is justification for system design, not execution instructions for Claude

## Recommended Structure

After fixes, command should follow this structure:

```markdown
---
name: research
description: Deep investigation for complex JUCE problems
---

<routing>
  [Explicit skill invocation instruction]
</routing>

<state_management>
  [Files read/written, integration points]
</state_management>

<graduated_protocol>
  [Level 1-3 definitions]
</graduated_protocol>

<usage_guidance>
  [When to use / not use]
</usage_guidance>

<success_protocol>
  [Decision menu reference]
</success_protocol>

<background_info>
  [Optional context about why this protocol exists - can be verbose]
</background_info>
```

## Verification Checklist

After implementing fixes, verify:
- [x] YAML frontmatter includes required fields (already compliant)
- [ ] Explicit skill invocation instruction with XML enforcement
- [ ] State file interactions documented
- [ ] Routing logic is imperative, not descriptive
- [ ] Command under 150 lines after optimization
- [ ] Redundant descriptions consolidated
- [ ] Decision menu format references checkpoint protocol instead of duplicating

## Token Impact Analysis

**Current:** ~2,400 tokens (206 lines × ~12 tokens/line average)
**After fixes:** ~1,950 tokens
**Savings:** ~450 tokens (~19% reduction)

**Breakdown:**
- Routing structure: +50 tokens (new)
- State management: +80 tokens (new)
- Redundancy removal: -200 tokens
- Example consolidation: -150 tokens
- Usage guidance XML: -100 tokens
- Background section restructure: -130 tokens
**Net:** -450 tokens

## Command-Specific Observations

### Strengths
1. Clear documentation of graduated protocol concept
2. Good examples of what each level produces
3. Integration with knowledge base explained well
4. Technical details about models/timeouts included

### Weaknesses
1. Written as user documentation, not Claude execution instructions
2. No structural enforcement of routing logic
3. Missing integration contracts (state files)
4. Significant redundancy in level descriptions
5. Decision menu format duplicated instead of referencing system protocol

### Pattern for Other Commands
The `/research` command reveals a common pattern: commands written as user-facing documentation instead of Claude execution instructions. Other commands should be checked for:
- Explicit routing sections (not implied)
- State management documentation
- XML structural enforcement
- Imperative language for Claude, reference documentation in background sections

### Recommended Next Steps
1. Apply critical fixes (routing + state management)
2. Test that deep-research skill is invoked correctly
3. Verify decision menus follow checkpoint protocol
4. Apply token optimizations
5. Use this pattern as template for other research/investigation commands (`/troubleshoot-juce`, `/doc-fix`)
