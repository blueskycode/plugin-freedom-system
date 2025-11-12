# Fix Plan: /reconcile

## Summary
- Critical fixes: 6
- Extraction operations: 4
- Total estimated changes: 10
- Estimated time: 157 minutes (2.6 hours)
- Token savings: 6,200 tokens (95% reduction from 6,500 → 300 in command)

## Phase 1: Critical Fixes (Blocking Issues)

### Fix 1.1: Add YAML Frontmatter
**Location:** Line 1 (INSERT before current line 1)
**Operation:** INSERT
**Severity:** CRITICAL

**Current:**
```markdown
# /reconcile - Workflow State Reconciliation

Reconcile workflow state files to ensure all checkpoints are properly updated and committed. Use this command when switching between workflows or when you suspect state files are out of sync.
```

**After:**
```yaml
---
name: reconcile
description: Reconcile workflow state files to ensure checkpoints are updated
argument-hint: "[PluginName?] (optional - if omitted, analyzes current context)"
---

# /reconcile

When user runs `/reconcile [PluginName?]`, invoke the workflow-reconciliation skill.
```

**Verification:**
- [ ] YAML frontmatter parses correctly
- [ ] `/help` displays reconcile command with description
- [ ] Autocomplete shows `/reconcile [PluginName?]` argument hint

**Token impact:** +50 tokens (frontmatter), but enables discoverability

---

### Fix 1.2: Replace Entire Command with Skill Router
**Location:** Lines 1-409 (entire file)
**Operation:** REPLACE
**Severity:** CRITICAL

**Current:**
409-line command implementing entire reconciliation system inline

**After:**
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

**Verification:**
- [ ] Command file is 50-100 lines (not 409)
- [ ] Command explicitly invokes workflow-reconciliation skill
- [ ] No inline implementation logic remains
- [ ] Routing logic wrapped in `<routing_decision>` tags

**Token impact:** -6,200 tokens (command shrinks from ~6,500 to ~300)

---

### Fix 1.3: Create workflow-reconciliation Skill
**Location:** NEW FILE `.claude/skills/workflow-reconciliation/SKILL.md`
**Operation:** CREATE
**Severity:** CRITICAL

**File content:**
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

## Phase 2: Rule Loading

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

## Phase 3: Gap Analysis

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

## Phase 4: Report Generation

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
- [reconciliation-examples.md](assets/reconciliation-examples.md) - Example reports and outputs

## Success Criteria

Reconciliation succeeds when:
- All state files reflect current workflow state
- Git status shows no uncommitted workflow artifacts
- Workflow can resume without context loss
- No checkpoint amnesia at workflow boundaries
```

**Verification:**
- [ ] Skill file created at `.claude/skills/workflow-reconciliation/SKILL.md`
- [ ] All 5 phases have XML enforcement tags
- [ ] Context detection is blocking
- [ ] Gap analysis is blocking
- [ ] Checkpoint protocol includes decision menu

**Token impact:** +4,000 tokens (new skill file, but only loaded when invoked)

---

### Fix 1.4: Create Reconciliation Rules JSON Asset
**Location:** NEW FILE `.claude/skills/workflow-reconciliation/assets/reconciliation-rules.json`
**Operation:** CREATE
**Severity:** CRITICAL

**File content:**
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
      },
      "3": {
        "state_files": [".continue-here.md", "PLUGINS.md"],
        "required_files": ["PluginProcessor.h", "PluginProcessor.cpp"],
        "plugins_md_status": "🚧 Stage 3",
        "commit_template": "feat({name}): Complete Stage 3 (DSP Core) - audio processing operational"
      },
      "4": {
        "state_files": [".continue-here.md", "PLUGINS.md"],
        "required_files": ["PluginProcessor.h", "PluginProcessor.cpp", "PluginEditor.h", "PluginEditor.cpp"],
        "plugins_md_status": "🚧 Stage 4",
        "commit_template": "feat({name}): Complete Stage 4 (Parameters) - APVTS configured"
      },
      "5": {
        "state_files": [".continue-here.md", "PLUGINS.md"],
        "required_files": ["PluginEditor.h", "PluginEditor.cpp", "ui/public/index.html"],
        "plugins_md_status": "🚧 Stage 5",
        "commit_template": "feat({name}): Complete Stage 5 (GUI) - UI operational"
      },
      "6": {
        "state_files": [".continue-here.md", "PLUGINS.md"],
        "required_files": ["test_results.txt"],
        "plugins_md_status": "✅",
        "commit_template": "feat({name}): Complete Stage 6 (Validation) - plugin tested and ready"
      }
    }
  },
  "ui-mockup": {
    "phases": {
      "4": {
        "state_files": [".continue-here.md"],
        "required_files": ["v{n}-ui.yaml", "v{n}-ui-test.html"],
        "plugins_md_status": null,
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
        "plugins_md_status": null,
        "commit_template": "feat({name}): Complete UI mockup v{n} with implementation files"
      }
    }
  },
  "plugin-ideation": {
    "phases": {
      "complete": {
        "state_files": [".continue-here.md", "PLUGINS.md"],
        "required_files": ["creative-brief.md", "parameter-spec.md"],
        "plugins_md_status": "💡",
        "commit_template": "docs({name}): Plugin ideation complete"
      }
    }
  },
  "plugin-improve": {
    "phases": {
      "complete": {
        "state_files": [".continue-here.md", "PLUGINS.md", "CHANGELOG.md"],
        "required_files": ["Source/*.cpp", "Source/*.h"],
        "plugins_md_status": "✅",
        "commit_template": "fix({name}): {description}"
      }
    }
  },
  "design-sync": {
    "phases": {
      "complete": {
        "state_files": [".continue-here.md"],
        "required_files": ["design-sync-report.md"],
        "plugins_md_status": null,
        "commit_template": "docs({name}): Design sync validation complete"
      }
    }
  }
}
```

**Verification:**
- [ ] JSON parses correctly
- [ ] All workflows from original command included
- [ ] All stages/phases have required fields: state_files, required_files, plugins_md_status, commit_template
- [ ] File created at `.claude/skills/workflow-reconciliation/assets/reconciliation-rules.json`

**Token impact:** +800 tokens (JSON asset, but only loaded when skill runs)

---

### Fix 1.5: Create Handoff Format Reference
**Location:** NEW FILE `.claude/skills/workflow-reconciliation/references/handoff-formats.md`
**Operation:** CREATE
**Severity:** HIGH

**File content:**
```markdown
# .continue-here.md Format Specification

## Purpose

The `.continue-here.md` file is the authoritative handoff file that preserves workflow context across sessions. It allows workflow resumption without context loss or checkpoint amnesia.

## Location

Always created at: `plugins/{PluginName}/.continue-here.md`

## Format

```yaml
---
plugin: [PluginName]
workflow: [workflow-name]
stage: [0-6] (for plugin-workflow only)
phase: [phase-number] (for other workflows)
status: [workflow-specific status]
last_updated: [ISO 8601 timestamp]
---

# [Workflow Name] - [Stage/Phase] - [Status]

[Optional prose description of current state and next steps]
```

## Field Definitions

### Required Fields

- **plugin**: Plugin name (matches directory name in `plugins/`)
- **workflow**: Workflow name (plugin-workflow, ui-mockup, plugin-improve, etc.)
- **last_updated**: ISO 8601 timestamp (YYYY-MM-DDTHH:MM:SSZ)

### Conditional Fields

- **stage**: Required for plugin-workflow (values: 0-6)
- **phase**: Required for ui-mockup, plugin-ideation, etc.
- **status**: Workflow-specific status (e.g., "in_progress", "paused", "complete")

## Examples

### plugin-workflow Stage 3

```yaml
---
plugin: DriveVerb
workflow: plugin-workflow
stage: 3
status: in_progress
last_updated: 2025-11-12T14:30:00Z
---

# plugin-workflow - Stage 3 - In Progress

DSP implementation for reverb algorithm. Currently implementing early reflections.
Next: Complete late reverb diffusion network.
```

### ui-mockup Phase 4

```yaml
---
plugin: DriveVerb
workflow: ui-mockup
phase: 4
status: iteration
last_updated: 2025-11-12T10:15:00Z
---

# ui-mockup - Phase 4 - Iteration

Design iteration for reverb controls. User requested darker theme with neon accents.
Next: Generate v2-ui.yaml with updated color palette.
```

## Reconciliation Usage

During reconciliation, this file is:
1. Read to detect workflow context (Phase 1: Context Detection)
2. Validated against expected stage/phase rules (Phase 2: Rule Loading)
3. Updated if gaps found (Phase 5: Remediation)
4. Committed with workflow-appropriate message
```

**Verification:**
- [ ] File created at `.claude/skills/workflow-reconciliation/references/handoff-formats.md`
- [ ] All required and conditional fields documented
- [ ] Examples provided for major workflows

**Token impact:** +400 tokens (reference file, loaded only when needed)

---

### Fix 1.6: Create Reconciliation Examples Reference
**Location:** NEW FILE `.claude/skills/workflow-reconciliation/assets/reconciliation-examples.md`
**Operation:** CREATE
**Severity:** MEDIUM

**File content:**
```markdown
# Reconciliation Report Examples

## Example 1: After UI Mockup Completion

### Scenario
User completed Phase 6 of ui-mockup workflow but didn't commit changes. Reconciliation detects uncommitted files and offers to fix.

### Report Output

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Reconciliation Report for DriveVerb
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current Workflow: ui-mockup (Phase 6 - Complete)

State File Analysis:

✓ .continue-here.md
  Status: UP TO DATE
  Last updated: 2025-11-12T14:30:00Z

✓ parameter-spec.md
  Status: LOCKED AND CURRENT

✗ PLUGINS.md
  Current: 🚧 Stage 5
  Expected: ✅ Working (after UI implementation)
  Action: UPDATE status emoji

Git Status:

✓ Staged: None
✗ Unstaged: 5 files
  - plugins/DriveVerb/.ideas/mockups/v1-PluginEditor.h
  - plugins/DriveVerb/.ideas/mockups/v1-PluginEditor.cpp
  - plugins/DriveVerb/.ideas/mockups/v1-CMakeLists.txt
  - plugins/DriveVerb/.ideas/mockups/v1-integration-checklist.md
  - plugins/DriveVerb/.ideas/mockups/v1-ui.html
✗ Untracked: None
✗ Uncommitted: 5 workflow artifacts

Proposed Actions:

1. Update PLUGINS.md status: 🚧 Stage 5 → ✅ Working
2. Stage all 5 mockup implementation files
3. Commit with message: "feat(DriveVerb): Complete UI mockup v1 with implementation files"

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

### User Choice: 1 (Fix automatically)

### Remediation Output

```
Reconciliation complete:
✓ Updated PLUGINS.md status to ✅
✓ Staged 5 files
✓ Committed: feat(DriveVerb): Complete UI mockup v1 with implementation files

All state files synchronized. Workflow can resume without context loss.
```

---

## Example 2: After Subagent Completion

### Scenario
foundation-agent completed Stage 2 but didn't create .continue-here.md handoff file. Reconciliation detects missing handoff and offers to create it.

### Report Output

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Reconciliation Report for SimpleTremolo
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current Workflow: plugin-workflow (Stage 2 - Complete)

State File Analysis:

✗ .continue-here.md
  Status: MISSING
  Expected: Handoff file with stage=2, status=complete
  Action: CREATE handoff file

✓ PLUGINS.md
  Status: UP TO DATE
  Entry: 🚧 Stage 2 | SimpleTremolo

Git Status:

✓ Staged: 4 files (CMakeLists.txt, PluginProcessor.h, PluginProcessor.cpp, README.md)
✗ Unstaged: None
✗ Untracked: None
✗ Uncommitted: Staged changes not committed

Proposed Actions:

1. Create .continue-here.md with:
   - plugin: SimpleTremolo
   - workflow: plugin-workflow
   - stage: 2
   - status: complete
   - last_updated: 2025-11-12T15:45:00Z
2. Commit staged changes with message: "feat(SimpleTremolo): Complete Stage 2 (Foundation) - build system operational"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

What should I do?
1. Fix everything automatically - Create handoff and commit
2. Show me the diffs first - Preview handoff file content
3. Fix files only (no commit) - Create handoff but don't commit
4. Update .continue-here.md only - Create handoff, ignore staged changes
5. Skip reconciliation - I'll handle it manually
6. Other

Choose (1-6): _
```

### User Choice: 2 (Show diffs first)

### Diff Preview

```
Creating .continue-here.md with content:

---
plugin: SimpleTremolo
workflow: plugin-workflow
stage: 2
status: complete
last_updated: 2025-11-12T15:45:00Z
---

# plugin-workflow - Stage 2 - Complete

Foundation layer established. Build system operational, plugin loads successfully.

Next: Invoke dsp-agent for Stage 3 (DSP Core implementation).

─────────────────────────────────────────────────────

Commit will include:
- plugins/SimpleTremolo/.continue-here.md (new file)
- plugins/SimpleTremolo/CMakeLists.txt
- plugins/SimpleTremolo/Source/PluginProcessor.h
- plugins/SimpleTremolo/Source/PluginProcessor.cpp
- plugins/SimpleTremolo/README.md

Commit message:
"feat(SimpleTremolo): Complete Stage 2 (Foundation) - build system operational"

─────────────────────────────────────────────────────

What should I do?
1. Proceed with commit
2. Abort reconciliation
3. Other

Choose (1-3): _
```

---

## Example 3: No Gaps Found

### Scenario
User runs `/reconcile` on a plugin with all state files current and no uncommitted changes.

### Report Output

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Reconciliation Report for DriveVerb
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current Workflow: plugin-workflow (Stage 3 - In Progress)

State File Analysis:

✓ .continue-here.md
  Status: UP TO DATE
  Last updated: 2025-11-12T14:30:00Z

✓ PLUGINS.md
  Status: UP TO DATE
  Entry: 🚧 Stage 3 | DriveVerb

Git Status:

✓ Staged: None
✓ Unstaged: None
✓ Untracked: None
✓ Uncommitted: None

Proposed Actions:

None - all state files synchronized.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

What's next?
1. All good - return to workflow (recommended)
2. Show me the state files anyway
3. Force reconciliation (update timestamps)
4. Other

Choose (1-4): _
```
```

**Verification:**
- [ ] File created at `.claude/skills/workflow-reconciliation/assets/reconciliation-examples.md`
- [ ] Examples cover major scenarios: uncommitted files, missing handoff, no gaps
- [ ] Reports show proper formatting with visual dividers
- [ ] Decision menus vary based on gap severity

**Token impact:** +1,200 tokens (examples, loaded only when needed)

---

## Phase 2: Content Extraction (Token Reduction)

All extractions completed in Phase 1 (Fixes 1.4, 1.5, 1.6). No additional extractions needed.

---

## Phase 3: Polish (Clarity & Optimization)

### Fix 3.1: Ensure Imperative Language in Skill
**Location:** Throughout `.claude/skills/workflow-reconciliation/SKILL.md`
**Operation:** VERIFY
**Severity:** LOW

**Action:**
Review skill file created in Fix 1.3 to ensure:
- All instructions use imperative verbs ("Detect", "Load", "Validate", not "You should detect")
- No pronouns ("I", "you", "we")
- Explicit routing instructions
- No ambiguous language

**Verification:**
- [ ] All instructions imperative
- [ ] No pronouns found
- [ ] XML tags properly nested
- [ ] Enforcement attributes present where needed

**Token impact:** 0 (verification only)

---

## Special Instructions

### Architecture Change: Convert Command to Skill Router

**Reason:** Command contains 409 lines of implementation details (should be <100)

**New skill structure:**
```
.claude/skills/workflow-reconciliation/
├── SKILL.md (main orchestration - 250 lines)
├── references/
│   └── handoff-formats.md (format specification)
└── assets/
    ├── reconciliation-rules.json (workflow rules as data)
    └── reconciliation-examples.md (example reports)
```

**New command (replaces existing 409 lines):**
```yaml
---
name: reconcile
description: Reconcile workflow state files to ensure checkpoints are updated
argument-hint: "[PluginName?] (optional)"
---

# /reconcile

When user runs `/reconcile [PluginName?]`, invoke the workflow-reconciliation skill.

[50-line routing layer from Fix 1.2]
```

**Verification:**
- [ ] Skill directory created with proper structure
- [ ] Command reduced to <100 lines
- [ ] Skill properly invokable via Skill tool
- [ ] Functionality preserved (test with `/reconcile`)

---

## File Operations Manifest

### Files to create:
1. `.claude/skills/workflow-reconciliation/SKILL.md` - Main skill orchestration (250 lines)
2. `.claude/skills/workflow-reconciliation/assets/reconciliation-rules.json` - Workflow rules as data
3. `.claude/skills/workflow-reconciliation/references/handoff-formats.md` - .continue-here.md format spec
4. `.claude/skills/workflow-reconciliation/assets/reconciliation-examples.md` - Example reports

### Files to modify:
1. `.claude/commands/reconcile.md` - Replace entire file with 50-line router

### Files to archive:
None (reconcile.md is not deprecated, just being restructured)

---

## Execution Checklist

### Phase 1 (Critical)
- [ ] YAML frontmatter added to command with name, description, argument-hint
- [ ] Command reduced to routing layer (<100 lines)
- [ ] Command explicitly invokes workflow-reconciliation skill
- [ ] Routing logic wrapped in `<routing_decision>` tags
- [ ] workflow-reconciliation skill created with SKILL.md
- [ ] Skill has 5-phase orchestration pattern
- [ ] Context detection wrapped in `<context_detection enforcement="blocking">`
- [ ] Gap analysis wrapped in `<gap_analysis enforcement="blocking">`
- [ ] Checkpoint protocol includes decision menu with blocking wait
- [ ] reconciliation-rules.json created with all workflow rules
- [ ] handoff-formats.md created with .continue-here.md spec
- [ ] reconciliation-examples.md created with example reports

### Phase 2 (Extraction)
- [ ] Implementation details moved to skill (all 409 lines processed)
- [ ] Examples extracted to assets/reconciliation-examples.md
- [ ] Format spec extracted to references/handoff-formats.md
- [ ] Workflow rules extracted to assets/reconciliation-rules.json
- [ ] References updated in skill file

### Phase 3 (Polish)
- [ ] All instructions use imperative language
- [ ] No pronouns in skill or command
- [ ] XML enforcement tags properly formatted
- [ ] Decision menus use inline numbered lists (not AskUserQuestion)

### Final Verification
- [ ] Command file is 50-100 lines
- [ ] Command appears in `/help` with correct description
- [ ] Autocomplete works: `/reconcile [PluginName?]`
- [ ] Running `/reconcile` successfully invokes skill
- [ ] Skill performs context detection
- [ ] Skill loads reconciliation rules
- [ ] Skill generates gap analysis
- [ ] Skill presents report with decision menu
- [ ] Skill executes chosen remediation strategy
- [ ] Health score improved from 15/40 to estimated 35/40

---

## Estimated Impact

### Before
- Health score: **15/40 (RED)**
- Line count: 409 lines (command only)
- Token count: ~6,500 tokens
- Critical issues: 6
- Architecture: Violates instructed routing (inline implementation)
- Discoverability: None (no frontmatter)
- Reusability: None (logic trapped in command)
- Maintenance: High (single 409-line file with duplication)

### After
- Health score: **35/40 (GREEN)** (target)
- Line count: 50 lines (command) + 250 lines (skill)
- Token count: ~300 tokens (command) + ~4,000 tokens (skill, lazy-loaded)
- Critical issues: 0
- Architecture: Follows instructed routing pattern
- Discoverability: Full (/help, autocomplete, skill list)
- Reusability: High (skill callable from other workflows)
- Maintenance: Low (separation of concerns, data-driven rules)

### Improvement
- **+20 health points** (from RED to GREEN)
- **-6,200 tokens in command** (95% reduction)
- **+4,000 tokens in skill** (but lazy-loaded, only when invoked)
- **Net context reduction: -2,200 tokens** when command alone is loaded
- **Architecture compliance: 100%** (command routes to skill)
- **Maintenance time reduction: 93%** (30 min → 2 min to update rules)

---

## Timeline Estimate

### Phase 1: Critical Fixes (120 minutes)
- Fix 1.1: Add YAML frontmatter (2 min)
- Fix 1.2: Replace command with router (15 min)
- Fix 1.3: Create workflow-reconciliation skill (45 min)
- Fix 1.4: Create reconciliation-rules.json (15 min)
- Fix 1.5: Create handoff-formats.md (10 min)
- Fix 1.6: Create reconciliation-examples.md (20 min)
- Testing and validation (13 min)

### Phase 2: Content Extraction (0 minutes)
- Already completed in Phase 1

### Phase 3: Polish (15 minutes)
- Fix 3.1: Language verification (15 min)

### Testing & Validation (22 minutes)
- Test `/help` shows command (2 min)
- Test autocomplete (2 min)
- Test `/reconcile` with plugin name (5 min)
- Test `/reconcile` without plugin name (5 min)
- Test gap detection (5 min)
- Test remediation strategies (3 min)

**Total: 157 minutes (2.6 hours)**

---

## Success Metrics

✅ Command appears in `/help` output
✅ Autocomplete suggests `/reconcile [PluginName?]`
✅ Command file is <100 lines
✅ Skill file exists and is properly structured
✅ All XML enforcement tags present
✅ Running `/reconcile` successfully invokes skill
✅ Skill detects workflow context correctly
✅ Skill loads rules from JSON
✅ Skill performs gap analysis
✅ Skill presents report with context-appropriate decision menu
✅ Skill executes remediation based on user choice
✅ No critical issues remain
✅ Health score 35+/40
✅ Token reduction: 95% in command, 66% net overall
