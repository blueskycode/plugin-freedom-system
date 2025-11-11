---
name: research
description: Deep investigation for complex JUCE problems
---

# /research

Invoke the deep-research skill to investigate complex JUCE plugin development problems.

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

## Routes To

`deep-research` skill

## Related Commands

- `/doc-fix` - Document solved problems (feeds Level 1 fast path)
- `/improve [Plugin]` - Enhancement workflow (may trigger research)

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
