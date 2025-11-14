# Skill Audit: plugin-workflow

**Audit Date:** 2025-11-13
**Skill Path:** .claude/skills/plugin-workflow

## Executive Summary

The plugin-workflow skill is a sophisticated orchestrator for JUCE plugin implementation stages. It demonstrates strong adherence to progressive disclosure, clear separation of concerns via subagent delegation, and robust state management. However, the skill significantly exceeds recommended length limits (1197 lines vs 500-line target) and contains several areas where token optimization, conciseness, and structural improvements could enhance maintainability and performance.

**Overall Assessment:** NEEDS IMPROVEMENT

**Key Metrics:**
- SKILL.md size: 1197 lines / 500 limit (139% over target)
- Reference files: 13 files (4150 total lines)
- Assets files: 5 files
- Critical issues: 3
- Major issues: 8
- Minor issues: 6

---

## Findings by Category

### 1. Progressive Disclosure Compliance

**Status:** ❌ FAIL

**Findings:**

- **Finding:** SKILL.md exceeds 500-line limit by 139%
  - **Severity:** CRITICAL
  - **Evidence:** Lines 1-1197 (target: ~500 lines)
  - **Impact:** Loads 2.5x more tokens than recommended on every skill invocation, consuming excessive context window space. Estimated ~8-10k tokens per load vs target ~4-5k tokens.
  - **Recommendation:** Move detailed implementation logic to references. Keep SKILL.md as overview with signposts to reference files. Specifically move: workflow loop pseudocode (lines 527-678), express mode functions (lines 694-800), validation functions (lines 804-942), creative brief sync (lines 457-523), and mode detection logic (lines 238-306).
  - **Rationale:** Progressive disclosure principle states SKILL.md should be high-level overview. Detailed implementations belong in references/ where they're loaded on-demand.
  - **Priority:** P0

- **Finding:** Some reference depth is appropriate but could be better signposted
  - **Severity:** MINOR
  - **Evidence:** References are one level deep (correct), but SKILL.md doesn't clearly indicate WHEN each reference is needed
  - **Impact:** Claude may load unnecessary references, wasting context window
  - **Recommendation:** Add usage annotations: "See [dispatcher-pattern.md] (loaded when routing stages)" vs "See [error-handling.md] (loaded only when errors occur)"
  - **Rationale:** Explicit loading conditions help optimize context window usage
  - **Priority:** P2

### 2. YAML Frontmatter Quality

**Status:** ⚠️ ISSUES

**Findings:**

- **Finding:** Description lacks specific trigger conditions
  - **Severity:** MAJOR
  - **Evidence:** Line 3: "Implementation orchestrator for stages 1-4 (Foundation through Validation)"
  - **Impact:** Doesn't tell Claude WHEN to use this skill. Lacks trigger words/phrases that would enable auto-discovery.
  - **Recommendation:** Revise to: "Orchestrates JUCE plugin implementation through stages 1-4 (Foundation, DSP, GUI, Validation) using subagent delegation. Use when implementing plugins after planning completes, or when resuming with /continue command. Invoked by /implement command."
  - **Rationale:** Effective descriptions include both WHAT (orchestrates stages 1-4) AND WHEN (after planning, via /implement or /continue)
  - **Priority:** P1

- **Finding:** Incorrect stage numbering in description
  - **Severity:** MAJOR
  - **Evidence:** Line 3 says "stages 1-4" but SKILL.md content references "stages 2-5" in multiple places (lines 31, 528, 1034)
  - **Impact:** Confusing documentation creates maintenance burden. CLAUDE.md says stages are "2-5" (renumbered from 1-4), but frontmatter still says "1-4"
  - **Recommendation:** Update description to match actual stage numbers: "stages 2-5" or use milestone names: "Foundation through Validation"
  - **Rationale:** Consistency between frontmatter and content prevents confusion
  - **Priority:** P1

### 3. Conciseness Discipline

**Status:** ❌ FAIL

**Findings:**

- **Finding:** Excessive inline pseudocode and implementation details
  - **Severity:** CRITICAL
  - **Evidence:** Lines 272-306 (workflow mode detection function), 527-678 (workflow loop), 694-800 (express mode functions), 804-942 (validation functions)
  - **Impact:** ~400+ lines of detailed implementation code in main skill file. Estimated 3-4k token waste per skill load that should be in references.
  - **Recommendation:** Move all function implementations to references/workflow-functions.md. Replace with high-level descriptions: "Workflow mode detection: See references/workflow-functions.md#getWorkflowMode"
  - **Rationale:** SKILL.md should describe WHAT happens, not HOW it's implemented. Claude already knows how to write functions.
  - **Priority:** P0

- **Finding:** Redundant enforcement reminders
  - **Severity:** MAJOR
  - **Evidence:** Lines 33-63 (delegation rule), 65-92 (checkpoint protocol), 1118-1139 (critical reminders), 1151-1196 (anti-patterns) - same concepts repeated 3-4 times
  - **Impact:** ~200 lines restating "MUST delegate to subagents" in different sections. Wastes ~1.5k tokens.
  - **Recommendation:** State delegation requirement ONCE in clear enforcement section at top. Remove duplicate reminders. Use single anti-patterns section instead of scattering throughout.
  - **Rationale:** Repetition doesn't improve adherence but wastes tokens. Single authoritative statement is sufficient.
  - **Priority:** P1

- **Finding:** Over-explained preconditions
  - **Severity:** MAJOR
  - **Evidence:** Lines 160-234 (precondition verification with nested XML, bash code examples, error messages)
  - **Impact:** ~75 lines explaining file existence checks. Claude knows how to check if files exist.
  - **Recommendation:** Simplify to: "Before Stage 2: Verify architecture.md, plan.md, creative-brief.md, parameter-spec.md exist. If missing, block with error. See references/precondition-checks.md for implementation."
  - **Rationale:** Claude doesn't need step-by-step bash tutorial for file existence checks
  - **Priority:** P1

- **Finding:** Verbose XML structure tags
  - **Severity:** MINOR
  - **Evidence:** Nested XML with verbose attributes throughout (enforcement_level, blocking, violation, etc.)
  - **Impact:** ~50-100 extra tokens from XML verbosity that could use simpler markdown
  - **Recommendation:** Use simpler markdown headings and bullets for structure. Reserve XML for truly complex nested logic only.
  - **Rationale:** XML is useful for structure but shouldn't be overused. Markdown is more concise for simple lists/sections.
  - **Priority:** P2

- **Finding:** Example code blocks that could be summarized
  - **Severity:** MINOR
  - **Evidence:** Lines 375-410 (bash script with full heredoc), multiple other bash/typescript examples throughout
  - **Impact:** Full code examples in SKILL.md when reference to external file would suffice
  - **Recommendation:** Replace inline code with: "See references/state-management.md#verifyStateIntegrity for implementation"
  - **Rationale:** Examples are valuable in references, redundant in main skill file
  - **Priority:** P2

### 4. Validation Patterns

**Status:** ✅ PASS

**Findings:**

✅ All validation patterns properly implemented:
- Checkpoint verification (lines 609-650) validates all steps before presenting menu
- Plan-validate-execute pattern used for complex workflows (phase-aware dispatch)
- Feedback loops present (validation-agent results inform user decisions)
- Clear success/exit criteria documented throughout
- Fallback error handling comprehensive (state verification → fallback → recovery menu)

### 5. Checkpoint Protocol Compliance

**Status:** ⚠️ ISSUES

**Findings:**

- **Finding:** Checkpoint protocol correctly implemented but over-documented
  - **Severity:** MINOR
  - **Evidence:** Checkpoint protocol explained in 3 separate locations: lines 65-92 (checkpoint_protocol XML), 527-678 (workflow loop with checkpoint), 609-650 (checkpoint verification)
  - **Impact:** Same 6-step checkpoint repeated multiple times. ~150 lines could be reduced to ~50 with single reference.
  - **Recommendation:** Define checkpoint protocol ONCE at top, reference it elsewhere: "Execute checkpoint protocol (see Checkpoint Protocol section)"
  - **Rationale:** DRY principle - don't repeat yourself. Single source of truth is easier to maintain.
  - **Priority:** P2

- **Finding:** Express vs manual mode handling is correct and well-structured
  - **Severity:** N/A (positive finding)
  - **Evidence:** Lines 238-306 (mode detection), 592-604 (handleCheckpoint routing), 694-800 (express mode functions)
  - **Impact:** Properly implements PFS workflow mode requirements with fallback to manual on errors
  - **Recommendation:** None - this is well-designed
  - **Rationale:** Clear separation of auto-progress vs manual decision menus
  - **Priority:** N/A

### 6. Inter-Skill Coordination

**Status:** ✅ PASS

**Findings:**

✅ Clear boundaries with other skills:
- Delegates to plugin-planning for Stage 0 (research)
- Delegates to foundation-shell-agent, dsp-agent, gui-agent for implementation
- Invokes validation-agent for semantic checks
- Invokes build-automation for compilation verification
- No overlapping responsibilities detected
- Integration contracts clearly documented (references/integration-contracts.md)

### 7. Subagent Delegation Compliance

**Status:** ⚠️ ISSUES

**Findings:**

- **Finding:** Delegation pattern correctly enforced but over-explained
  - **Severity:** MAJOR
  - **Evidence:** Delegation requirement stated in: lines 33-63 (delegation_rule), 367-369 (enforcement_reminder), 531-534 (delegation_enforcement), 972-974 (integration points), 1119-1121 (critical reminder), 1154-1157 (anti-pattern)
  - **Impact:** Same "MUST use Task tool" message repeated 6+ times across 1200 lines. Wastes ~800 tokens on redundancy.
  - **Recommendation:** State delegation requirement ONCE in prominent "Delegation Protocol" section. Remove all other occurrences. Add single anti-pattern example showing wrong vs right approach.
  - **Rationale:** Multiple reminders don't improve compliance. Single clear statement with enforcement example is sufficient.
  - **Priority:** P1

- **Finding:** Subagent prompt construction includes Required Reading correctly
  - **Severity:** N/A (positive finding)
  - **Evidence:** Lines 130-155 (required-reading-injection enforcement)
  - **Impact:** Ensures all subagents receive juce8-critical-patterns.md to prevent repeat mistakes
  - **Recommendation:** None - this is well-designed
  - **Rationale:** Critical pattern injection is core PFS principle for error prevention
  - **Priority:** N/A

- **Finding:** Handoff protocol correctly uses JSON report with stateUpdated field
  - **Severity:** N/A (positive finding)
  - **Evidence:** Lines 94-128 (handoff_protocol), 541-562 (verifyStateUpdate step)
  - **Impact:** Proper verification → fallback pattern for robust state management
  - **Recommendation:** None - this follows state delegation pattern correctly
  - **Rationale:** Aligns with state-management.md reference
  - **Priority:** N/A

### 8. Contract Integration

**Status:** ✅ PASS

**Findings:**

✅ Excellent contract integration:
- All contracts (.ideas/*.md) properly referenced before Stage 2 dispatch
- Contract immutability respected (mentions PostToolUse hook enforcement)
- Zero-drift principle documented (parameters must match parameter-spec.md)
- Checksum validation mentioned for drift detection
- Contract precondition checks block progression if files missing (lines 160-234)

### 9. State Management Consistency

**Status:** ⚠️ ISSUES

**Findings:**

- **Finding:** State delegation pattern correctly implemented with verification → fallback
  - **Severity:** N/A (positive finding)
  - **Evidence:** Lines 541-562 (verifyStateUpdate), 553-562 (fallbackStateUpdate), state-management.md reference
  - **Impact:** Robust state management with 91% token reduction (per state-management.md line 645)
  - **Recommendation:** None - this is a strong pattern
  - **Rationale:** Subagents update state, orchestrator verifies, fallback if needed
  - **Priority:** N/A

- **Finding:** New state fields (workflow_mode, gui_type, auto_*) properly documented
  - **Severity:** N/A (positive finding)
  - **Evidence:** Lines 244-270 (.continue-here.md format with new fields)
  - **Impact:** Backward compatible state evolution with defaults for missing fields
  - **Recommendation:** None - proper state field versioning
  - **Rationale:** Follows best practices for state file evolution
  - **Priority:** N/A

- **Finding:** PLUGINS.md vs .continue-here.md consistency checks present
  - **Severity:** N/A (positive finding)
  - **Evidence:** Lines 375-410 (verifyStateIntegrity function), state-management.md lines 509-560
  - **Impact:** Detects state corruption early with exit code 2 → /reconcile
  - **Recommendation:** None - proper consistency validation
  - **Rationale:** Prevents workflow from proceeding with corrupted state
  - **Priority:** N/A

### 10. Context Window Optimization

**Status:** ❌ FAIL

**Findings:**

- **Finding:** Premature loading of large inline content
  - **Severity:** CRITICAL
  - **Evidence:** Workflow loop (lines 527-678), validation functions (804-942), express mode functions (694-800), creative brief sync (457-523) all loaded immediately even if not needed
  - **Impact:** ~3-4k tokens loaded on every skill invocation regardless of execution path. Simple plugins don't need phase-aware dispatch or express mode details.
  - **Recommendation:** Move execution path-specific logic to references. Load on-demand: "If phased implementation needed, see references/phase-aware-dispatch.md. If express mode enabled, see references/express-mode.md"
  - **Rationale:** Context window is shared resource. Only load what's needed for current execution path.
  - **Priority:** P0

- **Finding:** No parallel tool calls for contract loading
  - **Severity:** MAJOR
  - **Evidence:** References imply sequential reading of architecture.md, plan.md, parameter-spec.md, creative-brief.md
  - **Impact:** Sequential file reads slower than parallel. Could save ~200ms per stage dispatch.
  - **Recommendation:** When loading contracts for subagent prompts, use parallel Read calls: Read(architecture.md) || Read(plan.md) || Read(parameter-spec.md)
  - **Rationale:** agent-skills best practices recommend parallelizing independent tool calls
  - **Priority:** P1

- **Finding:** Required Reading file loaded for every subagent invocation
  - **Severity:** MINOR
  - **Evidence:** Lines 132-154 show juce8-critical-patterns.md read before each Task invocation
  - **Impact:** Same ~2k token file loaded 3-4 times per workflow (Stages 2, 3, 4). Could cache in orchestrator context.
  - **Recommendation:** Read Required Reading once at workflow start, pass to all subagents from memory rather than re-reading file each time
  - **Rationale:** Read once, use multiple times pattern reduces file I/O
  - **Priority:** P2

### 11. Anti-Pattern Detection

**Status:** ⚠️ ISSUES

**Findings:**

- **Finding:** Anti-patterns section well-documented but scattered
  - **Severity:** MINOR
  - **Evidence:** Anti-patterns appear in multiple locations: lines 1151-1196 (anti_patterns section), 1162-1166 (phase-aware dispatch critical anti-pattern), plus various enforcement blocks throughout
  - **Impact:** Same anti-patterns restated multiple times. ~100 lines of redundancy.
  - **Recommendation:** Consolidate all anti-patterns into single section with clear examples. Reference this section from other locations: "Avoid anti-patterns (see Anti-Patterns section)"
  - **Rationale:** Single authoritative anti-pattern list easier to maintain and reference
  - **Priority:** P2

- **Finding:** No Windows path syntax detected
  - **Severity:** N/A (positive finding)
  - **Evidence:** All file paths use forward slashes (/) correctly
  - **Impact:** Cross-platform compatibility maintained
  - **Recommendation:** None
  - **Rationale:** Follows agent-skills best practices
  - **Priority:** N/A

- **Finding:** POV inconsistency in different sections
  - **Severity:** MINOR
  - **Evidence:** Lines 19-20 use third person ("This skill NEVER implements directly"), but lines 1141-1148 use second person checklist ("When executing this skill: 1. Read contracts...")
  - **Impact:** Mixing POV reduces clarity. Should be consistent throughout.
  - **Recommendation:** Use third person throughout main content, reserve second person only for direct instructions/checklists
  - **Rationale:** Consistent voice improves readability
  - **Priority:** P2

- **Finding:** Reference depth correct (one level)
  - **Severity:** N/A (positive finding)
  - **Evidence:** All references are SKILL.md → references/*.md (no nested references/)
  - **Impact:** Proper progressive disclosure structure
  - **Recommendation:** None
  - **Rationale:** Follows agent-skills pattern
  - **Priority:** N/A

---

## Positive Patterns

Notable strengths worth preserving or replicating in other skills:

1. **State delegation with verification → fallback pattern** - Subagents update state, orchestrator verifies, falls back if needed. This reduces orchestrator token overhead by 91% while maintaining reliability through safety net (state-management.md lines 10-20). Excellent example of trust-but-verify pattern.

2. **Phase-aware dispatch for complex workflows** - Automatic detection of phased implementation needs (complexity ≥3 + phase markers in plan.md) prevents "implement all phases" anti-pattern that caused DrumRoulette Stage 4 failure (phase-aware-dispatch.md lines 267-278). Smart routing based on complexity.

3. **Comprehensive checkpoint protocol** - 6-step checkpoint sequence (verify state → fallback → validate → commit → verify checkpoint → present menu) ensures workflow integrity at every stage. Clear verification step prevents state corruption (lines 541-650).

4. **Contract immutability enforcement** - Explicit precondition checks for contract files before Stage 2, combined with PostToolUse hook blocking edits during implementation (lines 160-234). Strong zero-drift principle enforcement.

5. **Express vs manual mode with error safety** - Workflow mode auto-progress drops to manual on ANY error (lines 592-604, 753-778). Prevents silent failures in automation while allowing speed optimization for happy path.

6. **Clear separation of concerns** - Orchestrator NEVER implements directly, only delegates via Task tool. Build verification delegated to build-automation skill. Validation delegated to validation-agent. Each component has single responsibility (lines 33-63).

7. **Integration contracts documentation** - Comprehensive contract definitions in references/integration-contracts.md for all subagent interactions with input/output schemas, error handling, and examples. Makes system integration transparent.

8. **Graceful degradation** - When components unavailable (validation-agent, build-automation, Required Reading), skill continues with warnings rather than hard failures (error-handling.md lines 67-83). Resilient design.

---

## Prioritized Recommendations

### P0 (Critical - Fix Immediately)

1. **Reduce SKILL.md to 500-line target**
   - **What:** Move workflow loop (527-678), validation functions (804-942), express mode functions (694-800), creative brief sync (457-523), mode detection (238-306) to references/
   - **Why:** Currently loading ~8-10k tokens per invocation vs target ~4-5k. Wastes 50% of skill's context window budget on every load.
   - **Estimated impact:** Saves ~4-5k tokens per skill invocation. With typical workflow invoking skill 3-4 times (implement + continue + improve), saves ~15-20k tokens per plugin development session.

2. **Eliminate redundant enforcement reminders**
   - **What:** State delegation requirement once in "Delegation Protocol" section. Remove 5 duplicate statements throughout file. Consolidate anti-patterns into single section.
   - **Why:** Same messages repeated 6+ times across 1200 lines wastes ~800-1000 tokens. Maintenance burden keeping multiple sections in sync.
   - **Estimated impact:** Saves ~1k tokens per load. Reduces file length by ~200 lines toward 500-line target.

3. **Optimize context window with on-demand loading**
   - **What:** Move execution path-specific content to references: phase-aware-dispatch.md (loaded only for complexity ≥3), express-mode.md (loaded only in express mode), creative-brief-sync.md (loaded only before Stage 2)
   - **Why:** Simple plugins load phase dispatch logic they never use. Express mode details loaded in manual mode workflows. ~3-4k wasted tokens.
   - **Estimated impact:** Saves 2-3k tokens for simple plugins (60% of use cases). Loads only what's needed for current execution path.

### P1 (High Priority - Fix Soon)

1. **Fix YAML description trigger conditions**
   - **What:** Update description to: "Orchestrates JUCE plugin implementation through stages 2-5 (Foundation, DSP, GUI, Validation) using subagent delegation. Use when implementing plugins after planning completes, or when resuming with /continue command. Invoked by /implement command."
   - **Why:** Current description lacks WHEN to use this skill. Prevents effective auto-discovery.
   - **Estimated impact:** Improves skill discoverability. Ensures correct skill activation by /implement and /continue commands.

2. **Correct stage numbering inconsistency**
   - **What:** Update frontmatter to "stages 2-5" (matching CLAUDE.md renumbering) or use milestone names "Foundation through Validation"
   - **Why:** Frontmatter says "1-4" but content references "2-5" throughout. Confusing documentation.
   - **Estimated impact:** Eliminates confusion. Makes documentation consistent with system architecture.

3. **Simplify precondition checks**
   - **What:** Reduce lines 160-234 to: "Before Stage 2: Verify architecture.md, plan.md, creative-brief.md, parameter-spec.md exist. If missing, block with error. See references/precondition-checks.md for implementation."
   - **Why:** ~75 lines explaining file existence checks. Claude knows how to check if files exist.
   - **Estimated impact:** Saves ~500-600 tokens. Reduces SKILL.md by ~75 lines toward 500-line target.

4. **Consolidate delegation enforcement**
   - **What:** Single "Delegation Protocol" section stating: "Stages 2-5 MUST invoke subagents via Task tool (foundation-shell-agent, dsp-agent, gui-agent, validation-agent). This skill NEVER implements plugin code directly." Remove 5 duplicate statements.
   - **Why:** Same requirement stated 6 times wastes ~800 tokens. Single authoritative statement sufficient.
   - **Estimated impact:** Saves ~800 tokens. Improves readability by reducing repetition.

5. **Parallelize contract loading**
   - **What:** When loading contracts for subagent prompts, use parallel Read calls: `Read(architecture.md) || Read(plan.md) || Read(parameter-spec.md) || Read(creative-brief.md)`
   - **Why:** Sequential reads slower than parallel. Agent-skills best practices recommend parallelizing independent operations.
   - **Estimated impact:** Saves ~200ms per stage dispatch. 4 stages = ~800ms saved per plugin workflow. Better user experience.

### P2 (Nice to Have - Optimize When Possible)

1. **Add reference loading annotations**
   - **What:** Annotate references with WHEN they're needed: "See [dispatcher-pattern.md] (loaded when routing stages)" vs "See [error-handling.md] (loaded only when errors occur)"
   - **Why:** Helps Claude optimize context window by loading only needed references
   - **Estimated impact:** Prevents unnecessary reference loading. Marginal token savings but clearer documentation.

2. **Cache Required Reading in orchestrator context**
   - **What:** Read juce8-critical-patterns.md once at workflow start, store in variable, pass to all subagents from memory
   - **Why:** Same ~2k token file loaded 3-4 times per workflow (once per stage). Read once, use multiple times.
   - **Estimated impact:** Saves ~6-8k tokens per workflow by eliminating redundant file reads. Reduces I/O.

3. **Simplify XML structure to markdown**
   - **What:** Replace verbose XML tags with simpler markdown headings/bullets for non-complex sections
   - **Why:** XML useful for nested logic but overused. Markdown more concise for simple lists.
   - **Estimated impact:** Saves ~50-100 tokens. Marginal improvement but cleaner structure.

4. **Consolidate checkpoint protocol documentation**
   - **What:** Define 6-step checkpoint protocol ONCE at top of SKILL.md. Reference elsewhere: "Execute checkpoint protocol (see Checkpoint Protocol)"
   - **Why:** Same protocol explained in 3 locations. ~150 lines could be ~50 with single reference.
   - **Estimated impact:** Saves ~100 lines toward 500-line target. Easier to maintain single definition.

5. **Use consistent POV throughout**
   - **What:** Use third person for descriptions, second person only for direct instructions/checklists
   - **Why:** Mixing POV reduces clarity
   - **Estimated impact:** Improves readability. No token savings but better UX.

6. **Consolidate anti-patterns section**
   - **What:** Single "Anti-Patterns" section with all examples. Reference from other sections: "Avoid anti-patterns (see Anti-Patterns section)"
   - **Why:** Anti-patterns scattered across multiple locations (~100 lines redundancy)
   - **Estimated impact:** Saves ~50-75 lines. Single source of truth easier to maintain.

---

## Impact Assessment

**If all P0/P1 recommendations implemented:**

- **Context window savings:**
  - P0: ~4-5k tokens per skill load + ~2-3k conditional loading = **7-8k tokens per invocation**
  - P1: ~1.5-2k tokens (redundancy elimination + simplification)
  - **Total: ~9-10k token savings per skill invocation** (approximately 50% reduction)
  - Per workflow (3-4 skill loads): **27-40k total tokens saved**

- **Reliability improvements:**
  - Clear YAML triggers → better skill auto-discovery
  - Stage numbering consistency → eliminates confusion between docs
  - Parallel contract loading → reduces file I/O race conditions

- **Performance gains:**
  - Parallel file reads: ~800ms saved per workflow
  - On-demand reference loading: Only loads relevant execution paths
  - Cached Required Reading: Eliminates 3-4 redundant file reads

- **Maintainability:**
  - Single source of truth for delegation rules, checkpoint protocol, anti-patterns
  - Reduced file size (1197 → ~600 lines) easier to navigate and update
  - Clear separation between overview (SKILL.md) and implementation (references/)

- **Discoverability:**
  - Improved YAML description with trigger conditions enables reliable /implement and /continue routing
  - Better signposting to references helps Claude find relevant sections faster

---

## Next Steps

1. **Create refactoring branch** - `git checkout -b refactor/plugin-workflow-optimization`

2. **Extract detailed implementations to references/**
   - Create `references/workflow-loop.md` (move lines 527-678)
   - Create `references/validation-functions.md` (move lines 804-942)
   - Create `references/express-mode.md` (move lines 694-800)
   - Create `references/creative-brief-sync.md` (move lines 457-523)
   - Create `references/mode-detection.md` (move lines 238-306)

3. **Consolidate enforcement sections**
   - Create single "Delegation Protocol" section (lines 33-63 only)
   - Create single "Checkpoint Protocol" section (define 6 steps once)
   - Create single "Anti-Patterns" section (consolidate scattered examples)
   - Remove all duplicate statements

4. **Update YAML frontmatter**
   - Fix description trigger conditions
   - Correct stage numbering (1-4 → 2-5 or milestone names)

5. **Optimize contract loading**
   - Add parallel Read calls for contracts
   - Cache Required Reading at workflow start

6. **Verify skill still works after refactoring**
   - Test with simple plugin (complexity <3): Verify works without loading phase-aware-dispatch.md
   - Test with complex plugin (complexity ≥3): Verify loads phase-aware-dispatch.md correctly
   - Test express mode: Verify loads express-mode.md only when workflow_mode=express
   - Test manual mode: Verify doesn't load express-mode.md

7. **Measure improvements**
   - Line count: Target 500-600 lines (currently 1197)
   - Token count: Estimate ~4-5k per load (currently ~8-10k)
   - References loaded: Track which references actually get loaded per execution path

8. **Update related skills** - If pattern successful, apply to plugin-planning, plugin-improve, ui-mockup (other orchestrator skills)
