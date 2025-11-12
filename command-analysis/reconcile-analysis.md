# Command Analysis: reconcile

## Executive Summary
- Overall health: **Red** (Severely bloated, no enforcement structure, effectively a skill disguised as command)
- Critical issues: **6** (Missing frontmatter, inline implementation instead of skill routing, massive length, no XML enforcement)
- Optimization opportunities: **5** (Extract to skill, add frontmatter, enforce via XML, reduce duplication)
- Estimated context savings: **6,000+ tokens (95% reduction to ~300 token routing command)**

## Dimension Scores (1-5)
1. Structure Compliance: **1/5** (NO frontmatter - blocks /help and autocomplete)
2. Routing Clarity: **1/5** (No routing - implements entire reconciliation inline)
3. Instruction Clarity: **3/5** (Clear steps but buried in prose)
4. XML Organization: **1/5** (Zero XML usage, all prose)
5. Context Efficiency: **1/5** (409 lines - severely bloated, should be 50-100)
6. Claude-Optimized Language: **3/5** (Clear but verbose, needs imperative tightening)
7. System Integration: **4/5** (Good documentation of state files and workflows)
8. Precondition Enforcement: **1/5** (No preconditions or structural enforcement)

**Overall Score: 15/40 (RED - Critical issues block functionality)**

## Critical Issues (blockers for Claude comprehension)

### Issue #1: Missing YAML Frontmatter (Line 1)
**Severity:** CRITICAL
**Impact:** Command invisible to /help, autocomplete, and discovery system

**Current:**
```markdown
# /reconcile - Workflow State Reconciliation

Reconcile workflow state files to ensure all checkpoints are properly updated and committed. Use this command when switching between workflows or when you suspect state files are out of sync.
```

**Problem:** No YAML frontmatter means:
- Command doesn't appear in `/help` output
- No autocomplete support
- No argument hints for users
- Breaks discovery system

**Recommended Fix:**
```yaml
---
name: reconcile
description: Reconcile workflow state files to ensure all checkpoints are properly updated and committed
argument-hint: "[PluginName?] (optional - if omitted, analyzes current context)"
---

# /reconcile

When user runs `/reconcile [PluginName?]`, invoke the workflow-reconciliation skill.
```

### Issue #2: Inline Implementation Instead of Skill Routing (Lines 1-409)
**Severity:** CRITICAL
**Impact:** Violates fundamental command architecture, creates 409-line command (should be 50-100)

**Current:** Entire 409-line reconciliation implementation is inline in the command file.

**Problem:**
- Commands should route to skills, not implement logic directly
- 409 lines is 4-8x recommended command length
- No separation of concerns (routing vs implementation)
- Duplicates logic if reconciliation needed elsewhere
- Violates instructed routing pattern

**Recommended Fix:**
Create new skill `workflow-reconciliation` and route to it:

```markdown
---
name: reconcile
description: Reconcile workflow state files to ensure checkpoints are updated
argument-hint: "[PluginName?] (optional)"
---

# /reconcile

When user runs `/reconcile [PluginName?]`, invoke the workflow-reconciliation skill.

## Routing Logic

<routing_decision>
  <check condition="plugin_name_provided">
    IF $ARGUMENTS contains plugin name:
      Invoke workflow-reconciliation skill with plugin_name parameter
    ELSE:
      Invoke workflow-reconciliation skill in context-detection mode
      (skill will analyze current workflow context)
  </check>
</routing_decision>

## What This Does

Reconciliation ensures workflow state files are synchronized:
- `.continue-here.md` - Resume point with stage/phase/status
- `PLUGINS.md` - Plugin registry with status emoji
- Git status - Staged/unstaged/uncommitted changes
- Contract files - Required artifacts per workflow stage

The workflow-reconciliation skill:
1. Detects current workflow context
2. Applies workflow-specific reconciliation rules
3. Performs gap analysis (filesystem vs expected state)
4. Presents reconciliation report with proposed actions
5. Executes user's chosen reconciliation strategy

## Preconditions

None - reconciliation can be invoked at any point to check/fix state.
```

**Token savings:** ~6,000 tokens (move 380+ lines to skill)

### Issue #3: No Self-Assessment Structural Enforcement (Lines 11-21)
**Severity:** HIGH
**Impact:** Critical detection logic buried in prose, easy to skip

**Current:**
```markdown
## Step 1: Self-Assessment

First, I need to understand my current workflow context. Let me thoroughly analyze:

**Current Workflow Assessment:**
- **Workflow Name**: What workflow am I executing? (plugin-workflow, ui-mockup, design-sync, plugin-improve, plugin-ideation, etc.)
- **Stage/Phase**: What specific stage or phase am I at?
- **Last Completion Point**: What was the last significant work I completed?
- **Files Created/Modified**: What files have I generated or modified in this session?
- **Nested Workflow**: Am I in a nested workflow? If so, what's the parent workflow?
- **Plugin Name**: What plugin am I working on (if applicable)?
```

**Problem:**
- Self-assessment questions are suggestions, not enforced steps
- No structural requirement to complete assessment before proceeding
- Easy to skip under token pressure

**Recommended Fix (in workflow-reconciliation skill):**
```xml
<context_detection enforcement="blocking">
  <required_analysis>
    Detect current workflow context by analyzing:

    <detection_method priority="1" source=".continue-here.md">
      IF .continue-here.md exists in current plugin directory:
        - Extract YAML frontmatter (workflow, stage, status, phase)
        - This is authoritative source of workflow state
    </detection_method>

    <detection_method priority="2" source="PLUGINS.md">
      IF plugin name provided as argument:
        - Read PLUGINS.md entry for plugin
        - Extract status emoji (💡 Ideated, 🚧 Stage N, ✅ Working, 📦 Installed)
    </detection_method>

    <detection_method priority="3" source="filesystem_analysis">
      IF no handoff file found:
        - Analyze files created/modified in session
        - Infer workflow from file patterns:
          - .ideas/creative-brief.md → plugin-ideation
          - .ideas/mockups/v*-ui.html → ui-mockup
          - Source/*.cpp changes + CHANGELOG.md → plugin-improve
          - plugins/*/CMakeLists.txt → plugin-workflow (Stage 2+)
    </detection_method>
  </required_analysis>

  <validation>
    BEFORE proceeding to gap analysis:
    - MUST identify workflow name
    - MUST identify current stage/phase
    - MUST identify plugin name (if workflow is plugin-specific)

    IF unable to detect context:
      BLOCK with error: "Cannot determine workflow context. Please provide plugin name or run from plugin directory."
  </validation>
</context_detection>
```

### Issue #4: Reconciliation Rules Table Without Structural Enforcement (Lines 23-116)
**Severity:** HIGH
**Impact:** 93 lines of workflow-specific rules in prose, no enforcement, massive duplication

**Current:**
```markdown
## Step 2: Reconciliation Rules

Based on the workflow detected in Step 1, apply the appropriate reconciliation rules:

### plugin-workflow (Stages 0-6)

**Stage 0 (Research):**
- State files: `.continue-here.md`, `PLUGINS.md`
- Required files: `architecture.md`
- PLUGINS.md status: `🚧 Stage 0`
- Commit message: `docs({name}): Complete Stage 0 (Research) - DSP architecture documented`

**Stage 1 (Planning):**
- State files: `.continue-here.md`, `PLUGINS.md`
- Required files: `plan.md`
- PLUGINS.md status: `🚧 Stage 1`
- Commit message: `docs({name}): Complete Stage 1 (Planning) - implementation strategy defined`

[...90 more lines of similar rules...]
```

**Problem:**
- Massive duplication (each stage repeats state files, status pattern)
- Not machine-parseable - Claude must interpret prose
- Hard to maintain (updating commit format requires 10+ changes)
- No structural enforcement of rules
- Should be data structure, not prose

**Recommended Fix (extract to assets/reconciliation-rules.json):**
```json
{
  "plugin-workflow": {
    "stages": {
      "0": {
        "state_files": [".continue-here.md", "PLUGINS.md"],
        "required_files": ["architecture.md"],
        "plugins_md_status": "🚧 Stage 0",
        "commit_template": "docs({name}): Complete Stage 0 (Research) - DSP architecture documented"
      },
      "1": {
        "state_files": [".continue-here.md", "PLUGINS.md"],
        "required_files": ["plan.md"],
        "plugins_md_status": "🚧 Stage 1",
        "commit_template": "docs({name}): Complete Stage 1 (Planning) - implementation strategy defined"
      },
      "2": {
        "state_files": [".continue-here.md", "PLUGINS.md"],
        "required_files": ["CMakeLists.txt", "PluginProcessor.h", "PluginProcessor.cpp"],
        "plugins_md_status": "🚧 Stage 2",
        "commit_template": "feat({name}): Complete Stage 2 (Foundation) - build system operational"
      }
    }
  },
  "ui-mockup": {
    "phases": {
      "4": {
        "state_files": [".continue-here.md"],
        "required_files": ["v{n}-ui.yaml", "v{n}-ui-test.html"],
        "commit_template": "feat({name}): UI mockup v{n} design iteration"
      },
      "6": {
        "state_files": [".continue-here.md", "parameter-spec.md", "PLUGINS.md"],
        "required_files": [
          "v{n}-ui.html",
          "v{n}-PluginEditor.h",
          "v{n}-PluginEditor.cpp",
          "v{n}-CMakeLists.txt",
          "v{n}-integration-checklist.md"
        ],
        "commit_template": "feat({name}): Complete UI mockup v{n} with implementation files"
      }
    }
  }
}
```

Then in skill:
```xml
<reconciliation_rules>
  <rule_loading>
    1. Load assets/reconciliation-rules.json
    2. Lookup workflow name from context detection
    3. Lookup stage/phase from context detection
    4. Extract reconciliation rule for current workflow + stage/phase
  </rule_loading>

  <rule_application>
    For current workflow and stage, validate:
    - All state_files exist and are current
    - All required_files exist
    - PLUGINS.md status matches expected
    - Git commit exists for this stage completion
  </rule_application>
</reconciliation_rules>
```

**Token savings:** ~1,500 tokens (93 lines → 10 line summary + JSON asset)

### Issue #5: Gap Analysis Without Structured Validation (Lines 118-136)
**Severity:** MEDIUM
**Impact:** Validation logic described but not enforced

**Current:**
```markdown
## Step 3: Gap Analysis

Now check the current filesystem state against the rules from Step 2:

**File Existence Check:**
- Does `.continue-here.md` exist?
- Does `PLUGINS.md` have an entry for this plugin?
- Do all required artifacts exist?

**Content Currency Check:**
- Read `.continue-here.md` frontmatter - does stage/phase/status match current state?
- Read `PLUGINS.md` entry - does status match current workflow stage?
- If parameter-spec.md exists, is it locked and current?

**Git Status Check:**
- Run `git status` to identify:
  - Unstaged changes
  - Staged but uncommitted changes
  - Untracked files that should be added
```

**Problem:**
- Checklist format suggests optional items
- No enforcement that checks must complete before report
- No structured data format for gap results

**Recommended Fix:**
```xml
<gap_analysis enforcement="blocking">
  <validation_sequence enforce_order="true">
    <check order="1" category="file_existence" required="true">
      For each required_file in reconciliation rule:
        - Check file exists at expected path
        - Record as GAP if missing
    </check>

    <check order="2" category="state_file_currency" required="true">
      Read .continue-here.md YAML frontmatter:
        - Extract: stage, phase, status, workflow, last_updated
        - Compare to detected context
        - Record as GAP if mismatch

      Read PLUGINS.md entry for plugin:
        - Extract status emoji
        - Compare to expected status from reconciliation rule
        - Record as GAP if mismatch
    </check>

    <check order="3" category="git_status" required="true">
      Run git status:
        - Identify unstaged changes (modified, deleted)
        - Identify staged but uncommitted changes
        - Identify untracked files matching required_files pattern
        - Record as GAP if uncommitted changes exist
    </check>
  </validation_sequence>

  <gap_aggregation>
    Aggregate all gaps into structured report:
    {
      "file_existence_gaps": [...],
      "state_currency_gaps": [...],
      "git_status_gaps": [...]
    }
  </gap_aggregation>

  <validation>
    MUST complete all 3 check categories before generating report.
    IF any check fails to execute: BLOCK with error.
  </validation>
</gap_analysis>
```

### Issue #6: No Decision Menu After Report (Lines 138-221)
**Severity:** MEDIUM
**Impact:** Violates checkpoint protocol (should present menu and WAIT)

**Current:**
```markdown
## Step 4: Reconciliation Report

Present findings in this format:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Reconciliation Report for [PluginName]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current Workflow: [workflow] ([stage/phase] - [status])

State File Analysis:

[For each state file, show:]
✓ [filename]
  Status: UP TO DATE

OR

✗ [filename]
  Current: [current state/content]
  Expected: [expected state/content]
  Action: [CREATE/UPDATE/DELETE]

Git Status:

✓ Staged: [list files]
✗ Unstaged: [list files]
✗ Untracked: [list files]
✗ Uncommitted: [summary]

Proposed Actions:

1. [Specific action to take]
2. [Specific action to take]
3. [etc.]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

What should I do?
1. Fix everything automatically - Execute all updates and commit
2. Show me the diffs first - Preview file changes before committing
3. Fix files only (no commit) - Update state files but don't stage/commit
4. Update .continue-here.md only - Minimal checkpoint
5. Skip reconciliation - I'll handle it manually
6. Other

Choose (1-6): _
```
```

**Problem:**
- Decision menu is embedded in report format
- Not using checkpoint protocol pattern
- No progressive disclosure (discovery options missing)
- Menu options are hardcoded, not context-appropriate

**Recommended Fix:**
```xml
<reconciliation_report>
  <report_generation>
    1. Aggregate gap analysis results
    2. Generate proposed actions based on gaps found
    3. Format report with visual dividers
    4. Display report to user
  </report_generation>

  <checkpoint_protocol>
    After displaying report, MUST present decision menu and WAIT.

    <decision_menu format="inline_numbered_list" forbidden_tool="AskUserQuestion">
      Present options based on gap severity:

      <menu_options category="no_gaps_found">
        1. All good - return to workflow (recommended)
        2. Show me the state files anyway
        3. Force reconciliation (update timestamps)
        4. Other
      </menu_options>

      <menu_options category="minor_gaps" condition="only_timestamp_drift">
        1. Fix automatically - Update timestamps and commit
        2. Show me the diffs first
        3. Update .continue-here.md only
        4. Skip reconciliation
        5. Other
      </menu_options>

      <menu_options category="major_gaps" condition="missing_files_or_uncommitted">
        1. Fix everything automatically - Create/update files and commit
        2. Show me the diffs first - Preview before committing
        3. Fix files only (no commit) - Update files but don't commit
        4. Update .continue-here.md only - Minimal checkpoint
        5. Skip reconciliation - I'll handle manually
        6. Other
      </menu_options>

      <discovery_option>
        If workflow is plugin-workflow AND stage >= 4:
          Add option: "Design sync ← Validate mockup matches brief"
      </discovery_option>
    </decision_menu>

    <blocking_wait>
      WAIT for user response - NEVER auto-proceed.
    </blocking_wait>
  </checkpoint_protocol>
</reconciliation_report>
```

## Optimization Opportunities

### Optimization #1: Extract to Skill (Lines 1-409)
**Potential savings:** 6,000+ tokens (95% reduction)
**Current:** 409-line command implementing entire reconciliation system
**Recommended:** 50-line routing command + new workflow-reconciliation skill

**Why this is critical:**
1. **Architectural violation:** Commands route to skills, they don't implement logic
2. **Reusability:** Reconciliation logic should be available to other skills (plugin-workflow, ui-mockup, etc.)
3. **Maintenance:** Skill updates don't require command changes
4. **Discovery:** Skills appear in skill list, commands don't
5. **Context efficiency:** Command only loads when invoked, skill only loads when routed to

**Recommended structure:**

**Command file (.claude/commands/reconcile.md) - 50 lines:**
```markdown
---
name: reconcile
description: Reconcile workflow state files to ensure checkpoints are updated
argument-hint: "[PluginName?] (optional)"
---

# /reconcile

When user runs `/reconcile [PluginName?]`, invoke the workflow-reconciliation skill.

## Routing Logic

<routing_decision>
  <check condition="plugin_name_provided">
    IF $ARGUMENTS contains plugin name:
      Invoke workflow-reconciliation skill with plugin_name parameter
    ELSE:
      Invoke workflow-reconciliation skill in context-detection mode
  </check>
</routing_decision>

## What This Does

Reconciliation synchronizes workflow state files:
- `.continue-here.md` - Resume point
- `PLUGINS.md` - Plugin registry
- Git status - Staged/unstaged changes
- Contract files - Required artifacts

The workflow-reconciliation skill performs:
1. Context detection (identify workflow, stage, plugin)
2. Rule application (load workflow-specific expectations)
3. Gap analysis (compare filesystem vs expected state)
4. Report generation (show what's out of sync)
5. Remediation execution (fix based on user choice)

## Preconditions

None - can be invoked anytime to check/fix state.
```

**Skill file (.claude/skills/workflow-reconciliation/SKILL.md) - 250 lines:**
```markdown
---
name: workflow-reconciliation
description: Reconcile workflow state files to ensure checkpoints are properly updated
---

# workflow-reconciliation

Detect current workflow context, validate state file currency, and remediate gaps to prevent checkpoint amnesia.

## When to Invoke This Skill

- User explicitly runs `/reconcile [PluginName?]`
- Other skills detect state drift (plugin-workflow, ui-mockup)
- After subagent completion if handoff file missing
- When switching between workflows

## Core Responsibilities

<orchestration_pattern>
  This skill follows a 5-phase pattern:

  1. Context Detection → Identify workflow, stage, plugin
  2. Rule Loading → Load expected state for workflow+stage
  3. Gap Analysis → Compare filesystem vs expected state
  4. Report Generation → Show gaps with proposed fixes
  5. Remediation → Execute user's chosen fix strategy
</orchestration_pattern>

## Phase 1: Context Detection

<context_detection enforcement="blocking">
  [XML structure from Issue #3 above]
</context_detection>

## Phase 2: Rule Loading

<reconciliation_rules>
  [XML structure from Issue #4 above]
</reconciliation_rules>

## Phase 3: Gap Analysis

<gap_analysis enforcement="blocking">
  [XML structure from Issue #5 above]
</gap_analysis>

## Phase 4: Report Generation

<reconciliation_report>
  [XML structure from Issue #6 above]
</reconciliation_report>

## Phase 5: Remediation Execution

<remediation_strategies>
  Based on user's menu choice, execute appropriate strategy:

  <strategy id="fix_everything_automatically">
    1. Update all state files with current context
    2. Create missing required files (if possible)
    3. Stage all changes: git add [files]
    4. Commit with workflow-appropriate message
    5. Confirm completion
  </strategy>

  <strategy id="show_diffs_first">
    1. For each file to be updated: show current vs new content
    2. Highlight differences
    3. Return to decision menu
  </strategy>

  <strategy id="fix_files_only">
    1. Update state files (.continue-here.md, PLUGINS.md)
    2. Do NOT stage or commit
    3. Confirm files updated
  </strategy>

  <strategy id="update_handoff_only">
    1. Update .continue-here.md with current context
    2. Leave other files unchanged
    3. Confirm minimal checkpoint complete
  </strategy>

  <strategy id="skip_reconciliation">
    1. Exit without changes
    2. Warn user to reconcile manually before workflow resume
  </strategy>
</remediation_strategies>

## Reference Files

- [reconciliation-rules.json](assets/reconciliation-rules.json) - Workflow-specific expectations
- [handoff-formats.md](references/handoff-formats.md) - .continue-here.md structure per workflow
- [commit-templates.md](references/commit-templates.md) - Conventional commit formats

## Success Criteria

Reconciliation succeeds when:
- All state files reflect current workflow state
- Git status shows no uncommitted workflow artifacts
- Workflow can resume without context loss
- No checkpoint amnesia at workflow boundaries
```

### Optimization #2: Extract Reconciliation Rules to JSON (Lines 23-116)
**Potential savings:** 1,500 tokens
**Current:** 93 lines of prose describing rules per workflow/stage
**Recommended:** 10-line summary + JSON asset

Already covered in Issue #4 above. Key benefit is data-driven rules instead of hardcoded prose.

### Optimization #3: Extract Examples to assets/ (Lines 285-396)
**Potential savings:** 1,800 tokens
**Current:** 111 lines of example reconciliation reports
**Recommended:** Extract to assets/reconciliation-examples.md

**Why extract:**
- Examples are reference material, not execution instructions
- Only needed when user wants to understand output format
- Progressive disclosure - load only if user asks "what does reconciliation output look like?"

**After extraction:**
```markdown
## Example Usage

For detailed examples of reconciliation reports, see:
- [Example 1: After UI Mockup Completion](assets/reconciliation-examples.md#example-1)
- [Example 2: After Subagent Completion](assets/reconciliation-examples.md#example-2)

Each example shows:
- Detected workflow context
- Gap analysis results
- Proposed actions
- Decision menu with user choice
```

### Optimization #4: Extract Handoff Format to references/ (Lines 223-254)
**Potential savings:** 500 tokens
**Current:** 31 lines of .continue-here.md format specification
**Recommended:** Extract to references/handoff-formats.md

**Why extract:**
- Format spec is reference material
- Might be needed by multiple skills (plugin-workflow, ui-mockup, context-resume)
- Only loaded when actually writing handoff file

**After extraction:**
```markdown
## Handoff File Format

See [references/handoff-formats.md](references/handoff-formats.md) for complete .continue-here.md structure.

Key fields:
- `plugin` - Plugin name
- `stage` or `phase` - Current position in workflow
- `status` - Workflow-specific status
- `workflow` - Workflow name
- `last_updated` - ISO 8601 timestamp
```

### Optimization #5: Extract PLUGINS.md Update Patterns to references/ (Lines 256-268)
**Potential savings:** 200 tokens
**Current:** 12 lines of PLUGINS.md update patterns
**Recommended:** Extract to references/plugins-md-operations.md

**Why extract:**
- Shared logic with plugin-workflow skill
- Single source of truth for PLUGINS.md operations
- Reference material, not execution instructions

## Implementation Priority

### 1. IMMEDIATE: Add YAML Frontmatter (Issue #1)
**Priority:** CRITICAL
**Effort:** 2 minutes
**Impact:** Makes command discoverable via /help and autocomplete

Without frontmatter, command is invisible to users. This is a showstopper.

```yaml
---
name: reconcile
description: Reconcile workflow state files to ensure checkpoints are updated
argument-hint: "[PluginName?] (optional)"
---
```

### 2. IMMEDIATE: Extract to Skill (Issue #2 + Optimization #1)
**Priority:** CRITICAL
**Effort:** 90 minutes
**Impact:** Fixes architectural violation, enables reusability, saves 6,000+ tokens

This is the most important fix. Commands must route to skills, not implement logic inline.

**Steps:**
1. Create `.claude/skills/workflow-reconciliation/` directory
2. Create `SKILL.md` with 5-phase orchestration pattern
3. Create `assets/reconciliation-rules.json` with workflow-specific rules
4. Create `references/handoff-formats.md` with .continue-here.md specs
5. Create `references/commit-templates.md` with conventional commit formats
6. Create `assets/reconciliation-examples.md` with example reports
7. Rewrite `reconcile.md` command to 50-line routing layer
8. Test by running `/reconcile` and verifying behavior

### 3. HIGH: Add XML Enforcement to Skill (Issues #3-6)
**Priority:** HIGH
**Effort:** 45 minutes
**Impact:** Structural enforcement prevents Claude from skipping critical steps

**What to add:**
- `<context_detection enforcement="blocking">` wrapper (Issue #3)
- `<reconciliation_rules>` with JSON loading (Issue #4)
- `<gap_analysis enforcement="blocking">` wrapper (Issue #5)
- `<checkpoint_protocol>` with decision menu (Issue #6)

### 4. MEDIUM: Extract Reference Materials (Optimizations #3-5)
**Priority:** MEDIUM
**Effort:** 20 minutes
**Impact:** Progressive disclosure, reduces main skill token count by ~2,500

**Files to create:**
- `assets/reconciliation-examples.md` (111 lines)
- `references/handoff-formats.md` (31 lines)
- `references/plugins-md-operations.md` (12 lines)

## Verification Checklist

After implementing fixes, verify:
- [ ] YAML frontmatter includes name, description, argument-hint
- [ ] Command is 50-100 lines (routing only, no inline implementation)
- [ ] workflow-reconciliation skill exists in `.claude/skills/`
- [ ] Command invokes skill via Skill tool
- [ ] Skill uses XML enforcement for critical sequences
- [ ] Reconciliation rules extracted to JSON asset
- [ ] Examples extracted to assets/
- [ ] Reference materials extracted to references/
- [ ] `/help` shows reconcile command with description
- [ ] Autocomplete suggests `/reconcile [PluginName]`
- [ ] Running `/reconcile` successfully invokes skill and generates report

## Estimated Impact

### Before Optimization
- **Command length:** 409 lines
- **Token count:** ~6,500 tokens
- **Architecture:** Violates instructed routing pattern
- **Reusability:** None (logic trapped in command)
- **Maintenance:** High (single 409-line file)

### After Optimization
- **Command length:** 50 lines (routing only)
- **Skill length:** 250 lines (implementation)
- **Token count (command):** ~300 tokens (95% reduction)
- **Token count (skill):** ~4,000 tokens (with XML enforcement)
- **Architecture:** Follows instructed routing pattern
- **Reusability:** High (skill callable from other skills)
- **Maintenance:** Low (separation of concerns, data-driven rules)

### Comprehension Improvement: **CRITICAL**

**Why this is a critical issue:**
1. **Architectural violation:** Commands MUST route to skills, not implement inline
2. **Context explosion:** 409-line command loads on every invocation
3. **No discoverability:** Missing frontmatter blocks /help and autocomplete
4. **No enforcement:** Prose instructions easy to skip under token pressure
5. **Maintenance nightmare:** 409 lines in single file, massive duplication

**After fixes:**
- Command becomes lean 50-line router
- Skill has structured 5-phase orchestration
- XML enforcement prevents skipping critical steps
- Data-driven rules in JSON enable easy updates
- Reference materials use progressive disclosure
- Total context reduction: ~2,500 tokens (38%)

### Maintenance Improvement: **HIGH**

**Before:**
- Single 409-line file with mixed concerns
- Workflow rules duplicated in prose (10+ places)
- Examples inline (111 lines)
- Format specs inline (31 lines)
- Update requires touching multiple prose sections

**After:**
- Clear separation: command (routing) vs skill (implementation)
- Workflow rules in JSON (single source of truth)
- Examples in assets/ (load only if needed)
- Format specs in references/ (shared with other skills)
- Update rules: edit JSON, changes propagate automatically

**Time savings:**
- Current: ~30 minutes to update commit format (find all instances in prose)
- After: ~2 minutes (edit JSON template, done)

## Summary

The `/reconcile` command suffers from fundamental architectural issues:

1. **No frontmatter** → Invisible to discovery system
2. **Inline implementation** → Violates instructed routing pattern
3. **409 lines** → 4-8x recommended command length
4. **No XML enforcement** → Easy to skip critical steps
5. **Prose rules** → Not machine-parseable, high duplication
6. **Inline examples** → Bloats context unnecessarily

**Required fixes:**
1. Add YAML frontmatter (2 minutes)
2. Extract to workflow-reconciliation skill (90 minutes)
3. Add XML enforcement to skill (45 minutes)
4. Extract rules to JSON asset (15 minutes)
5. Extract examples to assets/ (10 minutes)

**Total effort:** ~2.5 hours
**Total impact:** Transforms non-functional 409-line command into proper 50-line router + reusable skill

This is a **RED** status command that blocks proper system functionality. Fix immediately.
