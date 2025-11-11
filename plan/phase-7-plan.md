# Phase 7 Implementation Plan

## Prerequisites Status

**Previous Phase(s) Required:** Phase 0, 1, 2, 3, 4, 5, 6

**Deliverables Check:**

### Phase 0 (Foundation & Contracts)
- ✅ `.claude/` directory structure - EXISTS
- ✅ `PLUGINS.md` registry - EXISTS
- ✅ Contract templates in skill assets - EXISTS
- ✅ `CLAUDE.md` navigation index - EXISTS

### Phase 1 (Discovery System)
- ✅ All 9 slash commands - EXISTS
- ✅ All 7 core skills - EXISTS
- ✅ Interactive decision system - EXISTS
- ✅ Handoff file system (`.continue-here.md`) - EXISTS

### Phase 2 (Workflow Engine)
- ✅ plugin-workflow Stages 0, 1, 6 - EXISTS
- ✅ State machine (PLUGINS.md transitions) - EXISTS
- ✅ Git commit integration - EXISTS

### Phase 3 (Implementation Subagents)
- ✅ foundation-agent - EXISTS
- ✅ shell-agent - EXISTS
- ✅ dsp-agent - EXISTS
- ✅ gui-agent - EXISTS
- ✅ Dispatcher pattern integration - EXISTS

### Phase 4 (Build & Troubleshooting)
- ✅ `scripts/build-and-install.sh` - EXISTS
- ✅ build-automation skill - EXISTS
- ✅ troubleshooter agent - EXISTS

### Phase 5 (Validation System)
- ✅ Python validation scripts (`.claude/hooks/validators/`) - EXISTS
- ✅ All 6 hook scripts - EXISTS
- ✅ validator subagent - EXISTS
- ✅ Hybrid validation operational - EXISTS

### Phase 6 (WebView UI System)
- ✅ ui-mockup skill (two-phase workflow) - EXISTS
- ✅ ui-template-library skill - EXISTS
- ✅ `.claude/aesthetics/` directory structure - EXISTS
- ✅ WebView code templates - EXISTS
- ✅ UI design rules documentation - EXISTS
- ✅ gui-agent WebView integration - EXISTS

**Status:** Complete

---

## Phase Overview

Phase 7 ("Polish & Enhancement") is the final phase of the Plugin Freedom System, transforming it from a working development framework into a professional, production-ready system with advanced iteration capabilities. This phase implements:

1. **`/uninstall` Command** - Entry point for existing plugin-lifecycle uninstallation workflow
2. **troubleshooting-docs Skill** - Captures problem solutions in searchable knowledge base (dual-indexed)
3. **deep-research Skill** - Multi-agent parallel investigation for complex JUCE problems (3-level protocol)
4. **design-sync Skill** - Validates mockup ↔ creative brief consistency, catches design drift before implementation
5. **plugin-improve Enhancements** - Advanced version management, regression testing, enhanced changelog generation

**Why this phase is critical:** Phase 7 completes the feedback loop that enables continuous plugin improvement. Users can iterate rapidly (lifecycle management), validate design decisions (design-sync), solve complex problems (deep-research), capture institutional knowledge (troubleshooting-docs), and prevent regressions (improved plugin-improve). This transforms the system from "build once" to "iterate continuously."

**Core Principle:** Enable the improvement feedback loop:
```
Build → Test → Find Issue → Research → Improve → Document → Validate → Deploy
    ↑                                                                      ↓
    └──────────────────────────────────────────────────────────────────────┘
```

## Sub-Phase Breakdown

This phase is NOT split into sub-phases. All components are implemented sequentially with clear dependencies.

**Rationale:** Each component depends on the previous:
- `/uninstall` command completes lifecycle management (install + uninstall)
- troubleshooting-docs creates knowledge base foundation
- deep-research consumes knowledge base (Level 1 fast path searches local docs)
- design-sync validates contracts (independent contract validation)
- plugin-improve enhancements leverage troubleshooting-docs + deep-research

## Required Documentation

### Architecture Files (MUST READ IN ENTIRETY)

- **`architecture/00-PHILOSOPHY.md`** - Progressive disclosure pattern for new skills, risk-free exploration through checkpoints, interactive decision philosophy
- **`architecture/01-executive-summary.md`** - Dispatcher pattern, contract-driven development, hybrid validation, decision system
- **`architecture/02-core-abstractions.md`** - Five fundamental concepts (navigation index, workflows, subagents, contracts, validation), skill interface patterns, contract enforcement rules
- **`architecture/03-model-selection-extended-thinking-strategy.md`** - Model assignments for Phase 7 (deep-research uses Opus + extended thinking for Level 3, design-sync uses Sonnet + extended thinking)
- **`architecture/05-routing-architecture.md`** - Instructed routing pattern (slash commands instruct Claude which skill to invoke), interactive decision system specifications (when to present options, menu format)
- **`architecture/06-state-architecture.md`** - PLUGINS.md state machine (💡 → 🚧 → ✅ → 📦), session state (.continue-here.md format), state transition rules, handoff file system
- **`architecture/07-communication-architecture.md`** - Subagent report format, error propagation patterns, JSON schema for research reports
- **`architecture/09-file-system-design.md`** - Directory structure, troubleshooting/ organization (by-plugin + by-symptom dual-indexing), backup/ structure
- **`architecture/10-extension-architecture.md`** - Adding new skills (SKILL.md structure, frontmatter format, references/ and assets/ directories), Anthropic skill pattern
- **`architecture/11-build-automation-architecture.md`** - build-and-install.sh specification (7-phase pipeline), unified root CMakeLists.txt pattern, cache clearing requirements
- **`architecture/13-error-handling-recovery.md`** - Hook conditional execution pattern (check relevance first, graceful skip with exit 0), error recovery 4-option menu pattern, validation override logging
- **`architecture/17-testing-strategy.md`** - Performance budgets, system test patterns, regression test specifications

### Procedure Files (MUST READ IN ENTIRETY)

#### Core Systems
- **`procedures/core/checkpoint-system.md`** - Checkpoint types (hard/soft/decision), handoff file format and location, risk-free exploration pattern
- **`procedures/core/interactive-decision-system.md`** - Decision menu format (numbered lists NOT AskUserQuestion), progressive disclosure markers, context-aware option generation, ordering rules

#### Agents
- **`procedures/agents/troubleshooter.md`** - 4-level graduated research protocol (Level 0: quick, Level 1: local docs, Level 2: Context7, Level 3: web research), investigation depth criteria

#### Commands
- **`procedures/commands/continue.md`** - Universal handoff system, status presentation, routing logic
- **`procedures/commands/doc-fix.md`** - Problem documentation workflow, YAML schema validation, auto-invocation triggers
- **`procedures/commands/improve.md`** - Phase 0.5 investigation (three-tier), vagueness detection, automatic versioning, safety features
- **`procedures/commands/install-plugin.md`** - Installation workflow, cache clearing, verification

#### Scripts
- **`procedures/scripts/build-and-install.md`** - 8-step build workflow, flags (--dry-run, --no-install), log management

#### Skills
- **`procedures/skills/build-automation.md`** - Build failure protocol (4-option menu), never auto-retry pattern
- **`procedures/skills/context-resume.md`** - Handoff file parsing, search locations, next step proposals
- **`procedures/skills/deep-research.md`** - Research sources (priority order), graduated depth protocol (3 tiers), structured report format
- **`procedures/skills/design-sync.md`** - Contract comparison logic (brief vs mockup), drift categorization, evolution section updates
- **`procedures/skills/juce-foundation.md`** - JUCE best practices enforcement, API verification, real-time safety rules
- **`procedures/skills/plugin-ideation.md`** - Two modes (new plugin vs improvement), 5-phase workflow, adaptive questioning
- **`procedures/skills/plugin-improve.md`** - 7-phase improvement workflow (exploration → investigation → implementation → changelog → build → git → install), version management, backup creation
- **`procedures/skills/plugin-lifecycle.md`** - Installation management, system folder operations, permission verification, cache clearing
- **`procedures/skills/plugin-testing.md`** - 5 automated tests (parameter response, state save/load, silent input, feedback loop, CPU performance)
- **`procedures/skills/troubleshooting-docs.md`** - Auto-invoke triggers, validated YAML schema, 7-step process, cross-referencing

---

## Implementation Sequence

### Task 1: Create `/uninstall` Command (Entry Point to Existing Functionality)

**Description**: Create `/uninstall` command to invoke existing plugin-lifecycle uninstallation workflow. The plugin-lifecycle skill already has complete uninstallation logic (see `.claude/skills/plugin-lifecycle/references/uninstallation-process.md`) - we just need a command entry point.

**Current State**:
- ✅ plugin-lifecycle skill has full uninstallation workflow
- ✅ System folder verification, cache clearing, PLUGINS.md updates all implemented
- ❌ No `/uninstall` command exists (only `/install-plugin`)

**Required Reading**:
- `.claude/skills/plugin-lifecycle/SKILL.md` (all sections) - Existing implementation
- `.claude/skills/plugin-lifecycle/references/uninstallation-process.md` (all sections) - Complete uninstall workflow
- `architecture/06-state-architecture.md` (lines 62-154) - PLUGINS.md state transitions

**Dependencies**: None (creates entry point to existing Phase 4 functionality)

**Implementation Steps**:

1. Read `.claude/skills/plugin-lifecycle/references/uninstallation-process.md` to verify existing uninstallation workflow is complete

2. Create `.claude/commands/uninstall.md`:
   ```markdown
   ---
   name: uninstall
   description: Remove plugin from system folders (uninstall)
   ---

   # /uninstall

   When user runs `/uninstall [PluginName]`, invoke the plugin-lifecycle skill with uninstallation mode.

   ## Preconditions

   - Plugin must be installed (status: 📦 Installed in PLUGINS.md)
   - Cannot uninstall if plugin is 🚧 in development (use /continue first)

   ## Behavior

   Invoke plugin-lifecycle skill following the uninstallation workflow:
   1. Locate plugin files (extract PRODUCT_NAME from CMakeLists.txt)
   2. Confirm removal with user (show file sizes, preserve source code)
   3. Remove from system folders (VST3 + AU)
   4. Clear DAW caches (Ableton + Logic)
   5. Update PLUGINS.md status: 📦 Installed → ✅ Working
   6. Present decision menu for next steps

   See `.claude/skills/plugin-lifecycle/references/uninstallation-process.md` for complete workflow.

   ## Success Output

   ```
   ✓ [PluginName] uninstalled

   Removed from system folders:
   - VST3: ~/Library/Audio/Plug-Ins/VST3/[ProductName].vst3 (deleted)
   - AU: ~/Library/Audio/Plug-Ins/Components/[ProductName].component (deleted)

   Cache status: Cleared (Ableton + Logic)

   Source code remains: plugins/[PluginName]/

   To reinstall: /install-plugin [PluginName]
   ```

   ## Routes To

   `plugin-lifecycle` skill (uninstallation mode)
   ```

3. Update `CLAUDE.md` to add `/uninstall` command:
   ```markdown
   ### Commands
   - `/install-plugin [Name]` - Install to system folders
   - `/uninstall [Name]` - Remove from system folders (NEW)
   ```

**Expected Output**:
- `.claude/commands/uninstall.md` - Command entry point
- `CLAUDE.md` - Updated with `/uninstall` command

**Verification**:

**Automated:**
```bash
# Test command exists
test -f .claude/commands/uninstall.md && echo "✅ /uninstall command exists"

# Test CLAUDE.md updated
grep -q "uninstall" CLAUDE.md && echo "✅ CLAUDE.md references uninstall"

# Verify existing uninstallation-process.md
test -f .claude/skills/plugin-lifecycle/references/uninstallation-process.md && echo "✅ Uninstallation workflow exists"
```

**Manual:** STOP AND ASK LEX: "I've created the `/uninstall` command. Please verify:
1. Create a test plugin and install it: `/install-plugin TestPlugin`
2. Verify plugin appears in `~/Library/Audio/Plug-Ins/VST3/` and `.../Components/`
3. Run `/uninstall TestPlugin`
4. Verify plugin removed from system folders
5. Check PLUGINS.md status changed from 📦 to ✅
6. Confirm source code still exists in `plugins/TestPlugin/`
7. Test reinstall: `/install-plugin TestPlugin` should work

Please respond with confirmation or any issues found before I proceed to Task 2."

---

### Task 2: troubleshooting-docs Skill (Foundation)

**Description**: Create troubleshooting-docs skill to capture problem solutions in a searchable knowledge base with dual-indexing (by-plugin + by-symptom).

**Required Reading**:
- `architecture/09-file-system-design.md` (all sections) - Directory structure for troubleshooting/
- `architecture/10-extension-architecture.md` (all sections) - Skill creation pattern
- `procedures/skills/troubleshooting-docs.md` (all sections) - Complete specification
- `procedures/commands/doc-fix.md` (all sections) - Auto-invoke patterns

**Dependencies**: Task 1 complete (lifecycle management operational)

**Implementation Steps**:

1. Create skill directory structure:
   ```bash
   mkdir -p .claude/skills/troubleshooting-docs/{references,assets}
   ```

2. Create file system structure:
   ```bash
   mkdir -p troubleshooting/{by-plugin,by-symptom,patterns}
   echo "# Common JUCE Plugin Solutions" > troubleshooting/patterns/common-solutions.md
   ```

3. Create `.claude/skills/troubleshooting-docs/assets/resolution-template.md`:
   ```markdown
   ---
   plugin: [PluginName]
   date: [YYYY-MM-DD]
   symptom: [Brief description]
   severity: [low|medium|high|critical]
   tags: [build, runtime, validation, webview, dsp, gui]
   ---

   # [Problem Title]

   ## Symptom
   [What user saw - error messages, behavior]

   ## Context
   - **Plugin:** [Name]
   - **Stage:** [0-6 or post-implementation]
   - **JUCE Version:** [8.x.x]
   - **OS:** [macOS version]

   ## Investigation Steps Tried
   1. [First attempt - failed because...]
   2. [Second attempt - failed because...]

   ## Root Cause
   [Technical explanation of what was actually wrong]

   ## Solution
   [Step-by-step fix that worked]

   ```code
   // Code changes if applicable
   ```

   ## Prevention
   [How to avoid this in future / what to check]

   ## Related Issues
   - Link to similar problem in troubleshooting/
   - Link to JUCE forum thread if applicable

   ## References
   - JUCE documentation section
   - External resources
   ```

4. Create `.claude/skills/troubleshooting-docs/SKILL.md`:
   ```markdown
   ---
   name: troubleshooting-docs
   description: Capture problem solutions in searchable knowledge base
   allowed-tools:
     - Read  # Parse conversation context
     - Write  # Create resolution docs
     - Bash  # Create symlinks for dual-indexing
     - Grep  # Search existing docs
   preconditions:
     - Problem has been solved (not in-progress)
     - Solution has been verified working
   model: sonnet
   ---

   [Implementation details per procedures/skills/troubleshooting-docs.md]

   # 7-Step Process

   ## Step 1: Detect Confirmation
   Auto-invoke after phrases:
   - "that worked"
   - "it's fixed"
   - "working now"
   - "problem solved"

   OR manual: `/doc-fix` command

   ## Step 2: Gather Context
   From conversation:
   - Plugin name
   - Symptom (what was wrong)
   - Investigation attempts (what didn't work)
   - Root cause (what was actually wrong)
   - Solution (what fixed it)
   - Prevention (how to avoid)

   ## Step 3: Check Existing Docs
   Search troubleshooting/ for similar issues:
   ```bash
   grep -r "symptom pattern" troubleshooting/
   ```

   If similar found: Offer to cross-reference vs create new

   ## Step 4: Generate Filename
   Format: `[sanitized-symptom]-[plugin]-[YYYYMMDD].md`
   Example: `missing-juce-dsp-module-DelayPlugin-20251110.md`

   ## Step 5: Validate YAML Schema
   REQUIRED fields:
   - plugin (string)
   - date (YYYY-MM-DD)
   - symptom (string)
   - severity (enum: low|medium|high|critical)
   - tags (array of strings)

   BLOCK if validation fails - present error and retry

   ## Step 6: Create Documentation
   Two files created via symlinks:
   ```bash
   # Real file
   REAL_FILE="troubleshooting/by-plugin/${PLUGIN}/${CATEGORY}/${FILENAME}"

   # Symlink from by-symptom
   SYMLINK="troubleshooting/by-symptom/${CATEGORY}/${FILENAME}"
   ln -s "../../by-plugin/${PLUGIN}/${CATEGORY}/${FILENAME}" "$SYMLINK"
   ```

   Categories auto-detected from tags:
   - crashes → crashes/
   - build → build-failures/
   - validation → validation-problems/
   - runtime → runtime-issues/

   ## Step 7: Cross-Reference
   If similar issues found in Step 3:
   - Add "Related Issues" links in both docs
   - Update patterns/common-solutions.md if pattern emerges

   # Decision Menu After Capture

   ✓ Solution documented

   What's next?
   1. Continue workflow (recommended)
   2. Link related issues - Connect to similar problems
   3. Update common patterns - Add to pattern library
   4. View documentation - See what was captured
   5. Other
   ```

5. Create `.claude/skills/troubleshooting-docs/references/yaml-schema.md`:
   ```markdown
   # YAML Frontmatter Schema

   ## Required Fields

   - **plugin** (string): Plugin name exactly as in PLUGINS.md
   - **date** (string): ISO 8601 date (YYYY-MM-DD)
   - **symptom** (string): Brief symptom description
   - **severity** (enum): One of [low, medium, high, critical]
   - **tags** (array): One or more of [build, runtime, validation, webview, dsp, gui, parameters, cmake, juce-api]

   ## Validation Rules

   1. All required fields must be present
   2. date must match YYYY-MM-DD format
   3. severity must be one of the allowed values
   4. tags must be non-empty array
   5. plugin must exist in PLUGINS.md (warning if not, not blocking)

   ## Example

   ```yaml
   ---
   plugin: DelayPlugin
   date: 2025-11-10
   symptom: Missing juce_dsp module causing link errors
   severity: medium
   tags: [build, cmake]
   ---
   ```
   ```

6. Create `/doc-fix` command in `.claude/commands/doc-fix.md`:
   ```markdown
   Invoke the troubleshooting-docs skill to document a recently solved problem.

   This command captures:
   - Problem symptom
   - Investigation steps tried
   - Root cause analysis
   - Working solution
   - Prevention strategies

   The documentation is dual-indexed (by-plugin and by-symptom) for fast lookup.

   **Preconditions:**
   - Problem has been solved
   - Solution verified working

   **Usage:** `/doc-fix` (auto-detects context from conversation)
   ```

7. Update `CLAUDE.md` with troubleshooting-docs location and purpose

**Expected Output**:
- `.claude/skills/troubleshooting-docs/SKILL.md` - Complete skill implementation
- `.claude/skills/troubleshooting-docs/assets/resolution-template.md` - Template file
- `.claude/skills/troubleshooting-docs/references/yaml-schema.md` - Validation spec
- `troubleshooting/` directory structure created
- `.claude/commands/doc-fix.md` - Slash command
- `CLAUDE.md` - Updated navigation

**Verification**:

**Automated:**
```bash
# Test directory structure
test -d troubleshooting/by-plugin && test -d troubleshooting/by-symptom && echo "✅ Dual-index structure exists"

# Test skill file
test -f .claude/skills/troubleshooting-docs/SKILL.md && echo "✅ Skill exists"

# Test template
test -f .claude/skills/troubleshooting-docs/assets/resolution-template.md && echo "✅ Template exists"

# Test command
test -f .claude/commands/doc-fix.md && echo "✅ Command exists"
```

**Manual:** STOP AND ASK LEX: "I've implemented troubleshooting-docs skill. Please verify:
1. Create a fake problem scenario: 'TestPlugin won't build due to missing juce_dsp module'
2. Solve it: 'Added juce_dsp to CMakeLists.txt'
3. Run `/doc-fix` to document the solution
4. Verify file created in `troubleshooting/by-plugin/TestPlugin/build-failures/`
5. Verify symlink exists in `troubleshooting/by-symptom/build-failures/`
6. Check YAML frontmatter has all required fields
7. Confirm decision menu appears after capture

Please respond with confirmation or any issues found before I proceed to Task 3."

---

### Task 3: deep-research Skill

**Description**: Create deep-research skill for multi-agent parallel investigation of complex JUCE problems with graduated depth protocol.

**Required Reading**:
- `architecture/03-model-selection-extended-thinking-strategy.md` (all sections) - Model selection for research levels
- `architecture/07-communication-architecture.md` (all sections) - Subagent report format
- `procedures/skills/deep-research.md` (all sections) - Graduated protocol specification
- `procedures/agents/troubleshooter.md` (all sections) - Integration with troubleshooter Level 4

**Dependencies**: Task 2 complete (troubleshooting-docs provides Level 1 fast path)

**Implementation Steps**:

1. Create skill directory structure:
   ```bash
   mkdir -p .claude/skills/deep-research/{references,assets}
   ```

2. Create `.claude/skills/deep-research/references/research-protocol.md`:
   ```markdown
   # Graduated Research Protocol

   ## Level 1: Quick Check (5-10 min, Sonnet, no extended thinking)

   **Sources:**
   1. Local troubleshooting docs (search for similar symptoms)
   2. Context7 JUCE documentation (quick API lookup)

   **Decision:** If confident solution found → return immediately
   **Escalate to Level 2 if:** No solution or low confidence

   ## Level 2: Moderate Investigation (15-30 min, Sonnet, no extended thinking)

   **Sources:**
   1. Context7 deep-dive (module documentation, examples)
   2. JUCE forum search (known issues, discussions)
   3. GitHub issue search (juce-framework/JUCE repository)

   **Decision:** If confident solution found → return immediately
   **Escalate to Level 3 if:** Complex algorithm question, novel implementation needed

   ## Level 3: Deep Research (30-60 min, Opus, extended thinking 15k budget)

   **Sources:**
   1. All Level 1-2 sources
   2. Academic papers (DSP algorithms, audio processing)
   3. Commercial plugin research (similar implementations)
   4. Parallel subagent spawning (investigate multiple approaches)

   **Parallel Investigation:**
   - Spawn 2-3 research subagents in fresh contexts
   - Each investigates different algorithm/approach
   - Main context synthesizes findings
   - Present comparison with pros/cons

   **Always returns:** Structured report with recommendations

   ## Auto-Escalation Triggers

   - Level 1 → 2: No results in 5 min OR low confidence
   - Level 2 → 3: Complex DSP question OR novel feature OR no clear answer after 15 min

   ## User Override

   Decision menu at each level:
   - Continue to next level
   - Stop with current findings
   - Adjust timeout/budget
   - Other
   ```

3. Create `.claude/skills/deep-research/assets/report-template.json`:
   ```json
   {
     "agent": "deep-research",
     "status": "success",
     "level": 3,
     "topic": "wavetable anti-aliasing implementation",
     "findings": [
       {
         "solution": "BLEP (Band-Limited Step)",
         "confidence": "high",
         "description": "Add polynomial residuals at discontinuities",
         "pros": ["CPU efficient", "Good quality", "JUCE has helpers"],
         "cons": ["Limited to specific waveforms"],
         "implementation_complexity": 3,
         "references": ["JUCE dsp::Oscillator", "Reducing Aliasing from Synthetic Audio Signals (2007)"]
       },
       {
         "solution": "Oversampling + filtering",
         "confidence": "high",
         "description": "Render at higher sample rate, filter, downsample",
         "pros": ["Works for all waveforms", "JUCE has juce::dsp::Oversampling"],
         "cons": ["Higher CPU cost"],
         "implementation_complexity": 2,
         "references": ["JUCE dsp::Oversampling docs"]
       }
     ],
     "recommendation": 1,
     "reasoning": "Oversampling is simpler to implement and works for arbitrary waveforms. BLEP requires waveform-specific code.",
     "sources": [
       "Context7: juce::dsp::Oversampling documentation",
       "Paper: Reducing Aliasing from Synthetic Audio Signals (Brandt & Dannenberg, 2007)",
       "JUCE Forum: Wavetable synthesis best practices"
     ],
     "time_spent_minutes": 42,
     "escalation_path": [1, 2, 3]
   }
   ```

4. Create `.claude/skills/deep-research/SKILL.md`:
   ```markdown
   ---
   name: deep-research
   description: Multi-agent parallel investigation for complex JUCE problems
   allowed-tools:
     - Read  # Local troubleshooting docs
     - Grep  # Search docs
     - Task  # Spawn parallel research subagents (Level 3)
     - WebSearch  # Web research (Level 2-3)
   preconditions:
     - Problem is non-trivial (quick Context7 lookup insufficient)
   model: sonnet  # Level 1-2, Opus for Level 3
   extended-thinking: false  # Level 1-2, true for Level 3 (15k budget)
   timeout: 3600  # 60 min max
   ---

   # Deep Research Skill

   ## Entry Point

   Invoked by:
   - troubleshooter agent (Level 4 investigation)
   - User manual: `/research [topic]`
   - build-automation "Investigate" option

   ## Level 1: Quick Check (5-10 min)

   1. Parse research topic/question
   2. Search local troubleshooting docs:
      ```bash
      grep -r "[topic keywords]" troubleshooting/
      ```
   3. Check Context7 JUCE docs for direct answers
   4. If solution found with high confidence:
      - Generate report (Level 1)
      - Present decision menu: Apply / Review / Continue deeper / Other
      - STOP (don't auto-escalate)

   ## Level 2: Moderate Investigation (15-30 min)

   User chose "Continue deeper" OR Level 1 found nothing:

   1. Context7 deep-dive:
      - Module documentation
      - Code examples
      - Related classes
   2. JUCE forum search via WebSearch:
      - Query: "site:forum.juce.com [topic]"
   3. GitHub issue search:
      - Query: "site:github.com/juce-framework/JUCE [topic]"
   4. Synthesize findings
   5. If solution found with medium-high confidence:
      - Generate report (Level 2)
      - Present decision menu: Apply / Review / Continue deeper / Other
      - STOP

   ## Level 3: Deep Research (30-60 min, Opus + Extended Thinking)

   User chose "Continue deeper" OR Level 2 insufficient:

   1. **Switch to Opus model with extended thinking (15k budget)**
   2. Parallel subagent investigation:
      ```
      Spawn 2-3 research subagents via Task tool:
      - Subagent 1: Algorithm A investigation
      - Subagent 2: Algorithm B investigation
      - Subagent 3: Commercial plugin research

      Each returns structured findings
      ```
   3. Main context synthesizes:
      - Compare approaches
      - Pros/cons for each
      - Implementation complexity estimate
      - Recommend best fit
   4. Generate comprehensive report (Level 3)
   5. Present decision menu: Apply recommended / Review all / Try alternative / Document / Other

   ## Report Generation

   Use template from assets/report-template.json

   Required fields:
   - level (1, 2, or 3)
   - topic (research question)
   - findings (array of solutions with pros/cons)
   - recommendation (index into findings)
   - reasoning (why recommended)
   - sources (citations)

   ## Decision Menu Format

   ✓ Research complete (Level N, found M solutions)

   What's next?
   1. Apply recommended solution - [Brief description] (recommended)
   2. Review all findings - See detailed comparison
   3. Try alternative approach - [Alternative solution name]
   4. Document findings - Save to troubleshooting/
   5. Extend research - Continue to Level N+1 (if not already Level 3)
   6. Other

   ## Integration with troubleshooting-docs

   If user chooses "Document findings":
   - Invoke troubleshooting-docs skill
   - Pass research report as context
   - Capture in knowledge base for future Level 1 fast path

   ## Error Handling

   **Timeout (>60 min):**
   - Return best answer based on thinking so far
   - Add warning: "Research incomplete due to timeout"
   - Present option: "Retry with extended timeout"

   **No solution found:**
   - Report findings (what was tried)
   - Suggest: Community forum post, JUCE official support, alternative approaches
   - Offer to document "attempted solutions" for future reference
   ```

5. Create `.claude/commands/research.md`:
   ```markdown
   Invoke the deep-research skill to investigate complex JUCE plugin development problems.

   Uses graduated research protocol:
   - Level 1: Quick check (local docs + Context7)
   - Level 2: Moderate investigation (forums + GitHub)
   - Level 3: Deep research (parallel investigation + academic papers)

   Auto-escalates based on confidence, but you control depth via decision menus.

   **Usage:** `/research [topic]`
   **Example:** `/research wavetable anti-aliasing implementation`

   **When to use:**
   - Complex DSP algorithm questions
   - Novel feature implementation research
   - Performance optimization strategies
   - JUCE API usage for advanced scenarios
   ```

6. Update `troubleshooter.md` to invoke deep-research at Level 4:
   ```markdown
   ## Level 4: Deep Research

   If Levels 0-3 insufficient, escalate to deep-research skill:

   ```bash
   # Invoke deep-research skill via instructed routing
   "I need to investigate this more deeply. Invoking deep-research skill..."
   [Invoke deep-research with problem context]
   ```

   deep-research handles:
   - Parallel investigation
   - Extended thinking budget
   - Academic paper research
   - Returns structured report with recommendations
   ```

7. Update `CLAUDE.md` with deep-research location

**Expected Output**:
- `.claude/skills/deep-research/SKILL.md` - Complete skill implementation
- `.claude/skills/deep-research/references/research-protocol.md` - Protocol specification
- `.claude/skills/deep-research/assets/report-template.json` - Report schema
- `.claude/commands/research.md` - Slash command
- `.claude/agents/troubleshooter.md` - Updated with Level 4 integration
- `CLAUDE.md` - Updated navigation

**Verification**:

**Automated:**
```bash
# Test skill exists
test -f .claude/skills/deep-research/SKILL.md && echo "✅ Skill exists"

# Test protocol doc
test -f .claude/skills/deep-research/references/research-protocol.md && echo "✅ Protocol documented"

# Test report template
test -f .claude/skills/deep-research/assets/report-template.json && echo "✅ Report template exists"

# Test command
test -f .claude/commands/research.md && echo "✅ Command exists"
```

**Manual:** STOP AND ASK LEX: "I've implemented deep-research skill. Please verify:
1. Run `/research wavetable anti-aliasing` (test topic)
2. Verify Level 1 searches local troubleshooting/ docs first
3. Confirm Context7 JUCE documentation is queried
4. Check decision menu appears: Apply / Review / Continue deeper / Other
5. If you choose 'Continue deeper', verify escalation to Level 2
6. Confirm structured report format matches template
7. Test 'Document findings' option integrates with troubleshooting-docs

Please respond with confirmation or any issues found before I proceed to Task 4."

---

### Task 4: design-sync Skill

**Description**: Create design-sync skill to validate mockup ↔ creative brief consistency and catch design drift before implementation.

**Required Reading**:
- `architecture/02-core-abstractions.md` (lines 111-183) - Contract enforcement philosophy
- `architecture/06-state-architecture.md` (all sections) - Contract file locations
- `procedures/skills/design-sync.md` (all sections) - Complete specification
- `procedures/skills/ui-mockup.md` (all sections) - Integration with mockup finalization

**Dependencies**: Task 3 complete (research capabilities operational)

**Implementation Steps**:

1. Create skill directory structure:
   ```bash
   mkdir -p .claude/skills/design-sync/{references,assets}
   ```

2. Create `.claude/skills/design-sync/references/drift-detection.md`:
   ```markdown
   # Design Drift Detection

   ## What is Design Drift?

   When the finalized mockup diverges from the original creative brief vision.

   **Common drift patterns:**
   - Parameter count mismatch (brief says 8, mockup has 12)
   - Visual style mismatch (brief says "vintage warmth", mockup is "modern minimal")
   - Missing features from brief (brief mentions "preset browser", mockup lacks it)
   - Scope creep (mockup adds features not in brief)

   ## Detection Strategy

   ### 1. Quantitative Checks (Fast)

   - **Parameter count:** Extract from parameter-spec.md, compare to brief's "parameters" section
   - **Control count:** Count UI elements in mockup YAML
   - **Mentioned features:** Grep brief for feature keywords, check mockup includes them

   ### 2. Semantic Validation (LLM)

   Use Sonnet + extended thinking to compare:
   - **Creative vision** (brief's "Concept" and "Use Cases")
   - **Actual design** (mockup YAML + rendered HTML)

   Questions to answer:
   - Does mockup visual style match brief's aesthetic intent?
   - Are all brief-mentioned features present in mockup?
   - Are mockup additions justified (reasonable evolution) or scope creep?

   ## Drift Categories

   ### Acceptable Evolution ✅
   - User added parameters during design iteration
   - Visual polish (animations, micro-interactions not in brief)
   - Layout refinements for better UX
   - **Action:** Update brief's "Evolution" section, document decisions

   ### Drift Requiring Attention ⚠️
   - Missing features from brief
   - Visual style mismatch (different aesthetic direction)
   - Significant scope reduction (brief promises more than mockup delivers)
   - **Action:** Present options: Update mockup / Update brief / Override

   ### Critical Drift ❌
   - Mockup contradicts brief's core concept
   - Parameter count vastly different (brief: 5, mockup: 25)
   - Missing critical functionality (brief: "tempo-synced delay", mockup: basic delay)
   - **Action:** BLOCK implementation, require resolution

   ## Evolution Documentation

   When acceptable evolution detected, update brief:

   ```markdown
   ## Design Evolution

   ### [Date] - UI Mockup Finalization

   **Added:**
   - 4 additional parameters (modulation depth, feedback tone, etc.)
   - Visual meter for feedback level

   **Rationale:**
   - User testing revealed need for more tonal control
   - Meter improves usability during performance

   **Approved:** [User confirmation]
   ```
   ```

3. Create `.claude/skills/design-sync/SKILL.md`:
   ```markdown
   ---
   name: design-sync
   description: Validate mockup ↔ creative brief consistency, catch design drift
   allowed-tools:
     - Read  # Read contracts (brief, parameter-spec, mockup YAML)
     - Edit  # Update brief's Evolution section
   preconditions:
     - creative-brief.md exists
     - Mockup has been finalized (parameter-spec.md generated)
   model: sonnet
   extended-thinking: true
   thinking-budget: 8000  # Moderate creative reasoning
   ---

   # Design-Sync Skill

   ## Entry Points

   1. **Auto-invoked by ui-mockup** after Phase 4.5 finalization (before C++ generation)
   2. **Manual:** `/sync-design [PluginName]`
   3. **Stage 1 Planning:** Optional pre-check before implementation starts

   ## Workflow

   ### Step 1: Load Contracts

   Read three files:
   - `plugins/[PluginName]/.ideas/creative-brief.md` - Original vision
   - `plugins/[PluginName]/.ideas/parameter-spec.md` - Finalized parameters from mockup
   - `plugins/[PluginName]/.ideas/mockups/vN-ui.yaml` - Finalized mockup spec

   **Error handling:** If any missing, BLOCK with clear message

   ### Step 2: Quantitative Checks

   ```typescript
   // Extract from creative-brief.md
   briefParamCount = extractParameterCount(brief)
   briefFeatures = extractFeatures(brief)  // Mentioned features

   // Extract from parameter-spec.md
   mockupParamCount = countParameters(parameterSpec)
   mockupControls = countControls(mockupYAML)

   // Compare
   paramCountDelta = mockupParamCount - briefParamCount
   missingFeatures = briefFeatures.filter(f => !presentInMockup(f))
   ```

   ### Step 3: Semantic Validation (Extended Thinking)

   Use extended thinking to answer:

   1. **Visual style alignment:**
      - Brief aesthetic: [extracted quotes]
      - Mockup aesthetic: [YAML design system analysis]
      - Match? Yes/No + reasoning

   2. **Feature completeness:**
      - Brief promises: [list]
      - Mockup delivers: [list]
      - Missing: [list]

   3. **Scope assessment:**
      - Additions justified? (evolution vs creep)
      - Reductions justified? (simplification vs missing)

   ### Step 4: Categorize Drift

   Based on findings:

   - **No drift detected:** Parameter counts match, features present, style aligned
   - **Acceptable evolution:** Additions justified, document in brief
   - **Attention needed:** Missing features or style mismatch
   - **Critical drift:** Core concept contradicted

   ### Step 5: Present Findings

   #### If No Drift:
   ```
   ✓ Design-brief alignment verified

   - Parameter count: 12 (matches brief)
   - All features present
   - Visual style aligned: Modern minimal with analog warmth

   What's next?
   1. Continue implementation (recommended) - Alignment confirmed
   2. Review details - See full comparison
   3. Other
   ```

   #### If Acceptable Evolution:
   ```
   ⚠️ Design evolution detected (acceptable)

   **Changes from brief:**
   - Parameter count: 12 (brief: 8) +4 parameters
   - Added features: Visual feedback meter
   - Visual refinements: Animation polish

   **Assessment:** Reasonable evolution based on design iteration

   What's next?
   1. Update brief and continue (recommended) - Document evolution
   2. Review changes - See detailed comparison
   3. Revert to original - Simplify mockup to match brief
   4. Other
   ```

   #### If Drift Requiring Attention:
   ```
   ⚠️ Design drift detected

   **Issues found:**
   1. Missing feature: "Preset browser" mentioned in brief, absent in mockup
   2. Visual style mismatch: Brief emphasizes "vintage warmth", mockup is "stark modern"
   3. Parameter count: 5 (brief: 12) - significant reduction

   **Recommendation:** Address drift before implementation

   What's next?
   1. Update mockup - Add missing features, adjust style
   2. Update brief - Brief overpromised, mockup is realistic
   3. Continue anyway (override) - Accept drift, proceed with mockup as-is
   4. Review detailed comparison
   5. Other
   ```

   #### If Critical Drift:
   ```
   ❌ Critical design drift - Implementation BLOCKED

   **Critical issues:**
   1. Brief concept: "Tempo-synced rhythmic delay"
      Mockup delivers: Basic feedback delay (no tempo sync)
   2. Parameter count: 25 (brief: 5) - 5x scope creep

   **Action required:** Resolve drift before implementation can proceed

   What's next?
   1. Update mockup - Align with brief's core concept
   2. Update brief - Revise concept to match mockup
   3. Start over - New mockup from brief
   4. Other

   (Option to override not provided - critical drift must be resolved)
   ```

   ### Step 6: Execute User Choice

   **Option 1: Update brief and continue**
   - Add "Design Evolution" section to creative-brief.md
   - Document changes with rationale
   - Record user approval
   - Return success (continue to Stage 1)

   **Option 2: Update mockup**
   - Return to ui-mockup skill
   - Present drift findings
   - Iterate design
   - Re-run design-sync after changes

   **Option 3: Continue anyway (override)**
   - Log override to `.validator-overrides.yaml`:
     ```yaml
     - date: 2025-11-10
       validator: design-sync
       finding: parameter-count-mismatch
       override-reason: User confirmed evolution is intentional
     ```
   - Return success (allow implementation)

   ## Integration with ui-mockup

   ui-mockup Phase 4.5 (after finalization, before C++ generation):

   ```markdown
   ✓ Mockup finalized

   What's next?
   1. Check alignment - Run design-sync validation (recommended)
   2. Generate implementation files - Proceed to Phase 5
   3. Iterate design - Make more changes
   4. Other
   ```

   If user chooses "Check alignment" → invoke design-sync skill

   ## Integration with plugin-workflow Stage 1

   Optional pre-check before planning:

   ```markdown
   Starting Stage 1: Planning

   Mockup finalized: Yes
   design-sync validation: Not yet run

   What's next?
   1. Run design-sync - Validate brief ↔ mockup alignment (recommended)
   2. Skip validation - Proceed with planning
   3. Other
   ```
   ```

4. Create `.claude/commands/sync-design.md`:
   ```markdown
   Invoke the design-sync skill to validate mockup ↔ creative brief consistency.

   Catches design drift before implementation:
   - Parameter count mismatches
   - Missing features from brief
   - Visual style divergence
   - Scope creep or reduction

   **Usage:** `/sync-design [PluginName]`
   **Example:** `/sync-design DelayPlugin`

   **Preconditions:**
   - creative-brief.md exists
   - Mockup finalized (parameter-spec.md generated)

   **When to use:**
   - After mockup finalization (auto-suggested by ui-mockup)
   - Before Stage 1 Planning (optional pre-check)
   - Manual verification any time
   ```

5. Update `ui-mockup` skill to integrate design-sync:

   Find Phase 4.5 decision menu in `.claude/skills/ui-mockup/SKILL.md` and add option:
   ```markdown
   What's next?
   1. Check alignment - Run design-sync validation (recommended) ← NEW
   2. Generate implementation files - Proceed to Phase 5
   3. Iterate design - Make more changes
   4. Other
   ```

   When user chooses option 1, invoke design-sync skill before continuing.

6. Update `CLAUDE.md` with design-sync location

**Expected Output**:
- `.claude/skills/design-sync/SKILL.md` - Complete skill implementation
- `.claude/skills/design-sync/references/drift-detection.md` - Detection strategy
- `.claude/commands/sync-design.md` - Slash command
- `.claude/skills/ui-mockup/SKILL.md` - Updated Phase 4.5 menu
- `CLAUDE.md` - Updated navigation

**Verification**:

**Automated:**
```bash
# Test skill exists
test -f .claude/skills/design-sync/SKILL.md && echo "✅ Skill exists"

# Test references
test -f .claude/skills/design-sync/references/drift-detection.md && echo "✅ Drift detection docs exist"

# Test command
test -f .claude/commands/sync-design.md && echo "✅ Command exists"

# Test ui-mockup integration
grep -q "design-sync" .claude/skills/ui-mockup/SKILL.md && echo "✅ ui-mockup integration exists"
```

**Manual:** STOP AND ASK LEX: "I've implemented design-sync skill. Please verify:
1. Create a test plugin with creative-brief.md (specify 8 parameters)
2. Create a mockup with parameter-spec.md (specify 12 parameters - intentional mismatch)
3. Run `/sync-design TestPlugin`
4. Verify drift detection: 'Parameter count: 12 (brief: 8) +4 parameters'
5. Confirm decision menu appears with 'Update brief', 'Update mockup', 'Continue anyway' options
6. Choose 'Update brief and continue'
7. Verify creative-brief.md gets 'Design Evolution' section added
8. Test critical drift scenario (create mockup contradicting brief concept)
9. Verify BLOCK behavior (no override option)

Please respond with confirmation or any issues found before I proceed to Task 5."

---

### Task 5: plugin-improve Enhancements

**Description**: Enhance existing plugin-improve skill with advanced version management, regression testing suite, and improved changelog generation.

**Required Reading**:
- `architecture/17-testing-strategy.md` (all sections) - Regression test specifications
- `procedures/skills/plugin-improve.md` (all sections) - Current implementation baseline
- `procedures/skills/plugin-testing.md` (all sections) - Test integration
- `architecture/09-file-system-design.md` (backups/ section) - Backup structure

**Dependencies**: Tasks 1-4 complete (all Phase 7 infrastructure operational)

**Implementation Steps**:

1. Read `.claude/skills/plugin-improve/SKILL.md` to understand current implementation

2. Add regression testing integration (new Phase 5.5):

   Insert after Phase 5 (Build & test), before Phase 6 (Git workflow):

   ```markdown
   ## Phase 5.5: Regression Testing (if plugin-testing exists)

   **Check:** Does `.claude/skills/plugin-testing/SKILL.md` exist?

   **If NO:** Skip to Phase 6 (add warning to changelog: "Manual regression testing required")

   **If YES:** Run regression tests

   ### Regression Test Process

   1. **Determine baseline version:**
      - If improving v1.0.0 → v1.1.0, baseline is v1.0.0
      - Check if backup exists: `backups/[Plugin]/v[baseline]/`
      - If no backup: Skip regression tests (warn user)

   2. **Build baseline version:**
      ```bash
      # Temporarily checkout baseline
      cd backups/[Plugin]/v[baseline]/
      ./scripts/build-and-install.sh --no-install
      ```

   3. **Run tests on baseline:**
      - Invoke plugin-testing skill on baseline build
      - Capture results: BASELINE_RESULTS

   4. **Run tests on current version:**
      - Invoke plugin-testing skill on new build
      - Capture results: CURRENT_RESULTS

   5. **Compare results:**
      ```typescript
      interface RegressionReport {
        baseline_version: string
        current_version: string
        tests_run: number
        baseline_passing: number
        current_passing: number
        new_failures: TestCase[]  // Regressions!
        new_passes: TestCase[]    // Fixed bugs
        unchanged: number
      }
      ```

   6. **Present findings:**

   #### If No Regressions:
   ```
   ✓ Regression tests passed (5/5 tests, no new failures)

   What's next?
   1. Continue to git workflow (recommended)
   2. Review test details
   3. Other
   ```

   #### If Regressions Detected:
   ```
   ⚠️ Regression detected - new failures found

   **Baseline (v1.0.0):** 5/5 tests passing
   **Current (v1.1.0):** 3/5 tests passing

   **New failures:**
   1. Parameter Response Test - GAIN parameter no longer affects audio
   2. CPU Performance Test - Real-time factor increased from 0.05 to 0.15

   **Recommendation:** Fix regressions before proceeding

   What's next?
   1. Investigate failures - Debug issues (recommended)
   2. View test output - See detailed logs
   3. Continue anyway - Accept regressions (not recommended)
   4. Rollback changes - Revert to v1.0.0
   5. Other
   ```

   ### Rollback Mechanism

   If user chooses "Rollback changes":

   1. Verify backup exists: `backups/[Plugin]/v[baseline]/`
   2. Copy all files from backup to `plugins/[Plugin]/`
   3. Rebuild and reinstall
   4. Update PLUGINS.md status
   5. Git reset if commits were made
   6. Confirm rollback success
   ```

3. Enhance changelog generation (Phase 6 update):

   Replace current basic changelog with enhanced version:

   ```markdown
   ## Phase 6: Enhanced Changelog Generation

   ### Header Section
   ```markdown
   ## [NEW_VERSION] - YYYY-MM-DD

   ### [CHANGE_TYPE]
   - [Change description]
   ```

   **Change types** (auto-detected from version bump):
   - PATCH (1.0.0 → 1.0.1): "Fixed"
   - MINOR (1.0.0 → 1.1.0): "Added" or "Changed"
   - MAJOR (1.0.0 → 2.0.0): "Changed" (breaking) + "Migration Notes"

   ### Technical Details Section

   Add technical implementation details:
   ```markdown
   ### Technical
   - Parameter changes: [List parameter IDs added/modified/removed]
   - DSP changes: [List processBlock modifications]
   - UI changes: [List UI updates]
   - Dependencies: [New JUCE modules or external dependencies]
   ```

   ### Migration Notes (for MAJOR versions)

   ```markdown
   ### Migration Notes
   - v1.x presets compatible: [Yes/No + explanation]
   - API changes: [List breaking changes]
   - Workarounds: [How to adapt existing projects]
   ```

   ### Regression Test Results (if run)

   ```markdown
   ### Testing
   - Regression tests: ✅ 5/5 passing (baseline: v1.0.0)
   - New test coverage: [Any new tests added]
   ```

   ### Example Enhanced Changelog Entry

   ```markdown
   ## [1.1.0] - 2025-11-10

   ### Added
   - Tempo sync parameter (TEMPO_SYNC: bool, default false)
     - Locks delay time to DAW tempo
     - Supports 1/16 to 4 bars
     - Automatic BPM detection via AudioPlayHead

   ### Changed
   - Improved feedback algorithm for warmer saturation

   ### Technical
   - Added parameter: TEMPO_SYNC (ID: "tempoSync", range: [0,1])
   - Added juce::AudioPlayHead integration in processBlock
   - New WebView relay: tempoSyncRelay
   - Modified DSP: DelayLine now supports tempo-locked timing

   ### Testing
   - Regression tests: ✅ 5/5 passing (baseline: v1.0.0)
   - Added test: Tempo sync accuracy (±1ms)

   ### Migration Notes
   - v1.0 presets fully compatible (TEMPO_SYNC defaults to false, preserves behavior)
   - No breaking changes
   ```
   ```

4. Add backup verification (Phase 1 enhancement):

   Before Phase 1 (Pre-implementation checks), add Phase 0.9:

   ```markdown
   ## Phase 0.9: Backup Verification

   **Goal:** Ensure rollback is possible if improvement fails

   1. **Check if backup exists:**
      ```bash
      BACKUP_PATH="backups/[Plugin]/v[CURRENT_VERSION]/"
      if [[ ! -d "$BACKUP_PATH" ]]; then
        echo "⚠️ No backup found for v[CURRENT_VERSION]"
        CREATE_BACKUP=true
      fi
      ```

   2. **Create backup if missing:**
      ```bash
      mkdir -p "backups/[Plugin]/v[CURRENT_VERSION]/"
      cp -r "plugins/[Plugin]/"* "backups/[Plugin]/v[CURRENT_VERSION]/"
      echo "✓ Backup created: backups/[Plugin]/v[CURRENT_VERSION]/"
      ```

   3. **Verify backup integrity:**
      ```bash
      # Check critical files exist in backup
      test -f "$BACKUP_PATH/CMakeLists.txt"
      test -f "$BACKUP_PATH/PluginProcessor.h"
      test -f "$BACKUP_PATH/PluginProcessor.cpp"
      # Verify can rebuild from backup
      cd "$BACKUP_PATH"
      ./scripts/build-and-install.sh --dry-run
      ```

   4. **Present verification results:**
      ```
      ✓ Backup verified: backups/[Plugin]/v[CURRENT_VERSION]/

      - All source files present
      - CMakeLists.txt valid
      - Dry-run build successful

      Rollback available if needed.
      ```
   ```

5. Create backup verification script:

   ```bash
   # Create scripts/verify-backup.sh
   cat > scripts/verify-backup.sh << 'EOF'
   #!/bin/bash
   set -e

   PLUGIN_NAME="$1"
   VERSION="$2"
   BACKUP_PATH="backups/${PLUGIN_NAME}/v${VERSION}"

   # Color codes
   GREEN='\033[0;32m'
   YELLOW='\033[1;33m'
   RED='\033[0;31m'
   NC='\033[0m' # No Color

   echo "Verifying backup: ${BACKUP_PATH}"

   # Check directory exists
   if [[ ! -d "$BACKUP_PATH" ]]; then
     echo -e "${RED}❌ Backup not found${NC}"
     exit 1
   fi

   # Check critical files
   CRITICAL_FILES=(
     "CMakeLists.txt"
     "PluginProcessor.h"
     "PluginProcessor.cpp"
     "PluginEditor.h"
     "PluginEditor.cpp"
   )

   for file in "${CRITICAL_FILES[@]}"; do
     if [[ ! -f "${BACKUP_PATH}/${file}" ]]; then
       echo -e "${RED}❌ Missing: ${file}${NC}"
       exit 1
     else
       echo -e "${GREEN}✓${NC} ${file}"
     fi
   done

   # Verify CMakeLists.txt can be parsed
   if grep -q "project(" "${BACKUP_PATH}/CMakeLists.txt"; then
     echo -e "${GREEN}✓${NC} CMakeLists.txt valid"
   else
     echo -e "${RED}❌ CMakeLists.txt invalid${NC}"
     exit 1
   fi

   # Dry-run build test
   cd "$BACKUP_PATH"
   if cmake -B build -G Ninja --dry-run &>/dev/null; then
     echo -e "${GREEN}✓${NC} Dry-run build successful"
   else
     echo -e "${YELLOW}⚠️${NC} Dry-run build failed (may be okay if dependencies missing)"
   fi

   echo -e "${GREEN}✓ Backup verification complete${NC}"
   exit 0
   EOF

   chmod +x scripts/verify-backup.sh
   ```

6. Update `.claude/skills/plugin-improve/SKILL.md` frontmatter:
   ```yaml
   ---
   name: plugin-improve
   description: Fix bugs and add features with versioning, regression testing, and backups
   allowed-tools:
     - Read  # Read plugin code, PLUGINS.md, backups
     - Edit  # Modify code
     - Write  # Create/update CHANGELOG.md
     - Bash  # Build, test, git operations
     - Task  # Invoke plugin-testing for regression tests
   preconditions:
     - Plugin exists and status is ✅ Working or 📦 Installed
     - NOT 🚧 (use /continue instead)
   model: sonnet
   ---
   ```

7. Update documentation references in skill:
   ```markdown
   ## Phase 7 Enhancements

   This skill has been enhanced in Phase 7 with:

   - **Regression testing** (Phase 5.5): Automatically detects breaking changes
   - **Enhanced changelogs** (Phase 6): Technical details, migration notes, test results
   - **Backup verification** (Phase 0.9): Ensures rollback is possible
   - **Rollback mechanism**: One-command restore to previous version

   See `architecture/17-testing-strategy.md` for regression test specifications.
   ```

8. Update `CLAUDE.md` to reflect plugin-improve enhancements

**Expected Output**:
- `.claude/skills/plugin-improve/SKILL.md` - Enhanced with regression testing, better changelogs, backup verification
- `scripts/verify-backup.sh` - Backup integrity verification script
- `CLAUDE.md` - Updated documentation

**Verification**:

**Automated:**
```bash
# Test backup script exists and is executable
test -x scripts/verify-backup.sh && echo "✅ Backup verification script exists"

# Test plugin-improve updated
grep -q "Regression testing" .claude/skills/plugin-improve/SKILL.md && echo "✅ Regression testing integrated"

# Test enhanced changelog format documented
grep -q "Technical Details Section" .claude/skills/plugin-improve/SKILL.md && echo "✅ Enhanced changelog documented"
```

**Manual:** STOP AND ASK LEX: "I've implemented plugin-improve enhancements. Please verify:
1. Create a test plugin v1.0.0 and install it
2. Run `/improve TestPlugin - add new parameter TONE`
3. Verify Phase 0.9 creates/verifies backup
4. Verify implementation adds TONE parameter
5. Verify Phase 5.5 runs regression tests (if plugin-testing exists)
6. Confirm enhanced changelog generation includes:
   - Technical details (parameter IDs, DSP changes)
   - Regression test results
7. Test rollback mechanism if regression detected
8. Verify backup verification script works: `./scripts/verify-backup.sh TestPlugin 1.0.0`

Please respond with confirmation or any issues found before I proceed to Task 6."

---

### Task 6: Integration Testing & Documentation

**Description**: Test complete Phase 7 feedback loop with realistic scenario, update all documentation, verify success criteria.

**Required Reading**:
- `architecture/17-testing-strategy.md` (all sections) - Testing methodology
- `ROADMAP.md` (Phase 7 verification section) - Success criteria

**Dependencies**: Tasks 1-5 complete (all Phase 7 components implemented)

**Implementation Steps**:

1. **Comprehensive Workflow Test**:

   Execute complete feedback loop scenario:

   ```
   Scenario: Build ReverbPlugin → find issue → research → improve → document → validate → deploy

   1. Create ReverbPlugin with /implement
      - Should complete Stages 0-6 successfully

   2. Install via /install-plugin ReverbPlugin
      - Verify installed to system folders
      - Test in DAW (manual)

   3. Simulate finding issue: "Reverb is too CPU intensive"

   4. Research solution:
      - Run /research reverb CPU optimization
      - Verify Level 1 checks local troubleshooting/
      - Verify Level 2 searches Context7 + forums
      - If needed, verify Level 3 spawns parallel research
      - Confirm structured report with recommendations

   5. Apply improvement:
      - Run /improve ReverbPlugin - optimize reverb algorithm
      - Verify Phase 0.5 investigation runs
      - Verify Phase 0.9 backup verification
      - Verify implementation applies optimization
      - Verify Phase 5.5 regression tests run
      - Verify enhanced changelog generated

   6. Document solution:
      - Solution should auto-trigger troubleshooting-docs capture
      - Verify file created in troubleshooting/by-plugin/ReverbPlugin/
      - Verify symlink in troubleshooting/by-symptom/performance/
      - Verify YAML frontmatter validated

   7. Validate design (if mockup exists):
      - Run /sync-design ReverbPlugin
      - Verify drift detection (if any)
      - Verify decision menu handles findings

   8. Deploy new version:
      - Verify plugin-lifecycle installs v1.1.0
      - Verify old v1.0.0 removed from system folders
      - Verify caches cleared
      - Test in DAW (manual)

   9. Optional uninstall test:
      - Run /uninstall ReverbPlugin
      - Verify removed from system folders
      - Verify PLUGINS.md status updated
   ```

2. **Update CLAUDE.md** with complete Phase 7 navigation:

   ```markdown
   ## Phase 7 Components (Polish & Enhancement)

   ### Skills
   - **plugin-lifecycle** (`.claude/skills/plugin-lifecycle/`) - Installation/uninstallation management
   - **design-sync** (`.claude/skills/design-sync/`) - Mockup ↔ brief validation
   - **deep-research** (`.claude/skills/deep-research/`) - Multi-level problem investigation
   - **troubleshooting-docs** (`.claude/skills/troubleshooting-docs/`) - Knowledge base capture
   - **plugin-improve** (`.claude/skills/plugin-improve/`) - Version management with regression testing (enhanced)

   ### Commands
   - `/install-plugin [Name]` - Install to system folders
   - `/uninstall [Name]` - Remove from system folders (NEW)
   - `/sync-design [Name]` - Validate design alignment (NEW)
   - `/research [topic]` - Deep investigation (NEW)
   - `/doc-fix` - Document solved problems (NEW)
   - `/improve [Name]` - Fix bugs or add features (enhanced)

   ### Knowledge Base
   - `troubleshooting/by-plugin/` - Solutions organized by plugin
   - `troubleshooting/by-symptom/` - Solutions organized by symptom
   - `troubleshooting/patterns/` - Common patterns and solutions

   ### Scripts
   - `scripts/build-and-install.sh` - Build automation (supports --uninstall)
   - `scripts/verify-backup.sh` - Backup integrity verification (NEW)

   ## Feedback Loop

   The complete improvement cycle:
   ```
   Build → Test → Find Issue → Research → Improve → Document → Validate → Deploy
       ↑                                                                      ↓
       └──────────────────────────────────────────────────────────────────────┘
   ```

   - **deep-research** finds solutions (3-level graduated protocol)
   - **plugin-improve** applies changes (with regression testing)
   - **troubleshooting-docs** captures knowledge (dual-indexed)
   - **design-sync** prevents drift (validates contracts)
   - **plugin-lifecycle** manages deployment (install/uninstall)
   ```

3. **Create Phase 7 completion verification checklist**:

   ```bash
   # Create verification/phase-7-checklist.md
   mkdir -p verification
   cat > verification/phase-7-checklist.md << 'EOF'
   # Phase 7 Completion Checklist

   ## Core Deliverables

   ### plugin-lifecycle Enhancements
   - [ ] Uninstallation support implemented
   - [ ] `--uninstall` flag added to build-and-install.sh
   - [ ] System folder verification functional
   - [ ] Multi-format handling (VST3 + AU) works
   - [ ] PLUGINS.md state transitions correct (📦 → ✅)

   ### design-sync Skill
   - [ ] Skill file exists with frontmatter
   - [ ] Drift detection logic implemented
   - [ ] Decision menus present at all checkpoints
   - [ ] Integration with ui-mockup Phase 4.5
   - [ ] Contract comparison (brief ↔ parameter-spec) works
   - [ ] Evolution documentation updates brief

   ### deep-research Skill
   - [ ] 3-level graduated protocol implemented
   - [ ] Level 1: Local docs + Context7
   - [ ] Level 2: Forums + GitHub
   - [ ] Level 3: Parallel subagents + extended thinking
   - [ ] Structured report format (JSON template)
   - [ ] Integration with troubleshooter Level 4
   - [ ] Integration with troubleshooting-docs capture

   ### troubleshooting-docs Skill
   - [ ] Dual-index file system (by-plugin + by-symptom)
   - [ ] YAML schema validation enforced
   - [ ] Auto-invoke triggers functional
   - [ ] Resolution template used
   - [ ] Cross-referencing works
   - [ ] Symlinks created correctly

   ### plugin-improve Enhancements
   - [ ] Regression testing (Phase 5.5) implemented
   - [ ] Enhanced changelog generation
   - [ ] Backup verification (Phase 0.9) functional
   - [ ] Rollback mechanism works
   - [ ] verify-backup.sh script created and executable

   ## Integration Tests

   - [ ] Complete feedback loop test passed (Build → Test → Research → Improve → Document → Deploy)
   - [ ] plugin-lifecycle uninstall test passed
   - [ ] design-sync drift detection test passed
   - [ ] deep-research Level 3 parallel investigation test passed
   - [ ] troubleshooting-docs dual-indexing test passed
   - [ ] plugin-improve regression detection test passed

   ## Documentation

   - [ ] CLAUDE.md updated with Phase 7 components
   - [ ] All 4 new skills have SKILL.md with frontmatter
   - [ ] All new commands have .md files
   - [ ] troubleshooting/ directory structure created
   - [ ] verification/phase-7-checklist.md created

   ## Success Criteria (from ROADMAP.md)

   - [ ] plugin-lifecycle handles complex installation scenarios
   - [ ] design-sync validates mockup ↔ brief alignment
   - [ ] deep-research performs parallel investigation
   - [ ] troubleshooting-docs captures resolutions
   - [ ] plugin-improve handles all version management scenarios
   - [ ] `/improve TestPlugin` creates v1.1 with backup
   - [ ] Regression tests catch breaking changes
   - [ ] Knowledge base searchable and organized

   ## Architectural Alignment

   - [ ] All 4 new skills follow Anthropic pattern (SKILL.md, references/, assets/)
   - [ ] Interactive decision menus at all checkpoints
   - [ ] Progressive disclosure (features discovered through use)
   - [ ] Contracts referenced where relevant (design-sync)
   - [ ] State machine transitions respected
   - [ ] Model selection appropriate (Opus for deep-research L3)
   - [ ] Error recovery presents 4 options

   ## Performance Budgets

   - [ ] plugin-lifecycle uninstall: < 3 min
   - [ ] design-sync validation: < 5 min
   - [ ] deep-research Level 1: < 10 min
   - [ ] deep-research Level 2: < 20 min
   - [ ] deep-research Level 3: < 65 min
   - [ ] troubleshooting-docs capture: < 3 min
   - [ ] plugin-improve regression tests: < 10 min

   ---

   **Phase 7 Status:** [COMPLETE / IN PROGRESS / BLOCKED]
   **Completion Date:** [YYYY-MM-DD]
   **Verified By:** [Name]
   EOF
   ```

4. **Update ROADMAP.md** Phase 7 status:

   Edit ROADMAP.md and update verification checkboxes:
   ```markdown
   **Verification:**

   - [x] plugin-lifecycle handles complex installation scenarios
   - [x] design-sync validates mockup ↔ brief alignment
   - [x] deep-research performs parallel investigation
   - [x] troubleshooting-docs captures resolutions
   - [x] plugin-improve handles all version management scenarios
   - [x] `/improve TestPlugin` creates v1.1 with backup
   - [x] Regression tests catch breaking changes
   - [x] Knowledge base searchable and organized

   **Current Status:**

   - ✅ Phase 7: Complete (2025-11-10)
   ```

5. **Create Phase 7 completion summary**:

   ```bash
   # Create PHASE7-SUMMARY.md
   cat > PHASE7-SUMMARY.md << 'EOF'
   # Phase 7: Polish & Enhancement - Completion Summary

   **Completion Date:** 2025-11-10
   **Phase Duration:** [Actual time]
   **Total Components:** 5 (plugin-lifecycle enhancements + 4 new skills)

   ## What Was Built

   Phase 7 completed the Plugin Freedom System feedback loop, enabling continuous plugin improvement through:

   ### 1. plugin-lifecycle Enhancements
   - ✅ Uninstallation support with cache clearing
   - ✅ System folder verification
   - ✅ Multi-format handling (VST3 + AU)
   - ✅ `--uninstall` flag in build-and-install.sh

   ### 2. design-sync Skill
   - ✅ Mockup ↔ creative brief validation
   - ✅ Drift detection (quantitative + semantic)
   - ✅ Evolution documentation
   - ✅ Integration with ui-mockup Phase 4.5

   ### 3. deep-research Skill
   - ✅ 3-level graduated research protocol
   - ✅ Level 1: Local docs + Context7 (5-10 min)
   - ✅ Level 2: Forums + GitHub (15-30 min)
   - ✅ Level 3: Parallel subagents + Opus + extended thinking (30-60 min)
   - ✅ Structured report format with recommendations

   ### 4. troubleshooting-docs Skill
   - ✅ Dual-index knowledge base (by-plugin + by-symptom)
   - ✅ YAML schema validation
   - ✅ Auto-invoke triggers
   - ✅ Cross-referencing

   ### 5. plugin-improve Enhancements
   - ✅ Regression testing (Phase 5.5)
   - ✅ Enhanced changelog generation (technical details + migration notes)
   - ✅ Backup verification (Phase 0.9)
   - ✅ Rollback mechanism
   - ✅ verify-backup.sh script

   ## The Complete Feedback Loop

   ```
   Build → Test → Find Issue → Research → Improve → Document → Validate → Deploy
       ↑                                                                      ↓
       └──────────────────────────────────────────────────────────────────────┘
   ```

   **How it works:**

   1. **Build** - Create plugin with `/implement`
   2. **Test** - Automated tests + manual DAW testing
   3. **Find Issue** - User discovers problem during use
   4. **Research** - `/research [problem]` investigates solution (3-level protocol)
   5. **Improve** - `/improve [Plugin]` applies fix with regression testing
   6. **Document** - `/doc-fix` captures solution in knowledge base
   7. **Validate** - `/sync-design` ensures design integrity
   8. **Deploy** - `/install-plugin` deploys new version
   9. **Repeat** - Knowledge compounds, plugins improve continuously

   ## Key Innovations

   ### Graduated Research Protocol
   Fast → comprehensive as needed. Most problems solved at Level 1 (5 min), complex cases escalate to Level 3 parallel investigation.

   ### Dual-Index Knowledge Base
   Find solutions by plugin OR symptom. Future research (Level 1) searches local docs first - solutions get faster over time.

   ### Regression Testing
   Automatically detects breaking changes. Compare v1.0 baseline to v1.1, catch issues before deployment.

   ### Design-Contract Validation
   Prevents drift between vision (brief) and reality (mockup). Catches misalignment before implementation wastes time.

   ## System Statistics

   **Total Implementation Time:** ~14.5 hours (~2 days)

   **Component Breakdown:**
   - `/uninstall` command: 0.5 hours (create entry point to existing functionality)
   - troubleshooting-docs: 2 hours
   - deep-research: 4 hours
   - design-sync: 3 hours
   - plugin-improve: 3 hours
   - Integration testing: 2 hours

   **Files Created/Modified:**
   - New skills: 3 (troubleshooting-docs, deep-research, design-sync)
   - Enhanced skills: 1 (plugin-improve)
   - New commands: 3 (uninstall, sync-design, research)
   - Updated commands: 1 (doc-fix - placeholder → functional)
   - New scripts: 1 (verify-backup.sh)
   - Updated documentation: CLAUDE.md, ROADMAP.md

   ## What's Next

   The Plugin Freedom System is now **production-ready** for continuous plugin development and improvement.

   **Recommended first project:**
   Build a real plugin end-to-end using the complete system:
   1. `/dream` - Explore plugin idea
   2. `/implement` - Build through 7 stages
   3. Use it, find issues
   4. `/research` + `/improve` iteratively
   5. Build knowledge base organically

   **Future enhancements (not Phase 7 scope):**
   - Metrics/analytics system (track improvement velocity)
   - User feedback collection workflow
   - A/B testing mechanism (compare improvement approaches)
   - Proactive improvement triggers (automated code quality audits)
   - Community knowledge sharing (export/import troubleshooting docs)

   ## Success Metrics

   Phase 7 is successful if:
   - ✅ Users can iterate on plugins without fear (backups + rollback)
   - ✅ Solutions get faster over time (knowledge base compounds)
   - ✅ Complex problems are solvable (deep-research finds answers)
   - ✅ Quality is maintained (regression testing catches breaks)
   - ✅ Design integrity is preserved (design-sync validates contracts)

   **ALL SUCCESS METRICS: ACHIEVED** ✅

   ---

   **The Plugin Freedom System is complete.**

   From idea (`/dream`) to deployed plugin (`/install-plugin`) to continuous improvement (`/improve` + `/research` + `/doc-fix`) - the entire lifecycle is now supported with professional tooling.

   **Build great plugins. Iterate fearlessly. Learn continuously.**
   EOF
   ```

**Expected Output**:
- Complete feedback loop tested and verified
- `CLAUDE.md` updated with Phase 7 navigation
- `verification/phase-7-checklist.md` created
- `ROADMAP.md` updated with completion status
- `PHASE7-SUMMARY.md` created

**Verification**:

**Automated:**
```bash
# Test all Phase 7 components exist
test -f .claude/skills/plugin-lifecycle/SKILL.md && \
test -f .claude/skills/design-sync/SKILL.md && \
test -f .claude/skills/deep-research/SKILL.md && \
test -f .claude/skills/troubleshooting-docs/SKILL.md && \
test -f .claude/skills/plugin-improve/SKILL.md && \
test -d troubleshooting/by-plugin && \
test -d troubleshooting/by-symptom && \
test -x scripts/verify-backup.sh && \
echo "✅ All Phase 7 components exist"

# Test documentation updated
grep -q "Phase 7" CLAUDE.md && \
grep -q "deep-research" CLAUDE.md && \
grep -q "troubleshooting-docs" CLAUDE.md && \
echo "✅ CLAUDE.md updated"

# Test verification checklist
test -f verification/phase-7-checklist.md && echo "✅ Verification checklist exists"

# Test summary
test -f PHASE7-SUMMARY.md && echo "✅ Phase 7 summary exists"
```

**Manual:** STOP AND ASK LEX: "I've completed Phase 7 implementation and integration testing. Please perform final verification:

1. **Feedback Loop Test:** Run the complete scenario:
   - `/implement ReverbPlugin` (create test plugin)
   - `/install-plugin ReverbPlugin`
   - Simulate issue discovery
   - `/research reverb CPU optimization`
   - `/improve ReverbPlugin - optimize algorithm`
   - Verify regression tests run
   - Verify troubleshooting-docs captures solution
   - `/sync-design ReverbPlugin` (if mockup exists)
   - Verify v1.1 deployed successfully

2. **Component Verification:**
   - Test `/uninstall` removes plugin from system folders
   - Test `/sync-design` detects drift correctly
   - Test `/research` escalates through levels
   - Test `/doc-fix` creates dual-indexed docs
   - Test regression detection catches breaking changes

3. **Documentation Review:**
   - Review `verification/phase-7-checklist.md` - mark items complete
   - Review `PHASE7-SUMMARY.md` - verify accuracy
   - Review `CLAUDE.md` - confirm navigation is clear

4. **Success Criteria:**
   - Can you iterate on a plugin without fear? (backups + rollback)
   - Do solutions get captured for future reference? (knowledge base)
   - Can complex problems be researched? (3-level protocol)
   - Are regressions caught automatically? (testing integration)
   - Is design integrity validated? (design-sync)

Please respond with:
- Confirmation that all tests pass
- Any issues or gaps found
- Approval to mark Phase 7 as COMPLETE in ROADMAP.md

This is the final verification gate for Phase 7."

---

## Comprehensive Verification Criteria

### Automated Tests

```bash
# Test 1: plugin-lifecycle uninstall
echo "Testing plugin-lifecycle uninstall..."
# Build and install test plugin
cd plugins/TestPlugin
../../scripts/build-and-install.sh
# Verify installed
test -d ~/Library/Audio/Plug-Ins/VST3/TestPlugin.vst3 && echo "✅ Installed"
# Uninstall
../../scripts/build-and-install.sh --uninstall TestPlugin
# Verify removed
! test -d ~/Library/Audio/Plug-Ins/VST3/TestPlugin.vst3 && echo "✅ Uninstalled"

# Test 2: troubleshooting-docs dual-indexing
echo "Testing troubleshooting-docs dual-indexing..."
# Create test doc
PLUGIN="TestPlugin"
SYMPTOM="test-symptom"
CATEGORY="build-failures"
FILE="${SYMPTOM}-${PLUGIN}-20251110.md"
REAL_FILE="troubleshooting/by-plugin/${PLUGIN}/${CATEGORY}/${FILE}"
SYMLINK="troubleshooting/by-symptom/${CATEGORY}/${FILE}"
# Verify both paths exist
test -f "$REAL_FILE" && test -L "$SYMLINK" && echo "✅ Dual-index exists"

# Test 3: Regression test integration
echo "Testing regression test integration..."
grep -q "Phase 5.5: Regression Testing" .claude/skills/plugin-improve/SKILL.md && echo "✅ Regression testing integrated"

# Test 4: Enhanced changelog format
echo "Testing enhanced changelog format..."
grep -q "### Technical" .claude/skills/plugin-improve/SKILL.md && echo "✅ Enhanced changelog implemented"

# Test 5: Backup verification script
echo "Testing backup verification script..."
test -x scripts/verify-backup.sh && echo "✅ Backup script executable"
./scripts/verify-backup.sh TestPlugin 1.0.0 && echo "✅ Backup verification works"

# Test 6: design-sync skill exists
echo "Testing design-sync skill..."
test -f .claude/skills/design-sync/SKILL.md && echo "✅ design-sync exists"
grep -q "drift detection" .claude/skills/design-sync/references/drift-detection.md && echo "✅ Drift detection documented"

# Test 7: deep-research skill exists
echo "Testing deep-research skill..."
test -f .claude/skills/deep-research/SKILL.md && echo "✅ deep-research exists"
grep -q "Level 3: Deep Research" .claude/skills/deep-research/references/research-protocol.md && echo "✅ 3-level protocol documented"

# Test 8: All commands exist
echo "Testing slash commands..."
test -f .claude/commands/sync-design.md && echo "✅ /sync-design command exists"
test -f .claude/commands/research.md && echo "✅ /research command exists"
test -f .claude/commands/doc-fix.md && echo "✅ /doc-fix command exists"
```

### Manual Verification Checklist

#### plugin-lifecycle
- [ ] Can install plugin to system folders (`/install-plugin TestPlugin`)
- [ ] Can uninstall plugin from system folders (`--uninstall` flag)
- [ ] Uninstall clears Ableton cache
- [ ] Uninstall clears Logic cache (AudioComponentRegistrar restart)
- [ ] Verification checks timestamps < 60s
- [ ] PLUGINS.md status updates correctly (📦 → ✅)

#### design-sync
- [ ] Detects parameter count mismatch (brief: 8, mockup: 12)
- [ ] Detects visual style divergence (semantic validation)
- [ ] Detects missing features from brief
- [ ] Categorizes drift correctly (acceptable / attention / critical)
- [ ] Updates brief's Evolution section when user approves
- [ ] Integrates with ui-mockup Phase 4.5 menu
- [ ] Logs overrides to `.validator-overrides.yaml`

#### deep-research
- [ ] Level 1 searches local troubleshooting/ docs
- [ ] Level 1 queries Context7 JUCE documentation
- [ ] Level 2 searches JUCE forums
- [ ] Level 2 searches GitHub issues
- [ ] Level 3 spawns parallel subagents (Task tool)
- [ ] Level 3 uses Opus model + extended thinking
- [ ] Returns structured report (matches template)
- [ ] Decision menu offers Apply / Review / Continue deeper / Document
- [ ] Integrates with troubleshooter Level 4
- [ ] "Document findings" invokes troubleshooting-docs

#### troubleshooting-docs
- [ ] Auto-invokes after "that worked" / "it's fixed"
- [ ] Validates YAML frontmatter (blocks if invalid)
- [ ] Creates file in `troubleshooting/by-plugin/[Plugin]/[category]/`
- [ ] Creates symlink in `troubleshooting/by-symptom/[category]/`
- [ ] Cross-references similar issues
- [ ] Uses resolution template format
- [ ] Decision menu offers: Continue / Link related / Update patterns / View doc

#### plugin-improve Enhancements
- [ ] Phase 0.9 verifies/creates backup before changes
- [ ] Phase 5.5 runs regression tests (if plugin-testing exists)
- [ ] Regression tests compare baseline to current version
- [ ] Detects new test failures (regressions)
- [ ] Presents rollback option if regressions detected
- [ ] Rollback restores from backup successfully
- [ ] Enhanced changelog includes Technical section
- [ ] Enhanced changelog includes Migration Notes (for MAJOR)
- [ ] Enhanced changelog includes Testing results
- [ ] `verify-backup.sh` script works correctly

### File Existence Verification

```bash
# Verify all expected files exist
ls -la .claude/skills/plugin-lifecycle/SKILL.md
ls -la .claude/skills/design-sync/SKILL.md
ls -la .claude/skills/design-sync/references/drift-detection.md
ls -la .claude/skills/deep-research/SKILL.md
ls -la .claude/skills/deep-research/references/research-protocol.md
ls -la .claude/skills/deep-research/assets/report-template.json
ls -la .claude/skills/troubleshooting-docs/SKILL.md
ls -la .claude/skills/troubleshooting-docs/assets/resolution-template.md
ls -la .claude/skills/troubleshooting-docs/references/yaml-schema.md
ls -la .claude/skills/plugin-improve/SKILL.md
ls -la .claude/commands/sync-design.md
ls -la .claude/commands/research.md
ls -la .claude/commands/doc-fix.md
ls -la scripts/verify-backup.sh
ls -la troubleshooting/by-plugin/
ls -la troubleshooting/by-symptom/
ls -la troubleshooting/patterns/common-solutions.md
ls -la verification/phase-7-checklist.md
ls -la PHASE7-SUMMARY.md
```

### Integration Tests

**Test 1: Complete Feedback Loop**
```
1. `/implement SimpleGain` (Stages 0-6)
2. `/install-plugin SimpleGain`
3. Simulate issue: "Gain not smooth, clicks on changes"
4. `/research parameter smoothing`
   - Verify Level 1 searches local docs
   - Verify Level 2 finds Context7 solution
5. `/improve SimpleGain - add parameter smoothing`
   - Verify regression tests run
   - Verify enhanced changelog generated
6. Auto-invoke troubleshooting-docs
   - Verify dual-index created
7. `/sync-design SimpleGain` (if mockup)
8. Verify v1.1 installed successfully
```

**Test 2: Regression Detection**
```
1. Create TestPlugin v1.0 with 3 parameters
2. Verify baseline tests pass (3/3)
3. `/improve TestPlugin - remove GAIN parameter`
4. Verify regression detected (new failure: GAIN missing)
5. Verify rollback option presented
6. Execute rollback
7. Verify v1.0 restored successfully
```

**Test 3: Design Drift Detection**
```
1. Create creative brief (8 parameters, vintage aesthetic)
2. Create mockup (12 parameters, modern aesthetic)
3. `/sync-design TestPlugin`
4. Verify drift detected:
   - Parameter count mismatch
   - Visual style mismatch
5. Verify decision menu: Update mockup / Update brief / Continue anyway
6. Choose "Update brief"
7. Verify Evolution section added to brief
```

**Test 4: Deep Research Escalation**
```
1. `/research wavetable anti-aliasing`
2. Verify Level 1 completes (< 10 min)
3. Choose "Continue deeper"
4. Verify Level 2 completes (< 20 min)
5. Choose "Continue deeper"
6. Verify Level 3:
   - Spawns parallel subagents
   - Uses Opus model
   - Extended thinking enabled
   - Returns comprehensive report
7. Choose "Document findings"
8. Verify troubleshooting-docs captures solution
```

**Test 5: Knowledge Base Growth**
```
1. Document 3 different solutions
2. Verify 3 files in troubleshooting/by-symptom/
3. Run `/research [topic from documented solution]`
4. Verify Level 1 finds local doc immediately (< 2 min)
5. Confirm no escalation needed (fast path works)
```

### Success Criteria

Phase 7 is COMPLETE when:

1. ✅ **plugin-lifecycle handles complex installation scenarios**
   - Install, uninstall, verify all work
   - Multi-format (VST3 + AU) functional
   - Cache clearing automatic
   - State transitions correct

2. ✅ **design-sync validates mockup ↔ brief alignment**
   - Drift detection works (quantitative + semantic)
   - Decision menus guide resolution
   - Evolution documentation updates brief
   - Integration with ui-mockup Phase 4.5

3. ✅ **deep-research performs parallel investigation**
   - 3-level protocol functional
   - Level 3 spawns parallel subagents
   - Structured reports generated
   - Integration with troubleshooter

4. ✅ **troubleshooting-docs captures resolutions**
   - Dual-index file system works
   - YAML validation enforced
   - Auto-invoke triggers functional
   - Cross-referencing works

5. ✅ **plugin-improve handles all version management scenarios**
   - Regression testing catches breaking changes
   - Enhanced changelogs include technical details
   - Backup verification prevents data loss
   - Rollback mechanism works

6. ✅ **`/improve TestPlugin` creates v1.1 with backup**
   - Backup created/verified (Phase 0.9)
   - Changes applied successfully
   - Regression tests run (Phase 5.5)
   - Enhanced changelog generated
   - Git commit + tag created
   - v1.1 installed and verified

7. ✅ **Regression tests catch breaking changes**
   - Baseline vs current comparison works
   - New failures detected
   - Rollback option presented
   - User can choose to fix or rollback

8. ✅ **Knowledge base searchable and organized**
   - Dual-index (by-plugin + by-symptom) navigable
   - YAML frontmatter enables programmatic search
   - Cross-references link related issues
   - Pattern library captures common solutions

---

## Potential Issues & Mitigations

### Issue 1: deep-research Level 3 Context Limit

**Symptom:** Parallel subagent investigation exceeds context limits with large JUCE documentation

**Mitigation:**
- Extended thinking budget: 15,000 tokens (configurable)
- Timeout: 60 minutes (configurable)
- If exceeds: Return best answer based on current findings + warning
- Present decision menu: "Retry with higher budget" / "Continue with current findings" / "Other"

### Issue 2: troubleshooting-docs Symlink Issues on Windows

**Symptom:** Windows may not support symlinks without admin privileges

**Mitigation:**
- Detection: Check if `ln -s` succeeds
- Fallback: Duplicate file (not ideal but functional)
- Document in troubleshooting-docs references: "On Windows, files are duplicated instead of symlinked"
- Future: Consider junction points (Windows alternative to symlinks)

### Issue 3: Regression Test False Positives

**Symptom:** Tests fail due to environment differences (sample rate, buffer size) not actual regressions

**Mitigation:**
- Normalize test environment (same sample rate, buffer size)
- Allow tolerance in comparisons (audio output within ±0.001)
- Decision menu: "Investigate failure" / "Ignore (false positive)" / "Update baseline" / "Other"
- Log ignored failures to `.regression-overrides.yaml`

### Issue 4: design-sync Semantic Validation Ambiguity

**Symptom:** LLM may interpret design decisions differently than user intent

**Mitigation:**
- Always present findings as advisory (not blocking by default)
- User has final say via decision menu
- "Continue anyway (override)" option always available (except critical drift)
- Log all overrides to `.validator-overrides.yaml` for review

### Issue 5: Backup Storage Growth

**Symptom:** `backups/` directory grows large with many versions

**Mitigation:**
- Document retention policy in plugin-improve skill
- Suggestion: Keep last 3 versions + all major versions
- Provide cleanup script: `scripts/clean-old-backups.sh [PluginName] [keep-count]`
- Present decision menu after backup creation: "Clean old backups?" (if > 5 versions)

---

## Notes for Next Phase

**Phase 7 is the final phase** of the Plugin Freedom System roadmap. The system is now production-ready.

**Future Enhancements (outside roadmap scope):**

1. **Metrics & Analytics System**
   - Track improvement velocity (time from issue → fix → deploy)
   - Measure knowledge base hit rate (% problems solved at research Level 1)
   - Version release frequency
   - Regression detection rate

2. **User Feedback Collection Workflow**
   - Integrate issue tracking
   - Prioritization system (severity × frequency)
   - Route user reports to appropriate improvement workflow

3. **A/B Testing Mechanism**
   - Branch-based improvement testing
   - Side-by-side comparison tool
   - Automated regression detection between approaches

4. **Proactive Improvement Triggers**
   - Scheduled performance audits
   - Automated code quality checks
   - Dependency update notifications
   - JUCE version migration prompts

5. **Community Knowledge Sharing**
   - Export troubleshooting docs to shareable format
   - Import community solutions
   - Anonymize plugin-specific details
   - Contribution workflow

6. **Advanced WebView Features** (from Phase 6 future work)
   - WebView debugging tools (live reload, devtools)
   - Accessibility features (keyboard nav, screen readers)
   - Animation performance profiling

**Recommended Next Steps:**

1. **Build Real Plugins:** Use the complete system end-to-end with actual projects
2. **Organic Knowledge Growth:** Let troubleshooting/ populate naturally through real problem-solving
3. **Iterate on System:** Use `/improve` on the system itself (meta-improvement)
4. **Community Feedback:** Share with JUCE developers, gather feedback
5. **Documentation:** Create video tutorials, written guides for new users

**System Handoff:**

The Plugin Freedom System is now complete and ready for production use. All 7 phases implemented:

- ✅ Phase 0: Foundation & Contracts
- ✅ Phase 1: Discovery System
- ✅ Phase 2: Workflow Engine
- ✅ Phase 3: Implementation Subagents
- ✅ Phase 4: Build & Troubleshooting
- ✅ Phase 5: Validation System
- ✅ Phase 6: WebView UI System
- ✅ **Phase 7: Polish & Enhancement**

**From idea to deployed plugin to continuous improvement - the entire lifecycle is supported.**

**Build great plugins. Iterate fearlessly. Learn continuously.**

---

## Meta

**Document Version:** 1.1.0
**Phase:** 7 (Polish & Enhancement)
**Total Tasks:** 6
**Estimated Effort:** ~14.5 hours (~2 days)
**Prerequisites:** Phase 0-6 complete
**Success Criteria:** 8 (all testable and measurable)
**Revision:** Task 1 simplified (plugin-lifecycle uninstallation already exists, just needs command entry point)

**Created:** 2025-11-10
**Author:** Claude (via /prompt)
**Verified:** [Pending Lex confirmation]

**This plan is ready for implementation.**
