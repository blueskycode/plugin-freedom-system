# Fix Plan: /continue

## Summary
- Critical fixes: **0** (Command is already highly functional)
- Optimization operations: **3** (Clarity and structural consistency improvements)
- Total estimated changes: **3**
- Estimated time: **15 minutes**
- Token savings: **120 tokens (10% reduction)**

## Context

The `/continue` command is already at **38/40 health (95%)** and demonstrates the **ideal command pattern** for the Plugin Freedom System. This fix plan focuses on minor optimizations for structural consistency rather than addressing critical blockers.

**Key strengths to preserve:**
- Pure routing layer (123 lines)
- Single clear delegation: "YOU MUST invoke context-resume skill"
- Zero implementation details
- Complete YAML frontmatter with allowed-tools
- Graceful error messages with recovery paths

## Phase 1: Structural Consistency (No Critical Blockers)

**Note:** This command has NO critical issues. Phase 1 contains high-priority optimizations for consistency with skill patterns.

### Fix 1.1: Add XML Precondition Wrapper
**Location:** Lines 20-41
**Operation:** WRAP
**Severity:** HIGH (structural consistency)

**Before:**
```markdown
## Behavior

**Without plugin name:**
Search for all `.continue-here.md` handoff files in:
- `plugins/[Name]/.continue-here.md` (implementation)
- `plugins/[Name]/.ideas/.continue-here.md` (ideation/mockup)

Present interactive menu:
```
Which plugin would you like to continue working on?

1. [PluginName1] - Stage [N]: [description]
2. [PluginName2] - Stage [M]: [description]
3. Other

Choose (1-3): _
```

Skip menu if only one option exists.

**With plugin name:**
Load directly: `plugins/[PluginName]/.continue-here.md`
```

**After:**
```markdown
## Behavior

<preconditions enforcement="blocking">
  <check target="handoff_files" condition="at_least_one_exists">
    Search for `.continue-here.md` files in priority order:

    **Without plugin name:**
    1. `plugins/[Name]/.continue-here.md` (implementation)
    2. `plugins/[Name]/.ideas/.continue-here.md` (ideation/mockup)

    Present interactive menu if multiple found:
    ```
    Which plugin would you like to continue working on?

    1. [PluginName1] - Stage [N]: [description]
    2. [PluginName2] - Stage [M]: [description]
    3. Other

    Choose (1-3): _
    ```

    Skip menu if only one option exists.

    **With plugin name:**
    Load directly: `plugins/[PluginName]/.continue-here.md`

    IF none found: See Error Handling section below.
  </check>
</preconditions>
```

**Verification:**
- [ ] Precondition structure matches pattern in context-resume skill
- [ ] Handoff file search logic is unchanged
- [ ] Menu presentation behavior preserved
- [ ] XML is well-formed

**Token impact:** +40 tokens (structural clarity)

### Fix 1.2: Add Explicit State Contract Section
**Location:** Lines 42-80
**Operation:** REPLACE
**Severity:** HIGH (documentation clarity)

**Before:**
```markdown
## What Gets Loaded

Context automatically loaded:
- Handoff file content (current state, completed work, next steps)
- Recent commits for this plugin
- Source files mentioned in handoff
- Research notes (if Stage 0-1)
- UI mockups (if applicable)

## After Loading

Present summary:
```
Resuming [PluginName] at Stage [N]...

Last session: [timestamp]
Status: [description from handoff]

Context loaded:
- [Contract files]
- [Recent commits]
- [Source files]

Ready to continue. What would you like to do?

1. Continue with planned next steps
2. Review current implementation
3. Change direction
4. Other

Choose (1-4): _
```
```

**After:**
```markdown
## State Contract

<state_contract>
  <reads>
    - `.continue-here.md` (one of 3 locations by priority)
    - PLUGINS.md (status verification)
    - Recent git commits (for plugin only)
    - Contract files (if workflow stage 0-1)
    - Source files (if mentioned in handoff)
    - Research notes (if Stage 0-1)
    - UI mockups (if applicable)
  </reads>

  <writes>
    NONE - This command is READ-ONLY for state files.
    Continuation skills handle all state updates.
  </writes>

  <loads_before_routing>
    Load contracts and context files BEFORE invoking continuation skill.
    This provides full context for skill execution.
  </loads_before_routing>
</state_contract>

## After Loading

Present summary:
```
Resuming [PluginName] at Stage [N]...

Last session: [timestamp]
Status: [description from handoff]

Context loaded:
- [Contract files]
- [Recent commits]
- [Source files]

Ready to continue. What would you like to do?

1. Continue with planned next steps
2. Review current implementation
3. Change direction
4. Other

Choose (1-4): _
```
```

**Verification:**
- [ ] State contract explicitly documents read-only nature
- [ ] All read locations are listed
- [ ] "After Loading" section preserved exactly
- [ ] XML structure is well-formed

**Token impact:** -40 tokens (removes redundant "What Gets Loaded" heading, consolidates)

## Phase 2: Content Optimization (Token Reduction)

### Fix 2.1: Consolidate Error Examples
**Location:** Lines 83-110
**Operation:** REPLACE
**Severity:** MEDIUM (token efficiency)

**Before:**
```markdown
**No handoff files exist:**
```
No resumable work found.

Handoff files are created throughout the plugin lifecycle:
- After ideation (creative brief complete)
- After mockup creation (design ready)
- During implementation (plugin-workflow stages)
- After improvements (version releases)

Start new work:
- /dream - Explore plugin ideas
- /implement - Build new plugin
```

**Plugin doesn't have handoff:**
```
[PluginName] doesn't have a handoff file.

Possible reasons:
- Plugin is already complete (Stage 6 done)
- Plugin hasn't been started yet
- Development finished and handoff removed

Check status: Look in PLUGINS.md
Modify complete plugin: /improve [PluginName]
Start new plugin: /implement [PluginName]
```
```

**After:**
```markdown
## Error Handling

**No handoff files found:**

IF no handoff exists for any plugin:
- Display: "No resumable work found"
- Explain: Handoffs created after ideation, mockup, during implementation, or after improvements
- Suggest: `/dream` (explore ideas) or `/implement` (build new plugin)

IF specific [PluginName] doesn't have handoff:
- Display: "[PluginName] doesn't have a handoff file"
- Explain: Plugin may be complete (Stage 6), not started, or handoff removed
- Suggest: Check `PLUGINS.md`, `/improve [PluginName]`, or `/implement [PluginName]`

See `context-resume` skill's `error-recovery.md` for additional scenarios.
```

**Verification:**
- [ ] Both error scenarios covered
- [ ] All recovery paths preserved
- [ ] Suggestions remain actionable
- [ ] More scannable structure (IF/Display/Explain/Suggest)

**Token impact:** -80 tokens (removes redundant phrasing, improves scannability)

## Phase 3: Polish (No Changes Needed)

**Note:** Command language is already optimal. No polish changes required.

- Imperative language throughout ("YOU MUST invoke")
- No ambiguous pronouns
- Explicit routing instruction
- Clear delegation to skill

## File Operations Manifest

**Files to modify:**
1. `.claude/commands/continue.md` - Apply all fixes above

**Files to create:**
None (command structure is optimal)

**Files to archive:**
None (command is current and functional)

## Execution Checklist

**Phase 1 (Structural Consistency):**
- [ ] Preconditions wrapped in `<preconditions enforcement="blocking">`
- [ ] State contract explicitly documented with `<state_contract>` tags
- [ ] Read-only nature of command clearly stated
- [ ] All state file interactions listed in contract

**Phase 2 (Content Optimization):**
- [ ] Error scenarios consolidated under single "Error Handling" heading
- [ ] IF/Display/Explain/Suggest structure applied
- [ ] All recovery paths preserved
- [ ] Reference to skill's error-recovery.md added

**Final Verification:**
- [ ] Command loads without errors
- [ ] Command appears in `/help` with correct description
- [ ] Routing to context-resume skill succeeds
- [ ] Handoff file search logic unchanged
- [ ] Interactive menus preserved
- [ ] Health score improved from 38/40 to 40/40

## Estimated Impact

**Before:**
- Health score: 38/40 (95%)
- Line count: 123 lines
- Token count: ~1,200 tokens
- Critical issues: 0
- Optimization opportunities: 3

**After:**
- Health score: 40/40 (100%) - target
- Line count: 120 lines
- Token count: ~1,080 tokens
- Critical issues: 0
- Optimization opportunities: 0

**Improvement:** +2 health points, -10% tokens

## Recommendation

This command is **already exemplary**. The fixes above are optional refinements for:
1. **Structural consistency** with skill patterns (XML preconditions, state contracts)
2. **Token efficiency** (error consolidation)
3. **Documentation clarity** (explicit read-only nature)

**Priority:** Low (command is fully functional as-is)

**Use case for fixes:** Standardization across all commands to match emerging XML enforcement pattern

## Reference Pattern

The `/continue` command should be used as the **reference template** when refactoring other commands. After these fixes, it demonstrates:

✅ Complete YAML frontmatter with all fields
✅ Single clear delegation ("YOU MUST invoke [skill-name] skill")
✅ XML-enforced preconditions
✅ Explicit state contracts (reads/writes documented)
✅ Zero implementation details (pure routing layer)
✅ Graceful error handling with recovery paths
✅ Optimal length (120 lines, well within 50-200 range)
✅ Token-efficient structure

Commands like `/reconcile`, `/implement`, and `/improve` should follow this pattern.
