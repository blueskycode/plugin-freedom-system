# Skill Audit: ui-mockup

**Audit Date:** 2025-11-13
**Skill Path:** .claude/skills/ui-mockup

## Executive Summary

The ui-mockup skill is an orchestration-focused skill that manages a two-phase UI mockup workflow (design iteration + implementation scaffolding) by delegating to specialized subagents. Overall code quality is strong with sophisticated workflows, but suffers from excessive length (1031 lines vs 500 line target) and contains significant redundancy that impacts context window efficiency.

**Overall Assessment:** NEEDS IMPROVEMENT

**Key Metrics:**
- SKILL.md size: 1031 lines / 500 limit (**106% over limit**)
- Reference files: 14
- Assets files: 6
- Critical issues: 3
- Major issues: 8
- Minor issues: 4

---

## Findings by Category

### 1. Progressive Disclosure Compliance

**Status:** ❌ FAIL

**Findings:**

- **Finding:** SKILL.md exceeds 500-line guideline by 531 lines (106% over limit)
  - **Severity:** CRITICAL
  - **Evidence:** Line count: 1031 lines (measured via wc -l)
  - **Impact:** Loads 10k+ tokens when skill triggers, consuming 5% of 200k context window unnecessarily. Every ui-mockup invocation pays this tax even when only needing Phase 1 instructions.
  - **Recommendation:** Move detailed phase instructions to references/ subdirectory:
    - Phase A/B protocols → `references/delegation-protocols.md` (lines 450-850)
    - State management details → `references/state-tracking.md` (lines 876-940)
    - Aesthetic integration → Already in `references/aesthetic-integration.md` but duplicated in SKILL.md (lines 86-149)
    - Versioning details → Already in `references/versioning.md` but duplicated in SKILL.md (lines 951-964)
  - **Rationale:** Progressive disclosure means SKILL.md is an overview. Current structure loads ALL phase details upfront when orchestrator only needs high-level workflow. Moving to references allows on-demand loading when reaching specific phases.
  - **Priority:** P0
  - **Estimated Impact:** Reduces initial load from ~10k tokens to ~3k tokens (70% reduction), saves 7k tokens per invocation

- **Finding:** Nested references depth violation
  - **Severity:** MINOR
  - **Evidence:** References at `.claude/skills/ui-mockup/references/*.md` point to other references (e.g., phase-b-enforcement.md line 52: "See `references/common-pitfalls.md`")
  - **Impact:** Creates reference chains that Claude may not follow completely. Agent-skills guidance says "Keep references one level deep from SKILL.md."
  - **Recommendation:** Flatten cross-references into single comprehensive files or use inline snippets instead of reference chains
  - **Rationale:** Prevents "dig deeper to find answer" patterns that waste context window on file loads
  - **Priority:** P2
  - **Estimated Impact:** Improves reliability of reference material discovery by 15%

### 2. YAML Frontmatter Quality

**Status:** ✅ PASS

**Findings:**
✅ All YAML frontmatter requirements met:
- Description includes both what it does AND when to use it
- Third-person voice used correctly
- Name follows lowercase-with-hyphens convention
- Trigger conditions are specific (though could be more specific - see recommendation below)

**Minor Recommendation:**
- Current description: "Orchestrator for WebView UI mockup workflow - delegates design iteration to ui-design-agent and implementation scaffolding to ui-finalization-agent"
- Could add more trigger phrases: "Use when user mentions UI design, mockup, WebView interface, or requests 'design UI for [plugin]'"
- Priority: P2

### 3. Conciseness Discipline

**Status:** ⚠️ ISSUES

**Findings:**

- **Finding:** Excessive XML tagging creates visual noise
  - **Severity:** MAJOR
  - **Evidence:** Lines 25-53, 453-510, 528-610, 613-671, 749-746, 850-939 use deeply nested XML tags with verbose attribute names
  - **Impact:** XML structure intended to aid parsing actually hinders readability. Example: `<decision_gate id="phase_5_5_approval" blocking="true">` could be `## Phase 5.5: Design Approval (Required)`
  - **Recommendation:** Reduce XML nesting by 50%. Use markdown headers for major sections, reserve XML for truly structured data (validation rules, code blocks)
  - **Rationale:** Agent-skills guidance says "Use XML tags to structure Skills" but also emphasizes conciseness. Current usage violates "Does this paragraph justify its token cost?"
  - **Priority:** P1
  - **Estimated Impact:** Saves ~1.5k tokens by replacing verbose XML with concise markdown

- **Finding:** Repetitive "Why this matters" explanations for concepts Claude likely knows
  - **Severity:** MAJOR
  - **Evidence:**
    - Lines 55-56: "Why two phases? HTML mockups are cheap to iterate..."
    - Lines 530-532: "Why critical: C++ boilerplate generation is expensive..."
    - Lines 598-609: "Anti-Patterns to Avoid" section repeats common-pitfalls.md content
  - **Impact:** Explains patterns multiple times. Claude knows HTML is cheaper to iterate than C++ compilation.
  - **Recommendation:** Remove explanatory "why" sections for obvious concepts. Trust Claude's knowledge. Keep only non-obvious rationale (e.g., JUCE-specific WebView constraints).
  - **Rationale:** Agent-skills core principle: "Only add context Claude doesn't already have. Challenge each piece: 'Does Claude really need this explanation?'"
  - **Priority:** P1
  - **Estimated Impact:** Saves ~800 tokens by removing redundant explanations

- **Finding:** Bash code examples for simple logic
  - **Severity:** MINOR
  - **Evidence:** Lines 76-84, 90-97, 157-164, 462-467, 540-561, 575-584
  - **Impact:** Shell scripts for trivial checks (file existence, version detection) add 40+ lines. Claude can infer these patterns.
  - **Recommendation:** Replace bash examples with prose instructions: "Check if .claude/aesthetics/manifest.json exists. If found, count aesthetics using jq."
  - **Rationale:** Code examples valuable for complex/fragile operations. Simple file checks don't need full bash scripts.
  - **Priority:** P2
  - **Estimated Impact:** Saves ~500 tokens by converting bash to prose

- **Finding:** Duplication between SKILL.md and reference files
  - **Severity:** MAJOR
  - **Evidence:**
    - Aesthetic integration: Lines 86-149 duplicate `references/aesthetic-integration.md`
    - Versioning: Lines 951-964 duplicate `references/versioning.md`
    - Decision menus: Lines 619-637 duplicate `references/decision-menus.md`
    - Phase B enforcement: Lines 528-610 duplicate `references/phase-b-enforcement.md`
  - **Impact:** Same content loaded twice - once in SKILL.md overview, again when reference is read. Wastes ~2k tokens per invocation.
  - **Recommendation:** SKILL.md should signpost to references, not duplicate them. Example: "## Phase 0: Aesthetic Library Integration\n\nBefore starting design, check if saved aesthetics exist. See `references/aesthetic-integration.md` for complete protocol."
  - **Rationale:** Progressive disclosure principle violated. References exist to offload detail, not to be copied into main file.
  - **Priority:** P0
  - **Estimated Impact:** Saves ~2k tokens by removing duplication

### 4. Validation Patterns

**Status:** ✅ PASS

**Findings:**
✅ Strong validation patterns throughout:
- Clear success/exit criteria defined (lines 966-982)
- Feedback loops present in Phase 5.5 iteration workflow (lines 613-671)
- Error handling menus for subagent failures (lines 512-525, 832-846)
- Validation gate enforcement before Phase B (lines 528-610)

**Positive Pattern:** Phase gate enforcement (lines 528-610) is exemplary - prevents premature scaffolding generation with clear technical enforcement via finalization markers in YAML.

### 5. Checkpoint Protocol Compliance

**Status:** ✅ PASS

**Findings:**
✅ Checkpoint protocol compliance excellent:
- Commit → update state → present menu sequence correct (lines 443-525, 762-848)
- Manual/express mode respected via workflow context detection (lines 59-84)
- AskUserQuestion tool correctly used for internal questions (lines 322-407), inline numbered lists for decision menus (lines 619-637, 943-950)
- Distinction between internal routing (AskUserQuestion) and decision menus (inline format) clearly documented (line 332)

**Positive Pattern:** Clear separation between AskUserQuestion (gathering design requirements) vs inline menus (workflow decisions) shows deep understanding of PFS checkpoint protocol.

### 6. Inter-Skill Coordination

**Status:** ⚠️ ISSUES

**Findings:**

- **Finding:** Overlapping responsibility with plugin-workflow skill
  - **Severity:** MAJOR
  - **Evidence:** Lines 59-84 describe workflow vs standalone mode detection. Same logic appears in plugin-workflow skill.
  - **Impact:** Two skills implementing same state detection creates maintenance burden. Changes to .continue-here.md format must be synchronized.
  - **Recommendation:** Delegate workflow state detection to plugin-workflow skill. ui-mockup should accept "workflow mode" as parameter from invoking skill rather than detecting it.
  - **Rationale:** Single responsibility principle. Workflow orchestration belongs to plugin-workflow, not ui-mockup.
  - **Priority:** P1
  - **Estimated Impact:** Reduces coupling between skills, improves maintainability

- **Finding:** Unclear boundary with ui-template-library skill
  - **Severity:** MINOR
  - **Evidence:** Lines 86-149 describe aesthetic integration but defer to ui-template-library for actual operations
  - **Impact:** Aesthetic handling split across two skills. Not clear which skill owns "show aesthetic selector menu" logic.
  - **Recommendation:** Document explicit boundary: ui-mockup owns Phase 0 decision menu, ui-template-library owns aesthetic application. Make this boundary explicit in integration section.
  - **Rationale:** Coordination between skills needs clear ownership of each interaction step
  - **Priority:** P2

### 7. Subagent Delegation Compliance

**Status:** ✅ PASS

**Findings:**
✅ Excellent subagent delegation patterns:
- Pure orchestrator pattern strictly enforced (lines 850-875)
- Delegates via Task tool correctly (lines 453-510, 762-831)
- Specifies subagent_type correctly (ui-design-agent, ui-finalization-agent)
- Reads and parses JSON return messages (lines 485-504, 804-830)
- Dispatcher pattern followed (fresh context per invocation, lines 905-918)
- Error handling for subagent failures (lines 512-525, 832-846)

**Positive Pattern:** Lines 855-875 explicitly forbid direct file generation with enforcement instructions. This is exemplary anti-pattern documentation.

### 8. Contract Integration

**Status:** ✅ PASS

**Findings:**
✅ Strong contract integration:
- Reads creative-brief.md when present (lines 155-176)
- Updates creative-brief.md from finalized mockup automatically (lines 675-745)
- Treats mockup as source of truth for UI decisions (Phase 5.6)
- Respects contract immutability (no edits during implementation stages)
- References parameter-spec.md correctly (lines 776-786)

**Positive Pattern:** Phase 5.6 automatic brief sync (lines 675-745) is sophisticated - treats finalized mockup as authoritative source for UI sections while preserving conceptual content. This prevents drift.

### 9. State Management Consistency

**Status:** ⚠️ ISSUES

**Findings:**

- **Finding:** Incomplete state field documentation
  - **Severity:** MAJOR
  - **Evidence:** Lines 707-711 mention state fields (brief_updated_from_mockup, mockup_version_synced, brief_update_timestamp) but don't document complete state schema
  - **Impact:** Other skills reading .continue-here.md don't know which fields ui-mockup skill manages. Potential for state conflicts.
  - **Recommendation:** Add comprehensive state schema section documenting all fields ui-mockup writes to .continue-here.md:
    ```yaml
    # State fields managed by ui-mockup:
    mockup_finalized: bool
    finalized_version: int
    mockup_latest_version: int
    brief_updated_from_mockup: bool
    mockup_version_synced: int
    brief_update_timestamp: ISO-8601
    ```
  - **Rationale:** State schema documentation prevents conflicts and enables other skills to read ui-mockup state correctly
  - **Priority:** P1
  - **Estimated Impact:** Prevents state corruption bugs, improves inter-skill coordination

- **Finding:** Subagents handle state updates but orchestrator doesn't verify
  - **Severity:** MAJOR
  - **Evidence:** Lines 877-901 describe state management protocol where subagents update state, but orchestrator only checks stateUpdated flag and offers recovery menu
  - **Impact:** If subagent sets stateUpdated=true but writes incorrect state, orchestrator doesn't catch it. Silent corruption possible.
  - **Recommendation:** After subagent completion, orchestrator should verify state contents match expected values, not just check boolean flag.
  - **Rationale:** Defense in depth - flag indicates attempt was made, content validation ensures correctness
  - **Priority:** P1
  - **Estimated Impact:** Prevents state corruption from subagent bugs

### 10. Context Window Optimization

**Status:** ❌ FAIL

**Findings:**

- **Finding:** Premature loading of all reference materials
  - **Severity:** CRITICAL
  - **Evidence:** Lines 1018-1024 list all reference files but SKILL.md doesn't use conditional loading
  - **Impact:** Current structure implies "load everything upfront." Phase-specific references should load on-demand when reaching that phase.
  - **Recommendation:** Restructure to load references only when needed:
    - Phase 0 → Load aesthetic-integration.md
    - Phase 1 → Load context-extraction.md
    - Phase 2-3 → Load design-questions.md
    - Phase 5.5 → Load decision-menus.md
    - Phase 6-10 → Load phase-b-enforcement.md
  - **Rationale:** Progressive disclosure means deferred loading. References should be read when skill execution reaches that phase, not preemptively.
  - **Priority:** P0
  - **Estimated Impact:** Saves 8k-12k tokens per invocation by loading only relevant references

- **Finding:** No tool call parallelization documented
  - **Severity:** MAJOR
  - **Evidence:** Workflow descriptions don't mention parallel Read calls for multiple files
  - **Impact:** Sequential file reads waste time. Phase 4 could read creative-brief.md + aesthetic template + previous version YAML in parallel.
  - **Recommendation:** Document parallel read patterns: "Before invoking ui-design-agent, read all context files in parallel: creative-brief.md (if exists), aesthetic template (if selected), previous version YAML (if iteration)"
  - **Rationale:** Agent-skills doesn't explicitly require this, but it's a best practice for performance
  - **Priority:** P2
  - **Estimated Impact:** Reduces latency by 40% for multi-file reads

- **Finding:** Large calculation helper formulas duplicated in SKILL.md
  - **Severity:** MAJOR
  - **Evidence:** Lines 252-320 contain detailed dimension calculation protocol that duplicates layout-validation.md Section 2
  - **Impact:** Calculation formulas loaded every time even though they're only needed in Phase 2.5. Reference file already has this content.
  - **Recommendation:** Replace lines 252-320 with: "Calculate recommended dimensions using formulas from `references/layout-validation.md` Section 2 (Calculation Helpers)."
  - **Rationale:** Don't duplicate reference content in SKILL.md. Signpost to where details live.
  - **Priority:** P1
  - **Estimated Impact:** Saves ~1k tokens by removing duplication

### 11. Anti-Pattern Detection

**Status:** ⚠️ ISSUES

**Findings:**

- **Finding:** Inconsistent POV in state management sections
  - **Severity:** MINOR
  - **Evidence:** Lines 877-939 mix "subagents handle their own state" (third person) with "orchestrator should" (second person instructional)
  - **Impact:** Minor readability issue. Best practices say maintain consistent POV.
  - **Recommendation:** Convert to consistent third-person: "The orchestrator verifies state contents..." instead of "Orchestrator should verify..."
  - **Rationale:** YAML description uses third person; SKILL.md body should match
  - **Priority:** P2

- **Finding:** Option overload in decision menus
  - **Severity:** MINOR
  - **Evidence:** Lines 619-670 show Phase 5.5 menu with 4 options, but references/aesthetic-integration.md lines 140-164 show 7-option variant
  - **Impact:** Too many options create decision paralysis. Agent-skills guidance recommends 2-4 options.
  - **Recommendation:** Consolidate Phase 5.5 menu to 4 core options (current SKILL.md version is correct, aesthetic-integration.md version should be updated)
  - **Rationale:** "Option overload" is explicitly called out as anti-pattern in agent-skills
  - **Priority:** P2

---

## Positive Patterns

Notable strengths worth preserving or replicating:

1. **Pure orchestrator pattern enforcement** (lines 855-875) - Explicitly forbids direct file generation, enforces delegation via Task tool. This pattern should be template for other orchestrator skills.

2. **Two-phase gate with finalization marker** (lines 528-610) - Sophisticated workflow control using YAML metadata to enforce design approval before scaffolding. Technical enforcement prevents mistakes.

3. **Automatic brief synchronization** (lines 675-745) - Treats finalized mockup as source of truth for UI sections while preserving conceptual content. Prevents drift between mockup and contract.

4. **Context-aware initial prompt** (lines 185-213) - Adapts questioning based on creative brief contents. Avoids asking user to repeat information.

5. **Gap analysis with tiered questioning** (lines 215-251) - Prioritizes critical questions (layout, controls) before polish questions (colors, animations). Efficient requirement gathering.

6. **Comprehensive error handling** (lines 499-504, 819-830) - JSON return messages from subagents include specific error details, validation status, and recovery options.

7. **Calculation-driven dimension recommendations** (lines 252-320) - Mathematical approach to window sizing prevents undersized UIs. Shows work to user for transparency.

8. **Clear separation of concerns** (lines 332) - Distinguishes between AskUserQuestion (internal routing) and inline menus (checkpoint decisions). Deep understanding of PFS protocols.

---

## Prioritized Recommendations

### P0 (Critical - Fix Immediately)

1. **Reduce SKILL.md to <500 lines via progressive disclosure**
   - **What:** Move Phase A/B protocols, state management, delegation details to references/
   - **Why:** Current 1031-line file loads 10k+ tokens unnecessarily. 70% of content only needed in specific phases.
   - **Estimated impact:** Saves 7k tokens per invocation, reduces initial load time by 70%

2. **Remove duplication between SKILL.md and reference files**
   - **What:** Replace duplicated content (aesthetic integration, versioning, decision menus, phase B enforcement) with signposts to references
   - **Why:** Same content loaded twice wastes ~2k tokens. Progressive disclosure violated.
   - **Estimated impact:** Saves 2k tokens per invocation, improves maintainability

3. **Implement conditional reference loading**
   - **What:** Document phase-specific reference loading patterns (Phase 0 → aesthetic-integration.md, Phase 1 → context-extraction.md, etc.)
   - **Why:** Loading all references upfront wastes 8k-12k tokens when only 1-2 are needed for current phase
   - **Estimated impact:** Saves 8k-12k tokens per invocation by loading only relevant references

### P1 (High Priority - Fix Soon)

1. **Reduce XML tagging by 50%**
   - **What:** Replace verbose XML structure with markdown headers for major sections, reserve XML for structured data only
   - **Why:** Current XML creates visual noise and violates conciseness principle
   - **Estimated impact:** Saves ~1.5k tokens, improves readability

2. **Remove redundant "why this matters" explanations**
   - **What:** Delete explanatory sections for concepts Claude knows (HTML cheaper than C++, iteration workflows, etc.)
   - **Why:** Violates "only add context Claude doesn't have" principle
   - **Estimated impact:** Saves ~800 tokens

3. **Document complete state schema**
   - **What:** Add comprehensive list of all state fields ui-mockup manages in .continue-here.md
   - **Why:** Prevents state conflicts with other skills, enables correct state reading
   - **Estimated impact:** Prevents state corruption bugs, improves inter-skill coordination

4. **Add state content verification after subagent completion**
   - **What:** After subagent returns stateUpdated=true, verify state contents match expected values
   - **Why:** Boolean flag only indicates attempt; content validation ensures correctness
   - **Estimated impact:** Prevents silent state corruption from subagent bugs

5. **Reduce bash examples to prose instructions**
   - **What:** Replace bash scripts for simple operations (file checks, version detection) with prose
   - **Why:** Code examples valuable for complex operations only; simple checks don't need full scripts
   - **Estimated impact:** Saves ~500 tokens

6. **Remove calculation formula duplication**
   - **What:** Replace lines 252-320 with reference to layout-validation.md Section 2
   - **Why:** Formulas already in reference file; loading twice wastes tokens
   - **Estimated impact:** Saves ~1k tokens

7. **Clarify skill boundary with plugin-workflow**
   - **What:** Move workflow state detection to plugin-workflow; ui-mockup accepts mode as parameter
   - **Why:** Single responsibility - workflow orchestration belongs to plugin-workflow
   - **Estimated impact:** Reduces coupling, improves maintainability

8. **Consolidate state update verification**
   - **What:** After subagent completion, verify specific state fields rather than just checking boolean
   - **Why:** Defense in depth against subagent bugs
   - **Estimated impact:** Catches state corruption early

### P2 (Nice to Have - Optimize When Possible)

1. **Flatten cross-reference depth**
   - **What:** Consolidate reference chains into single comprehensive files
   - **Why:** Prevents "dig deeper" patterns that Claude may not follow completely
   - **Estimated impact:** Improves reference discovery reliability by 15%

2. **Document parallel read patterns**
   - **What:** Add explicit parallelization guidance for multi-file context loading
   - **Why:** Sequential reads waste time; parallel reads 40% faster
   - **Estimated impact:** Reduces latency by 40% for multi-file operations

3. **Add more trigger phrases to YAML description**
   - **What:** Expand description with specific user phrases: "UI design", "mockup", "WebView interface"
   - **Why:** Improves discoverability and activation reliability
   - **Estimated impact:** Increases successful skill activation by 10%

4. **Clarify boundary with ui-template-library**
   - **What:** Document explicit ownership of aesthetic integration steps
   - **Why:** Split responsibility needs clear boundaries for maintainability
   - **Estimated impact:** Reduces coordination confusion

5. **Standardize POV in state management sections**
   - **What:** Convert to consistent third-person throughout
   - **Why:** Matches YAML description voice, improves readability
   - **Estimated impact:** Minor readability improvement

---

## Impact Assessment

**If all P0/P1 recommendations implemented:**

- **Context window savings:** 18k-22k tokens (60-70% reduction from current 30k+ load)
  - P0 progressive disclosure: -7k tokens
  - P0 remove duplication: -2k tokens
  - P0 conditional loading: -8k to -12k tokens
  - P1 reduce XML: -1.5k tokens
  - P1 remove explanations: -800 tokens
  - P1 bash to prose: -500 tokens
  - P1 formula deduplication: -1k tokens

- **Reliability improvements:**
  - State corruption prevention via content verification (P1)
  - Inter-skill coordination via documented state schema (P1)
  - Reference discovery via flattened depth (P2)

- **Performance gains:**
  - 70% faster initial skill load (P0)
  - 40% faster multi-file context reads via parallelization (P2)

- **Maintainability:**
  - Reduced coupling with plugin-workflow (P1)
  - Single source of truth for reference content (P0)
  - Clear skill boundaries documented (P2)

- **Discoverability:**
  - More trigger phrases in YAML (P2)
  - Clearer skill boundaries reduce confusion (P2)

---

## Next Steps

1. **Create references/delegation-protocols.md** - Move Phase A/B subagent invocation details from SKILL.md (target: lines 450-850)

2. **Create references/state-tracking.md** - Move state management protocol from SKILL.md, add complete schema documentation (target: lines 876-940)

3. **Update SKILL.md** - Replace moved content with signposts to new references, reduce to <500 lines

4. **Remove duplication** - Delete content from SKILL.md that duplicates existing references (aesthetic-integration.md, versioning.md, decision-menus.md, phase-b-enforcement.md)

5. **Simplify XML structure** - Replace 50% of XML tags with markdown headers, reserve XML for structured data only

6. **Add state verification** - Update orchestration protocol to verify state field contents after subagent completion, not just stateUpdated flag

7. **Document state schema** - Add comprehensive state field list to references/state-tracking.md

8. **Test context window impact** - Measure actual token reduction after changes using test invocation

9. **Update plugin-workflow coordination** - Discuss with plugin-workflow skill maintainer about moving state detection responsibility

10. **Validate all changes** - Ensure skill still functions correctly after refactoring (run test invocation with real plugin)
