# Fix Plan: /research

## Summary
- Critical fixes: 2
- Extraction operations: 3
- Total estimated changes: 10
- Estimated time: 25 minutes
- Token savings: ~450 tokens (19% reduction)

## Phase 1: Critical Fixes (Blocking Issues)

### Fix 1.1: Add Explicit Routing Instruction
**Location:** Lines 6-8
**Operation:** REPLACE
**Severity:** CRITICAL

**Before:**
```markdown
# /research

Invoke the deep-research skill to investigate complex JUCE plugin development problems.
```

**After:**
```markdown
# /research

<routing>
  <instruction>
    Invoke the deep-research skill via the Skill tool.
  </instruction>

  <context_to_pass>
    Pass the user's topic/question as the research subject to the skill.
    Include any specific context from the conversation (plugin name, error messages, code snippets).
  </context_to_pass>

  <skill_responsibility>
    The deep-research skill handles:
    - Graduated research protocol execution (Level 1-3)
    - Local troubleshooting/ knowledge base search
    - Context7 JUCE documentation search
    - JUCE forum and GitHub investigation
    - Parallel research subagents (Level 3 only)
    - Decision menu presentation per checkpoint protocol
  </skill_responsibility>
</routing>
```

**Verification:**
- [ ] XML tags parse correctly
- [ ] Explicit imperative instruction ("Invoke the deep-research skill via the Skill tool")
- [ ] Claude routes to skill instead of treating command as documentation
- [ ] Context passing is explicit

**Token impact:** +150 tokens (critical structural clarity)

### Fix 1.2: Add State Management Documentation
**Location:** After line 8 (after routing section)
**Operation:** INSERT
**Severity:** CRITICAL

**Insert after routing section:**
```markdown

<state_management>
  <reads_from>
    <file path="troubleshooting/**/*.md">
      Searches local knowledge base for existing solutions (Level 1).
      Dual-indexed structure: by-plugin/ and by-symptom/.
    </file>
    <file path="troubleshooting/patterns/juce8-critical-patterns.md">
      May reference critical patterns during investigation.
    </file>
  </reads_from>

  <may_write_to>
    <file path="troubleshooting/[category]/[plugin]/[problem].md">
      If user chooses to document findings after Level 2-3 research.
      Handled by troubleshooting-docs skill (not deep-research itself).
    </file>
  </may_write_to>

  <integration>
    <command name="/doc-fix">
      Complementary: /doc-fix captures immediate solutions from conversation,
      /research investigates complex unknowns requiring external search.
    </command>
    <command name="/improve">
      May trigger research when implementing complex features or fixes.
    </command>
    <skill name="troubleshooting-docs">
      May be invoked after successful research to document findings.
    </skill>
  </integration>
</state_management>
```

**Verification:**
- [ ] State files are explicitly documented
- [ ] Read vs write operations are clear
- [ ] Integration points with other commands/skills are specified
- [ ] Troubleshooting directory structure is referenced

**Token impact:** +200 tokens (critical integration clarity)

## Phase 2: Content Extraction (Token Reduction)

### Fix 2.1: Consolidate Redundant Level Descriptions
**Location:** Lines 10-59
**Operation:** REPLACE
**Severity:** HIGH (token efficiency)

**Before:**
```markdown
## Purpose

Uses graduated research protocol to find solutions efficiently:

- **Level 1:** Quick check (local docs + Context7) - 5-10 min
- **Level 2:** Moderate investigation (forums + GitHub) - 15-30 min
- **Level 3:** Deep research (parallel investigation + academic papers) - 30-60 min

Auto-escalates based on confidence. You control depth via decision menus.

## Usage

```bash
/research [topic]
/research [question or problem description]
```

## Examples

```bash
/research wavetable anti-aliasing implementation
/research how to use juce::dsp::Compressor
/research parameter not saving in DAW
/research CPU spikes when changing parameters
```

## What It Does

### Level 1: Quick Check (5-10 min)

- Searches local `troubleshooting/` knowledge base
- Checks Context7 JUCE documentation
- Returns immediately if confident solution found

### Level 2: Moderate Investigation (15-30 min)

- Deep-dive Context7 module documentation
- Searches JUCE forum for discussions
- Searches GitHub for issues and solutions
- Returns structured analysis with multiple options

### Level 3: Deep Research (30-60 min)

- **Switches to Opus model + extended thinking**
- Spawns 2-3 parallel research subagents
- Investigates multiple approaches concurrently
- Synthesizes findings with comprehensive comparison
- Academic paper search (for DSP algorithms)
- Returns detailed report with implementation roadmap
```

**After:**
```markdown

<background_info>
## Purpose

The deep-research skill uses a graduated research protocol (3 levels) to efficiently find solutions
without over-researching simple problems. Auto-escalates based on confidence.

<graduated_protocol>
  <level number="1" duration="5-10min" model="Sonnet">
    <searches>
      - Local troubleshooting/ knowledge base
      - Context7 JUCE documentation (quick lookup)
    </searches>
    <output>Direct solution if confident match found</output>
    <escalates_if>No confident solution in local/cached sources</escalates_if>
  </level>

  <level number="2" duration="15-30min" model="Sonnet">
    <searches>
      - Context7 deep-dive (module-level documentation)
      - JUCE forum discussions
      - GitHub issues and solutions
    </searches>
    <output>Structured analysis with multiple solution options</output>
    <escalates_if>Multiple partial solutions requiring comparison, or novel problem</escalates_if>
  </level>

  <level number="3" duration="30-60min" model="Opus + extended thinking">
    <approach>Parallel research subagents (2-3 concurrent)</approach>
    <searches>
      - Comprehensive approach comparison
      - Academic papers (for DSP algorithms)
      - Advanced JUCE API patterns
    </searches>
    <output>Detailed report with implementation roadmap and trade-off analysis</output>
  </level>
</graduated_protocol>

## Examples

```bash
/research wavetable anti-aliasing implementation
/research how to use juce::dsp::Compressor
/research parameter not saving in DAW
/research CPU spikes when changing parameters
```
</background_info>
```

**Verification:**
- [ ] Level descriptions consolidated into single structured section
- [ ] Redundancy eliminated (level protocol described only once)
- [ ] XML structure makes levels easier to parse
- [ ] Examples preserved for reference
- [ ] Wrapped in `<background_info>` to indicate this is context, not execution instructions

**Token impact:** -200 tokens

### Fix 2.2: Replace Example Outputs with Protocol Reference
**Location:** Lines 60-121
**Operation:** REPLACE
**Severity:** HIGH (token efficiency)

**Before:**
```markdown
## Success Output

### Level 1 (Fast Path)

```
✓ Level 1 complete (found solution)

Source: troubleshooting/by-plugin/ReverbPlugin/parameter-issues/[file].md

Solution: [Direct answer]

What's next?
1. Apply solution (recommended)
2. Review details
3. Continue deeper - Escalate to Level 2
4. Other
```

### Level 2 (Moderate)

```
✓ Level 2 complete (found 2 solutions)

Investigated sources:
- Context7 JUCE docs
- JUCE forum (3 threads)
- GitHub (2 issues)

Solutions:
1. [Solution 1] (recommended)
2. [Solution 2] (alternative)

What's next?
1. Apply recommended solution
2. Review all options
3. Continue deeper - Escalate to Level 3
4. Other
```

### Level 3 (Comprehensive)

```
✓ Level 3 complete (parallel investigation)

Investigated 3 approaches:
1. [Approach 1] - Complexity: 2/5, CPU: Medium, Quality: High
2. [Approach 2] - Complexity: 3/5, CPU: Low, Quality: High
3. [Approach 3] - Complexity: 4/5, CPU: Low, Quality: Very High

Recommendation: [Approach 1]
Reasoning: [Why this is best fit]

Implementation roadmap:
[Step-by-step guide]

What's next?
1. Apply recommended solution (recommended)
2. Review all findings
3. Try alternative approach
4. Document findings - Save to troubleshooting/
5. Other
```
```

**After:**
```markdown

<success_protocol>
After each level completion, the deep-research skill will:

1. Present findings summary (solutions, sources, confidence level)
2. Show decision menu per checkpoint protocol (see .claude/CLAUDE.md)
3. Typical options include:
   - Apply solution (recommended)
   - Review details
   - Escalate to next level (if applicable)
   - Document findings (Level 2-3 only)
   - Other
4. WAIT for user response before proceeding

The skill handles decision menu formatting and checkpoint protocol compliance.
</success_protocol>
```

**Verification:**
- [ ] Example outputs removed (redundant with checkpoint protocol)
- [ ] Reference to checkpoint protocol added
- [ ] Decision menu responsibility delegated to skill
- [ ] Protocol steps clearly stated

**Token impact:** -150 tokens

### Fix 2.3: Convert "When To Use" and "Why Graduated Protocol" to XML
**Location:** Lines 123-159
**Operation:** REPLACE
**Severity:** MEDIUM (token efficiency)

**Before:**
```markdown
## When To Use

**Use for:**

- Complex DSP algorithm questions
- Novel feature implementation research
- Performance optimization strategies
- JUCE API usage for advanced scenarios
- Unknown errors requiring investigation
- Architectural decisions

**Don't use for:**

- Simple syntax errors (obvious fixes)
- Known issues (check local docs first)
- Basic JUCE API lookups (use Context7 directly)

## Why Graduated Protocol

**Most problems are fast (Level 1: 5 min):**

- 40% of problems have known solutions in local docs
- Immediate lookup, no over-research

**Some need moderate work (Level 2: 20 min):**

- 40% of problems documented in JUCE forum/GitHub
- Thorough but not exhaustive

**Few need deep research (Level 3: 45 min):**

- 20% of problems are novel or complex
- Parallel investigation justified
- Comprehensive comparison of approaches

**Average resolution:** 15 minutes (weighted by success rates)
```

**After:**
```markdown

<usage_guidance>
  <appropriate_for>
    <case>Complex DSP algorithm questions (wavetable synthesis, anti-aliasing, etc.)</case>
    <case>Novel feature implementation research (no clear JUCE example)</case>
    <case>Performance optimization strategies (CPU profiling, buffer management)</case>
    <case>Advanced JUCE API usage (threading, real-time safety patterns)</case>
    <case>Unknown errors requiring multi-source investigation</case>
    <case>Architectural decisions (plugin structure, parameter management)</case>
  </appropriate_for>

  <not_appropriate_for>
    <case>Simple syntax errors - Fix directly, no research needed</case>
    <case>Known issues already in troubleshooting/ - Use grep or Level 1 will find immediately</case>
    <case>Basic JUCE API lookups - Use Context7 directly (faster)</case>
    <case>Build configuration issues - Check juce8-critical-patterns.md first</case>
  </not_appropriate_for>

  <efficiency_rationale>
    - 40% of problems solved at Level 1 (5 min) - Known solutions
    - 40% of problems solved at Level 2 (20 min) - Forum/GitHub documented
    - 20% of problems require Level 3 (45 min) - Novel/complex research
    - Average weighted resolution: ~15 minutes
    - Knowledge base compounds: Level 3 today becomes Level 1 tomorrow
  </efficiency_rationale>
</usage_guidance>
```

**Verification:**
- [ ] Usage guidance structured as XML
- [ ] Appropriate cases expanded with examples
- [ ] Efficiency rationale preserved but condensed
- [ ] Easier to parse than prose format

**Token impact:** -100 tokens

## Phase 3: Polish (Clarity & Optimization)

### Fix 3.1: Simplify Integration Section
**Location:** Lines 160-178
**Operation:** DELETE
**Severity:** MEDIUM

**Before:**
```markdown
## Integration with Knowledge Base

**The feedback loop:**

1. Level 3 research solves complex problem (45 min)
2. Document findings → `troubleshooting/` knowledge base
3. Similar problem occurs → Level 1 finds it (5 min)
4. Knowledge compounds, research gets faster

After successful Level 2-3 research:

```
This was a complex problem. Document for future reference?

1. Yes - Create troubleshooting doc (recommended)
2. No - Skip documentation
```

If "Yes" → Invokes troubleshooting-docs skill to capture solution.
```

**After:**
```markdown
[DELETE - This is already covered in <usage_guidance><efficiency_rationale> and <state_management><integration>]
```

**Verification:**
- [ ] Redundant section removed
- [ ] Feedback loop concept already captured in efficiency_rationale
- [ ] troubleshooting-docs skill integration already documented in state_management section

**Token impact:** -80 tokens

### Fix 3.2: Consolidate "Routes To" and "Related Commands"
**Location:** Lines 180-188
**Operation:** REPLACE
**Severity:** MEDIUM

**Before:**
```markdown
## Routes To

`deep-research` skill

## Related Commands

- `/doc-fix` - Document solved problems (feeds Level 1 fast path)
- `/improve [Plugin]` - Enhancement workflow (may trigger research)
```

**After:**
```markdown
[DELETE - Already documented in <routing> and <state_management><integration> sections]
```

**Verification:**
- [ ] Routing already explicit in Phase 1 fix
- [ ] Related commands already in state_management integration
- [ ] No information loss

**Token impact:** -40 tokens

### Fix 3.3: Simplify Technical Details
**Location:** Lines 189-206
**Operation:** REPLACE
**Severity:** MEDIUM

**Before:**
```markdown
## Technical Details

**Models:**

- Level 1-2: Sonnet (fast, sufficient for documented problems)
- Level 3: Opus + extended thinking 15k budget (deep reasoning)

**Timeout:**

- Max 60 minutes (returns best findings if exceeded)

**Parallel Investigation (Level 3):**

- Spawns 2-3 concurrent research subagents
- Each investigates different approach
- Main context synthesizes findings
- Faster than serial research (3 agents = 20 min, not 60 min)
```

**After:**
```markdown
[MOVE to background_info section after graduated_protocol - this is implementation detail]

<technical_implementation>
  <models>
    - Level 1-2: Sonnet (fast, sufficient for documented problems)
    - Level 3: Opus + extended thinking 15k budget (deep reasoning)
  </models>

  <timeout>Max 60 minutes (returns best findings if exceeded)</timeout>

  <parallel_investigation level="3">
    Spawns 2-3 concurrent research subagents, each investigating different approach.
    Main context synthesizes findings.
    Faster than serial (3 agents = 20 min, not 60 min).
  </parallel_investigation>
</technical_implementation>
</background_info>
```

**Verification:**
- [ ] Technical details preserved
- [ ] Moved to background_info (not execution instruction)
- [ ] XML structure for easier parsing

**Token impact:** -30 tokens (slight reduction via condensing)

## Special Instructions

None - this command is architecturally correct (routing layer only, skill handles implementation).
No need to convert to skill or archive.

## File Operations Manifest

**Files to create:**
None

**Files to modify:**
1. `.claude/commands/research.md` - Apply all fixes from Phases 1-3

**Files to archive:**
None

## Execution Checklist

**Phase 1 (Critical):**
- [ ] Explicit routing instruction with XML enforcement (Fix 1.1)
- [ ] State management section documenting reads/writes (Fix 1.2)
- [ ] No ambiguous language or implied routing
- [ ] Integration points clearly specified

**Phase 2 (Extraction):**
- [ ] Redundant level descriptions consolidated (Fix 2.1)
- [ ] Example outputs replaced with protocol reference (Fix 2.2)
- [ ] Usage guidance converted to XML (Fix 2.3)
- [ ] All content wrapped in `<background_info>` vs routing sections

**Phase 3 (Polish):**
- [ ] Redundant integration section removed (Fix 3.1)
- [ ] Duplicate routing/related commands removed (Fix 3.2)
- [ ] Technical details moved to background_info (Fix 3.3)
- [ ] Token count reduced by ~450 tokens

**Final Verification:**
- [ ] Command loads without errors
- [ ] Command appears in `/help` with correct description
- [ ] Routing section is first executable instruction
- [ ] State management clearly documented
- [ ] Background info separated from execution instructions
- [ ] Health score improved from 23/40 to estimated 35/40

## Estimated Impact

**Before:**
- Health score: 23/40
- Line count: 206 lines
- Token count: ~2,400 tokens
- Critical issues: 2
- Structure: Documentation-style (user-facing)

**After:**
- Health score: 35/40 (target)
- Line count: ~150 lines
- Token count: ~1,950 tokens
- Critical issues: 0
- Structure: Execution-first with background context

**Improvement:** +12 health points, -19% tokens

## Recommended Command Structure (Final)

After all fixes applied, command should have this exact structure:

```markdown
---
name: research
description: Deep investigation for complex JUCE problems
---

# /research

<routing>
  [Explicit skill invocation instruction - Fix 1.1]
</routing>

<state_management>
  [Files read/written, integration points - Fix 1.2]
</state_management>

<success_protocol>
  [Decision menu reference - Fix 2.2]
</success_protocol>

<background_info>
## Purpose
[Brief explanation of graduated protocol concept]

<graduated_protocol>
  [Level 1-3 definitions - Fix 2.1]
</graduated_protocol>

<usage_guidance>
  [When to use / not use - Fix 2.3]
</usage_guidance>

<technical_implementation>
  [Models, timeouts, parallel investigation - Fix 3.3]
</technical_implementation>

## Examples
[Usage examples preserved]
</background_info>
```

Total: ~150 lines, ~1,950 tokens

## Notes for Executor

1. Apply fixes sequentially by phase to avoid conflicts
2. Use exact line numbers from analysis report (already verified against command file)
3. XML tags must be properly closed
4. Test command loads correctly after Phase 1 (critical routing)
5. Verify token count reduction matches estimates
6. Ensure no information loss - everything preserved in restructured form
7. Final structure separates execution instructions (routing, state) from reference documentation (background_info)
