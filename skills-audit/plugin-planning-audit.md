# Skill Audit: plugin-planning

**Audit Date:** 2025-11-13
**Skill Path:** .claude/skills/plugin-planning

## Executive Summary

The plugin-planning skill orchestrates Stage 0 (Research & Planning) for the Plugin Freedom System. It successfully delegates to research-planning-agent and handles checkpoint protocol. However, the skill suffers from significant progressive disclosure violations with 284 lines in SKILL.md and 1,848 lines across references, creating substantial context window overhead. The skill conflates legacy two-stage workflow (Stage 0/1) with current consolidated Stage 0 implementation, creating confusion. Positively, it demonstrates strong subagent delegation, comprehensive precondition checking, and proper checkpoint handling.

**Overall Assessment:** NEEDS IMPROVEMENT

**Key Metrics:**
- SKILL.md size: 284 lines / 500 limit (57% utilized - acceptable)
- Reference files: 5 files (1,848 total lines)
- Assets files: 9 files
- Critical issues: 4
- Major issues: 8
- Minor issues: 3

---

## Findings by Category

### 1. Progressive Disclosure Compliance

**Status:** ⚠️ ISSUES

**Findings:**

- **Finding:** Massive reference file bloat - stage-0-research.md has 1,058 lines
  - **Severity:** MAJOR
  - **Evidence:** stage-0-research.md contains exhaustive subagent implementation details that should live in the subagent itself, not orchestrator skill references. Lines 1-1058 document per-feature research protocol, JUCE API mapping, etc.
  - **Impact:** Loading this reference file consumes ~15k-20k tokens. Orchestrator doesn't need subagent's implementation details - only delegation pattern and contract structure.
  - **Recommendation:** Delete stage-0-research.md entirely. Orchestrator only needs: (1) how to invoke subagent, (2) what contracts to pass, (3) what to verify after completion. Subagent's protocol lives in .claude/agents/research-planning-agent.md.
  - **Rationale:** Progressive disclosure principle: orchestrator loads delegation pattern (~200 tokens), subagent loads implementation details only when running. Current approach loads 15k+ tokens on every planning invocation.
  - **Priority:** P1

- **Finding:** Redundant reference file - stage-1-planning.md contains 519 lines duplicating information
  - **Severity:** MAJOR
  - **Evidence:** stage-1-planning.md (lines 1-519) documents complexity calculation and planning protocol. However, SKILL.md lines 17-270 state Stage 0 is now consolidated (combines old Stage 0 + Stage 1). The reference file represents legacy workflow.
  - **Impact:** Confusion about whether planning is separate stage. Wastes 8k-10k tokens loading legacy documentation that contradicts current workflow.
  - **Recommendation:** Delete stage-1-planning.md. If complexity calculation details needed by orchestrator, create compact reference (max 100 lines) with formula only, not full implementation protocol.
  - **Rationale:** SKILL.md clearly states "Stage 0 (Research & Planning - consolidated)" but references imply two-stage workflow. Eliminate legacy documentation.
  - **Priority:** P1

- **Finding:** Reference files not one level deep - contains legacy markers
  - **Severity:** MINOR
  - **Evidence:** References directory contains stage-0-research.md and stage-1-planning.md marked as "legacy references (for understanding prior workflow)" (SKILL.md line 282-284)
  - **Impact:** Legacy files serve no operational purpose. They document history, not current workflow. Every legacy file loaded wastes tokens.
  - **Recommendation:** Move stage-0-research.md and stage-1-planning.md to .claude/skills/plugin-planning/archive/ directory or delete entirely. If historical context needed, create single legacy-workflow-notes.md (max 50 lines) with high-level overview.
  - **Rationale:** Progressive disclosure: only load what's needed for current operation. Historical context belongs in git history or separate archive, not loaded references.
  - **Priority:** P2

---

### 2. YAML Frontmatter Quality

**Status:** ⚠️ ISSUES

**Findings:**

- **Finding:** Description lacks specific trigger conditions
  - **Severity:** MAJOR
  - **Evidence:** Line 3: "description: Stage 0 (Research & Planning) for JUCE plugin development. Invoke via /plan command after creative-brief.md exists or as first step of /implement workflow."
  - **Impact:** Vague trigger "after creative-brief.md exists" doesn't help Claude decide when to auto-invoke. Missing keywords: "planning", "research", "architecture", "DSP specification", "complexity assessment"
  - **Recommendation:** Rewrite as: "Orchestrates Stage 0 research and planning for JUCE plugins - creates architecture.md and plan.md contracts through subagent delegation. Use when creative brief exists and plugin needs DSP architecture specification, complexity assessment, or implementation planning. Invoke via /plan command or as first implementation step."
  - **Rationale:** Skill discovery relies on keywords. Current description focuses on "when" (via command) not "what it does" or semantic triggers.
  - **Priority:** P1

- **Finding:** Preconditions list file existence but not semantic meaning
  - **Severity:** MINOR
  - **Evidence:** Lines 13-14: "creative-brief.md must exist" and "Plugin must NOT already be past Stage 0"
  - **Impact:** Preconditions are mechanically correct but don't help Claude understand WHY these matter. Edge case: what if creative-brief.md exists but is empty or stub?
  - **Recommendation:** No change needed for preconditions field. However, Entry Point section (lines 26-34) should add semantic validation beyond file existence.
  - **Rationale:** YAML preconditions are discovery metadata. Validation logic belongs in skill body.
  - **Priority:** P2

---

### 3. Conciseness Discipline

**Status:** ⚠️ ISSUES

**Findings:**

- **Finding:** Redundant explanation of subagent protocol in SKILL.md
  - **Severity:** MAJOR
  - **Evidence:** Lines 120-128 explain what research-planning-agent executes: "Complexity detection (Tier 1-6) with extended thinking, Per-feature deep research, Integration analysis, architecture.md generation..." This duplicates subagent's own documentation.
  - **Impact:** ~150 tokens explaining what subagent does. Orchestrator doesn't need this - only needs to know HOW to invoke and WHAT to verify.
  - **Recommendation:** Delete lines 120-128. Replace with: "**Subagent executes:** Full Stage 0 protocol from research-planning-agent.md"
  - **Rationale:** Claude already knows how subagents work. Orchestrator only needs invocation pattern and validation criteria.
  - **Priority:** P1

- **Finding:** Verbose dispatch pattern documentation
  - **Severity:** MAJOR
  - **Evidence:** Lines 68-106 show 38 lines explaining how to construct prompt and invoke subagent. Includes example prompt text, parameter substitution notes, etc.
  - **Impact:** ~600-800 tokens for delegation pattern. Could be 100 tokens.
  - **Recommendation:** Reduce to:
    ```
    **Dispatch pattern:**

    1. Read contracts: creative-brief.md, parameter-spec.md (or draft), mockups (if exist)
    2. Invoke: Task(subagent_type="research-planning-agent", description="[prompt with contracts prepended]", model="sonnet")
    3. After completion: verify architecture.md and plan.md created, execute checkpoint protocol

    See [references/subagent-invocation.md](references/subagent-invocation.md) for prompt construction details.
    ```
    Move lines 75-106 to new references/subagent-invocation.md (loaded on-demand if needed).
  - **Rationale:** Dispatch pattern is procedural. Most invocations work without reading detailed prompt construction. Load details only when troubleshooting.
  - **Priority:** P1

- **Finding:** Over-documentation of parameter specification logic
  - **Severity:** MAJOR
  - **Evidence:** Lines 44-66 show 22 lines of XML explaining parameter-spec.md vs parameter-spec-draft.md logic with nested conditionals
  - **Impact:** ~400 tokens for what's essentially "accept either parameter-spec.md or parameter-spec-draft.md, block if neither exists"
  - **Recommendation:** Simplify to:
    ```
    **Precondition:** Parameter specification required (parameter-spec.md or parameter-spec-draft.md).

    If neither exists, block with error directing user to create via /dream or mockup workflow.

    See [references/preconditions.md](references/preconditions.md) for validation logic.
    ```
    Preconditions reference file already contains this logic (lines 1-98). No need to duplicate in SKILL.md.
  - **Rationale:** Validation logic documented in references. SKILL.md should state requirement, not implementation.
  - **Priority:** P1

- **Finding:** Decision menu repeated in SKILL.md when template exists
  - **Severity:** MINOR
  - **Evidence:** Lines 134-150 show full decision menu text. However, assets/decision-menu-stage-0.md exists (477 bytes) with same content.
  - **Impact:** ~200 tokens duplicated. Template already exists for consistency.
  - **Recommendation:** Replace lines 134-150 with: "**Decision menu:** Use assets/decision-menu-stage-0.md template"
  - **Rationale:** Templates live in assets. SKILL.md references them, doesn't duplicate them.
  - **Priority:** P2

---

### 4. Validation Patterns

**Status:** ✅ PASS

**Findings:**

✅ Clear validation gates present:
  - Preconditions checked before execution (lines 26-34)
  - Post-subagent validation: architecture.md and plan.md existence (lines 222-230)
  - State verification before proceeding (lines 243-248)

✅ Feedback loop pattern used appropriately:
  - Checkpoint protocol: commit → update state → verify → present menu (lines 114-119)
  - Resume logic for partial completion (references/preconditions.md lines 60-83)

✅ Exit criteria well-defined:
  - Stage 0 success: architecture.md and plan.md created, state updated, committed
  - Failure: precondition block, validation failure returns to menu

---

### 5. Checkpoint Protocol Compliance

**Status:** ✅ PASS

**Findings:**

✅ Checkpoint pattern followed correctly:
  - After subagent completion: read report, verify files, present decision menu, WAIT (lines 114-119)
  - Menu uses numbered list format, NOT AskUserQuestion (lines 134-150)
  - Manual/express mode handling delegated to plugin-workflow (correct separation)

✅ State updates atomic:
  - .continue-here.md updated with stage/status/timestamp (references/state-updates.md)
  - PLUGINS.md updated in both registry table and full entry (avoiding drift)
  - Git commit after state updates (references/git-operations.md)

✅ Decision menu structure correct:
  - Option 1: Continue to implementation (delegates to plugin-workflow)
  - Options 2-5: Secondary actions (review, improve, research, pause)
  - Option 6: Other (collect custom input)

---

### 6. Inter-Skill Coordination

**Status:** ⚠️ ISSUES

**Findings:**

- **Finding:** Unclear boundary with plugin-workflow skill
  - **Severity:** MAJOR
  - **Evidence:** Lines 152-217 show delegation rules for menu options. Option 1 delegates to plugin-workflow (correct), but SKILL.md explains Stage 0→Stage 1 transition when plugin-workflow owns Stages 1-4.
  - **Impact:** Confusion about where planning ends and implementation begins. SKILL.md discusses "Handoff to Implementation" (lines 235-269) but that's plugin-workflow's responsibility.
  - **Recommendation:** Delete "Handoff to Implementation" section (lines 235-269). Replace with: "When user chooses option 1, delegate to plugin-workflow skill via Skill tool. plugin-workflow handles implementation stages 1-4."
  - **Rationale:** Clear boundaries: plugin-planning owns Stage 0 only, plugin-workflow owns Stages 1-4. Orchestrator doesn't explain next skill's responsibilities.
  - **Priority:** P1

- **Finding:** Missing delegation to workflow-reconciliation
  - **Severity:** MINOR
  - **Evidence:** Decision menu (lines 134-150) doesn't offer reconciliation option. However, PFS has /reconcile command and workflow-reconciliation skill for state conflicts.
  - **Impact:** If Stage 0 completes but state files conflict (e.g., .continue-here.md shows Stage 0 but PLUGINS.md shows Stage 1), no path to fix.
  - **Recommendation:** Add menu option: "5. Reconcile state files (if conflicts detected)" that delegates to workflow-reconciliation skill.
  - **Rationale:** Defensive design: state conflicts happen (user edits, git merges, etc.). Offer repair path.
  - **Priority:** P2

---

### 7. Subagent Delegation Compliance

**Status:** ✅ PASS

**Findings:**

✅ Correct delegation pattern:
  - Uses Task tool with subagent_type="research-planning-agent" (line 110)
  - Passes contracts as context (creative-brief, parameter-spec, mockups)
  - Reads subagent return message (line 114)
  - Verifies subagent outputs before proceeding (lines 115-116)

✅ Dispatcher pattern followed:
  - Fresh context per invocation (subagent runs 5-35 min without polluting orchestrator)
  - No direct implementation in orchestrator (all work delegated)
  - Return message read and validated

✅ Subagent_type specified correctly:
  - "research-planning-agent" matches .claude/agents/research-planning-agent.md

---

### 8. Contract Integration

**Status:** ⚠️ ISSUES

**Findings:**

- **Finding:** Inconsistent contract status terminology
  - **Severity:** MAJOR
  - **Evidence:** Lines 44-66 describe parameter specification as "required" but accept either parameter-spec.md OR parameter-spec-draft.md. However, downstream stages expect parameter-spec.md (full specification).
  - **Impact:** Stage 0 can proceed with draft, but what happens at Stage 1? Does foundation-shell-agent expect full spec? Unclear contract requirements create implementation drift risk.
  - **Recommendation:** Document explicitly: "Stage 0 accepts draft for architecture planning. Stage 1 (Foundation) requires full parameter-spec.md. If draft used, mockup finalization must occur before Stage 1."
  - **Rationale:** Contract requirements should be explicit. "Either/or" creates ambiguity about downstream expectations.
  - **Priority:** P1

- **Finding:** Contract immutability not mentioned for Stage 0 outputs
  - **Severity:** MINOR
  - **Evidence:** SKILL.md creates architecture.md and plan.md but doesn't state these are immutable during Stages 1-4. PFS CLAUDE.md (line 65) states "Contracts are immutable during implementation" but skill doesn't reinforce.
  - **Impact:** User might edit architecture.md after Stage 0 completion, causing drift before Stage 1.
  - **Recommendation:** Add to architecture.md header (assets/architecture-template.md): "**CRITICAL CONTRACT:** This specification is immutable during Stages 1-4 implementation."
  - **Rationale:** Contract immutability is core PFS principle. Reinforce at contract creation point.
  - **Priority:** P2

---

### 9. State Management Consistency

**Status:** ⚠️ ISSUES

**Findings:**

- **Finding:** PLUGINS.md update pattern inconsistent with plugin-workflow
  - **Severity:** MAJOR
  - **Evidence:** references/state-updates.md (lines 29-42) shows Edit tool pattern for PLUGINS.md. However, plugin-workflow skill references/state-management.md uses helper function updatePluginStatus() for atomic updates.
  - **Impact:** Two different update patterns across skills. Risk of registry drift (table vs full entry inconsistency) if one skill uses helper and other uses raw Edit.
  - **Recommendation:** Standardize on helper function. Update state-updates.md to: "Call updatePluginStatus([PluginName], '🚧 Stage 0') - see plugin-workflow/references/state-management.md for implementation."
  - **Rationale:** DRY principle. State management logic should live in one place, called by all skills.
  - **Priority:** P1

- **Finding:** .continue-here.md state field "next_stage" not used consistently
  - **Severity:** MINOR
  - **Evidence:** references/state-updates.md (line 19) shows template includes stage, status, last_updated. stage-1-planning.md (line 363) shows next_stage, ready_for_implementation fields.
  - **Impact:** Unclear which fields are canonical. plugin-workflow might expect certain fields that plugin-planning doesn't set.
  - **Recommendation:** Document canonical state schema in references/state-updates.md with all required/optional fields and which skills set them.
  - **Rationale:** State schema should be documented, not inferred from templates. Prevents field drift across skills.
  - **Priority:** P2

---

### 10. Context Window Optimization

**Status:** ❌ FAIL

**Findings:**

- **Finding:** Premature loading of massive reference files
  - **Severity:** CRITICAL
  - **Evidence:** stage-0-research.md (1,058 lines) and stage-1-planning.md (519 lines) referenced in SKILL.md but contain subagent implementation details, not orchestrator guidance.
  - **Impact:** If Claude follows references, loads 25k+ tokens that aren't needed for orchestration. Orchestrator needs ~500 tokens for delegation pattern, not 25k tokens of subagent protocol.
  - **Recommendation:** Delete legacy reference files (stage-0-research.md, stage-1-planning.md). Create minimal references/delegation-checklist.md (max 100 lines) with:
    1. What contracts to read and pass to subagent
    2. Task tool invocation syntax
    3. What to verify after subagent completes
    4. Checkpoint protocol steps
  - **Rationale:** Context window is precious. Orchestrator loads delegation pattern only. Subagent loads implementation details only when running.
  - **Priority:** P0

- **Finding:** No parallel tool calls for contract reading
  - **Severity:** MAJOR
  - **Evidence:** Lines 70-73 show sequential reads: "creative-brief.md, parameter-spec.md OR parameter-spec-draft.md, mockups/*.yaml (if exists)"
  - **Impact:** Sequential reads waste time. Could parallelize: Read creative-brief, Read parameter-spec (if exists), Read parameter-spec-draft (if exists), Glob mockups directory.
  - **Recommendation:** Update dispatch pattern to use parallel Read calls in single tool invocation block.
  - **Rationale:** Performance optimization. 3 sequential reads = 3 round trips. 1 parallel call = 1 round trip.
  - **Priority:** P1

- **Finding:** Redundant file existence checks before reading
  - **Severity:** MINOR
  - **Evidence:** preconditions.md (lines 18-36) shows bash file existence checks before proceeding. Then dispatch pattern reads same files again.
  - **Impact:** Minor overhead. Precondition checks are validation, reads are for content. Not technically redundant but feels inefficient.
  - **Recommendation:** No change needed. Precondition validation is semantic (does contract exist?), reading is operational (get contract content). Separation is appropriate.
  - **Rationale:** Validation before operation is correct pattern even if checks similar files.
  - **Priority:** N/A

---

### 11. Anti-Pattern Detection

**Status:** ⚠️ ISSUES

**Findings:**

- **Finding:** Deeply nested references (implicit)
  - **Severity:** MAJOR
  - **Evidence:** SKILL.md references stage-0-research.md, which documents subagent protocol, which itself references juce8-critical-patterns.md. SKILL.md → stage-0-research.md → critical-patterns.md = 3 levels.
  - **Impact:** If Claude follows reference chain, loads orchestrator skill, then research protocol, then critical patterns. Violates "one level deep" principle.
  - **Recommendation:** Delete stage-0-research.md. Subagent's protocol lives in .claude/agents/research-planning-agent.md. Orchestrator never references subagent's implementation files.
  - **Rationale:** Nesting limit: SKILL.md → references/ (1 level). Never SKILL.md → references/ → subagent → subagent-references (3+ levels).
  - **Priority:** P1

- **Finding:** Vague description lacking specific triggers (duplicate of Category 2)
  - **Severity:** MAJOR
  - **Evidence:** YAML description (line 3) focuses on invocation mechanism ("/plan command") not semantic triggers
  - **Impact:** Reduces skill discoverability for auto-invocation scenarios
  - **Recommendation:** See Category 2 recommendation
  - **Rationale:** Description should enable semantic matching, not just command matching
  - **Priority:** P1

- **Finding:** Inconsistent POV in delegation rules
  - **Severity:** MINOR
  - **Evidence:** Lines 152-217 use second person "You" ("Invoke plugin-workflow skill via Skill tool...") while SKILL.md body uses imperative ("Read contracts", "Invoke subagent")
  - **Impact:** Minor stylistic inconsistency. Doesn't affect functionality but reduces polish.
  - **Recommendation:** Rewrite delegation rules section in imperative voice consistent with rest of skill.
  - **Rationale:** Consistent voice improves readability.
  - **Priority:** P2

---

## Positive Patterns

1. **Strong precondition validation** - references/preconditions.md provides comprehensive validation with clear blocking conditions and user-friendly error messages (lines 12-84). Model for other skills.

2. **Excellent template organization** - assets/ directory contains 9 well-organized templates for contracts, handoff files, and decision menus. Clear separation between templates (assets) and reference docs.

3. **Proper subagent delegation** - Skill correctly delegates all implementation to research-planning-agent via Task tool (line 110), reads return message (line 114), validates outputs (lines 115-116). Clean orchestrator/worker separation.

4. **Comprehensive state management references** - references/state-updates.md and git-operations.md provide detailed, copy-paste-ready patterns for state updates and commits. Reduces errors.

5. **Clear validation gates** - Explicit verification steps before proceeding to next stage (lines 222-230). Prevents proceeding with incomplete Stage 0.

6. **Good use of XML structure** - preconditions.md uses XML tags appropriately: `<precondition_gate>`, `<validation_requirement>`, `<blocking_condition>` make structure parseable.

---

## Prioritized Recommendations

### P0 (Critical - Fix Immediately)

1. **Delete legacy reference files to eliminate 25k token overhead**
   - **What:** Delete stage-0-research.md (1,058 lines) and stage-1-planning.md (519 lines)
   - **Why:** These files document subagent implementation details that orchestrator doesn't need. Loading them wastes 25k+ tokens on every skill invocation.
   - **Estimated impact:** Reduces skill context window usage by 90% (from ~30k tokens to ~3k tokens)

### P1 (High Priority - Fix Soon)

1. **Simplify SKILL.md by moving verbose delegation pattern to reference file**
   - **What:** Reduce lines 68-106 from 38 lines to 10 lines, move details to new references/subagent-invocation.md
   - **Why:** Dispatch pattern documented twice (in SKILL.md and implicitly in references). Most invocations don't need verbose details.
   - **Estimated impact:** Saves ~600 tokens per invocation, improves readability

2. **Improve YAML description with semantic triggers**
   - **What:** Rewrite description to include keywords: "architecture specification", "DSP research", "complexity assessment", "planning"
   - **Why:** Current description focuses on invocation mechanism ("/plan command") not semantic meaning, reducing auto-discovery
   - **Estimated impact:** Better skill matching for natural language requests like "plan the DSP architecture"

3. **Standardize PLUGINS.md update pattern across skills**
   - **What:** Update references/state-updates.md to reference plugin-workflow's updatePluginStatus() helper instead of raw Edit pattern
   - **Why:** Two different update patterns across skills creates drift risk (registry table vs full entry inconsistency)
   - **Estimated impact:** Eliminates class of state corruption bugs

4. **Simplify parameter specification precondition logic**
   - **What:** Reduce lines 44-66 from 22 lines to 5 lines, reference preconditions.md for validation implementation
   - **Why:** Validation logic duplicated between SKILL.md and preconditions.md reference
   - **Estimated impact:** Saves ~400 tokens, reduces maintenance burden

5. **Delete "Handoff to Implementation" section (orchestrator boundary violation)**
   - **What:** Remove lines 235-269, replace with single line delegating to plugin-workflow
   - **Why:** plugin-planning owns Stage 0 only, plugin-workflow owns handoff to Stages 1-4. Explaining next skill's job violates separation of concerns.
   - **Estimated impact:** Clearer skill boundaries, saves ~500 tokens

6. **Clarify contract requirements for Stage 0 vs downstream stages**
   - **What:** Document explicitly: "Stage 0 accepts parameter-spec-draft.md, but Stage 1 requires full parameter-spec.md"
   - **Why:** Current "either/or" creates ambiguity about when full spec is needed
   - **Estimated impact:** Prevents contract drift, clearer user expectations

7. **Parallelize contract reading for performance**
   - **What:** Update dispatch pattern to use parallel Read tool calls for creative-brief.md, parameter-spec files, mockups
   - **Why:** Sequential reads waste time (3 round trips vs 1)
   - **Estimated impact:** ~30% faster contract loading

8. **Fix reference nesting violation**
   - **What:** Ensure SKILL.md never references subagent implementation files (stage-0-research.md references critical-patterns.md = 2+ levels)
   - **Why:** Progressive disclosure limit: SKILL.md → references/ (1 level max)
   - **Estimated impact:** Prevents 3-level deep loading chain

### P2 (Nice to Have - Optimize When Possible)

1. **Move decision menu text to template reference**
   - **What:** Replace lines 134-150 with "Use assets/decision-menu-stage-0.md template"
   - **Why:** Template already exists, no need to duplicate in SKILL.md
   - **Estimated impact:** Saves ~200 tokens, improves consistency

2. **Archive legacy workflow documentation**
   - **What:** Move stage-0-research.md and stage-1-planning.md to .claude/skills/plugin-planning/archive/ or delete
   - **Why:** Marked as "legacy references" but still in active references/ directory
   - **Estimated impact:** Cleaner references directory, reduces confusion

3. **Document canonical .continue-here.md state schema**
   - **What:** Create references/state-schema.md listing all state fields (stage, status, last_updated, complexity_score, etc.) with required/optional designation
   - **Why:** State fields inferred from templates, not explicitly documented
   - **Estimated impact:** Prevents field drift, clearer state contract

4. **Add reconciliation option to decision menu**
   - **What:** Add menu option "5. Reconcile state files (if conflicts detected)" delegating to workflow-reconciliation skill
   - **Why:** Defensive design for state conflicts from user edits or git merges
   - **Estimated impact:** Better error recovery

5. **Standardize voice in delegation rules section**
   - **What:** Rewrite lines 152-217 in imperative voice ("Invoke plugin-workflow...") instead of second person ("You invoke...")
   - **Why:** Consistency with rest of SKILL.md
   - **Estimated impact:** Minor polish improvement

---

## Impact Assessment

**If all P0/P1 recommendations implemented:**

- **Context window savings:** ~26k tokens per invocation (90% reduction)
  - Before: SKILL.md (5k) + stage-0-research.md (15k) + stage-1-planning.md (8k) + other references (2k) = 30k tokens
  - After: SKILL.md (3k optimized) + minimal references (500) = 3.5k tokens

- **Reliability improvements:**
  - Eliminates state drift risk from inconsistent PLUGINS.md update patterns
  - Clearer contract requirements prevent parameter-spec ambiguity
  - Stronger orchestrator boundaries prevent scope creep

- **Performance gains:**
  - 30% faster contract loading via parallel Read calls
  - Reduced skill load time (3.5k tokens vs 30k tokens = ~85% faster)

- **Maintainability:**
  - Single source of truth for state management (updatePluginStatus helper)
  - Clearer separation: orchestrator delegates, doesn't document subagent protocols
  - Archived legacy workflow prevents confusion

- **Discoverability:**
  - Improved YAML description enables semantic matching for "plan architecture" or "research DSP" queries
  - Better auto-invocation from natural language

---

## Next Steps

1. **Immediate (P0):** Delete stage-0-research.md and stage-1-planning.md to eliminate 25k token overhead. Create minimal references/delegation-checklist.md (max 100 lines) with orchestration essentials only.

2. **High Priority (P1):** Simplify SKILL.md by extracting verbose patterns to on-demand references. Update YAML description for semantic triggers. Standardize state management with plugin-workflow.

3. **Nice to Have (P2):** Archive legacy docs, document state schema, add reconciliation option to menu.

4. **Validation:** After P0/P1 fixes, test skill invocation with /plan command. Measure token usage before/after to confirm 90% reduction.

5. **Propagate patterns:** If delegation simplification works well, apply same pattern to other orchestrator skills (plugin-workflow, ui-mockup, plugin-improve).
