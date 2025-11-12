# Command Analysis: test

## Executive Summary
- Overall health: **Yellow** (Functional routing but lacks structural enforcement)
- Critical issues: **2** (Missing XML enforcement for preconditions and critical sequences)
- Optimization opportunities: **3** (XML wrapping, conditional logic structure, token reduction)
- Estimated context savings: **320 tokens (20% reduction)**

## Dimension Scores (1-5)
1. Structure Compliance: **5/5** (Complete YAML frontmatter with description)
2. Routing Clarity: **4/5** (Clear routing to skills, but conditional logic not structurally enforced)
3. Instruction Clarity: **4/5** (Clear instructions, but imperative voice inconsistent)
4. XML Organization: **2/5** (No XML enforcement for preconditions or critical sequences)
5. Context Efficiency: **4/5** (160 lines, reasonable length but has redundancy)
6. Claude-Optimized Language: **4/5** (Mostly clear, some descriptive instead of imperative language)
7. System Integration: **3/5** (Mentions PLUGINS.md but doesn't document state changes)
8. Precondition Enforcement: **2/5** (Preconditions listed but not structurally enforced with XML)

## Critical Issues (blockers for Claude comprehension)

### Issue #1: Preconditions Not XML-Wrapped (Lines 10-21)
**Severity:** CRITICAL
**Impact:** Claude may skip precondition validation under token pressure, leading to routing errors

Current implementation uses markdown prose:
```markdown
## Preconditions

**Check PLUGINS.md status:**
- Plugin MUST exist
- Status MUST NOT be 💡 Ideated (need implementation to test)

**If status is 💡:**
Reject with message:
```
[PluginName] is not implemented yet (Status: 💡 Ideated).
Use /implement [PluginName] to build it first.
```
```

**Problem:** Natural language emphasis (MUST, MUST NOT) lacks structural enforcement. Claude can miss these checks during context compression or skip validation when routing directly to skills.

**Recommended Fix:** Wrap in XML with enforcement attributes:
```xml
<preconditions enforcement="blocking">
  <check target="PLUGINS.md" condition="plugin_exists">
    Plugin entry MUST exist in PLUGINS.md
  </check>
  <check target="PLUGINS.md::status" condition="not_equals(💡 Ideated)">
    Status MUST NOT be 💡 Ideated (requires implementation to test)
  </check>
  <rejection_message status="💡 Ideated">
[PluginName] is not implemented yet (Status: 💡 Ideated).
Use /implement [PluginName] to build it first.
  </rejection_message>
</preconditions>
```

**Token Impact:** +80 tokens for XML structure, -40 tokens by removing redundant prose = +40 tokens net, but drastically improves reliability.

### Issue #2: Conditional Routing Logic Not Structured (Lines 23-102)
**Severity:** HIGH
**Impact:** Claude must parse prose to determine which skill to invoke, increasing error probability

Current implementation describes three test methods in prose with mixed descriptive/imperative language:

```markdown
### 1. Automated Stability Tests
**Command:** `/test [PluginName] automated`
**Requirements:** `plugins/[Plugin]/Tests/` directory must exist
**Routes to:** plugin-testing skill
**Duration:** ~2 minutes
```

**Problem:** Routing decision logic is implicit. Claude must parse natural language to determine:
1. Which mode maps to which skill
2. What requirements gate each mode
3. What to do when requirements aren't met

**Recommended Fix:** Wrap routing logic in structured XML:
```xml
<routing_logic>
  <mode name="automated" argument="automated">
    <requirement path="plugins/{PluginName}/Tests/" type="directory" />
    <routes_to skill="plugin-testing" />
    <duration estimate="2 minutes" />
    <tests>
      - Parameter stability (all combinations, edge cases)
      - State save/restore (preset corruption)
      - Processing stability (buffer sizes, sample rates)
      - Thread safety (concurrent access)
      - Edge case handling (silence, extremes, denormals)
    </tests>
  </mode>

  <mode name="build" argument="build">
    <requirement>Always available (no dependencies)</requirement>
    <routes_to skill="build-automation" />
    <duration estimate="5-10 minutes" />
    <steps>
      1. Build Release mode (VST3 + AU)
      2. Run pluginval with strict settings (level 10)
      3. Install to system folders
      4. Clear DAW caches
    </steps>
  </mode>

  <mode name="manual" argument="manual">
    <requirement>Always available</requirement>
    <routes_to>Display checklist directly (no skill invocation)</routes_to>
    <checklist_items>Load & initialize, Audio processing, Parameter testing, State management, Performance, Compatibility, Stress testing</checklist_items>
  </mode>
</routing_logic>
```

**Token Impact:** +150 tokens for XML structure, -100 tokens by removing redundant prose explanations = +50 tokens net, but makes routing deterministic.

## Optimization Opportunities

### Optimization #1: Consolidate Redundant Behavior Descriptions (Lines 72-102)
**Potential savings:** 120 tokens (15% reduction)

**Current:** Three separate prose blocks describe behavior for different argument combinations (no plugin, plugin no mode, plugin with mode). Each block repeats the presentation format.

**Problem:** Redundancy in describing decision menu patterns that are already documented in system CLAUDE.md checkpoint protocol.

**Recommended:** Replace with concise routing table:
```xml
<behavior>
  <case arguments="none">
    List available plugins with test status from PLUGINS.md
  </case>
  <case arguments="plugin_only">
    Present test method decision menu (adapt based on Tests/ directory existence)
  </case>
  <case arguments="plugin_and_mode">
    Execute test directly via appropriate skill
  </case>
</behavior>
```

**Token Impact:** -120 tokens (removes ~40 lines of redundant menu examples that duplicate checkpoint protocol).

### Optimization #2: Extract Error Handling to Shared Reference (Lines 112-150)
**Potential savings:** 80 tokens (10% reduction)

**Current:** Error handling blocks describe numbered decision menus for three failure scenarios (test fail, build fail, pluginval fail). These follow identical patterns.

**Problem:** All three blocks present variations of the same 4-option menu pattern. This is system-level behavior, not command-specific routing.

**Recommended:** Replace with reference to shared error protocol:
```xml
<error_handling>
  <on_failure type="automated_tests|build|pluginval">
    Present standard failure menu:
    1. Investigate (trigger deep-research skill)
    2. Show me the code
    3. Show full output
    4. I'll fix it manually
  </on_failure>
</error_handling>
```

**Token Impact:** -80 tokens by consolidating three similar blocks into one structured reference.

### Optimization #3: Clarify Auto-Invocation vs Manual Invocation (Lines 104-110)
**Potential savings:** 40 tokens (5% reduction)

**Current:** Section describes when plugin-workflow auto-invokes testing, but this information belongs in plugin-workflow skill, not in the /test command routing layer.

**Problem:** Commands should describe user-initiated behavior, not how other skills invoke them. This creates circular context loading (plugin-workflow loads test.md, which describes plugin-workflow behavior).

**Recommended:** Move to plugin-workflow skill's SKILL.md and replace with single line:
```markdown
## Integration
This command is also auto-invoked by plugin-workflow after Stage 4 (DSP) and Stage 5 (GUI).
```

**Token Impact:** -40 tokens, improves separation of concerns.

## Implementation Priority

1. **Immediate** (Critical issues blocking reliable execution)
   - Issue #1: XML-wrap preconditions with blocking enforcement
   - Issue #2: Structure conditional routing logic in XML

2. **High** (Major optimizations improving token efficiency)
   - Optimization #1: Consolidate redundant behavior descriptions
   - Optimization #2: Extract error handling to shared reference

3. **Medium** (Minor improvements)
   - Optimization #3: Move auto-invocation docs to plugin-workflow

## State File Documentation

**Missing:** Command should document which state files it reads and writes:

```xml
<state_interactions>
  <reads>
    - PLUGINS.md (plugin status, test capabilities)
  </reads>
  <writes>
    - None (testing results logged to console, skills handle any state updates)
  </writes>
</state_interactions>
```

## Verification Checklist

After implementing fixes, verify:
- [x] YAML frontmatter includes description field
- [ ] Preconditions wrapped in XML with enforcement="blocking"
- [ ] Routing logic structured in XML with clear skill invocation
- [ ] Command is under 200 lines (currently 160, target 120 after optimizations)
- [x] Routing to skills is explicit (already clear: plugin-testing, build-automation)
- [ ] State file interactions documented
- [ ] Error handling references shared protocol instead of duplicating menus
- [ ] Auto-invocation behavior moved to plugin-workflow documentation

## Additional Notes

**Strengths:**
- Clean YAML frontmatter
- Clear three-method taxonomy (automated, build, manual)
- Explicit skill routing (plugin-testing vs build-automation)
- Reasonable length (160 lines)

**Architectural Question:**
Should "manual" mode (displaying checklist) route to a skill, or is direct display appropriate? Current approach (no skill) is reasonable for static content, but consider extracting checklist to `plugin-testing/references/manual-testing-checklist.md` to reduce command file size.

**Consistency Note:**
Compare error handling pattern with other commands (improve, implement, continue). If they use similar 4-option failure menus, extract to shared `.claude/references/error-handling-protocol.md` and reference from all commands.
