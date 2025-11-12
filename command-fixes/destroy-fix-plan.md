# Fix Plan: /destroy

## Summary
- Critical fixes: 1
- Extraction operations: 0
- Total estimated changes: 4
- Estimated time: 15 minutes
- Token savings: -150 tokens (-13.6% context, but justified for safety)

## Phase 1: Critical Fixes (Blocking Issues)

### Fix 1.1: Add Precondition Enforcement
**Location:** After line 13 (before "When user runs...")
**Operation:** INSERT
**Severity:** CRITICAL

**Before:**
```markdown
## Behavior

When user runs `/destroy [PluginName]`, invoke the plugin-lifecycle skill with mode: 'destroy'.
```

**After:**
```markdown
## Behavior

<preconditions enforcement="blocking">
  <check target="argument" condition="not_empty">
    Plugin name argument MUST be provided
    Usage: /destroy [PluginName]
  </check>
  <check target="PLUGINS.md" condition="plugin_exists">
    Plugin entry for $1 MUST exist in PLUGINS.md
    Run /dream to create new plugins
  </check>
  <check target="status" condition="not_equal(🚧)">
    Plugin status MUST NOT be 🚧 In Progress
    Complete or abandon current work before destroying
  </check>
</preconditions>

<routing>
  When preconditions verified, invoke the plugin-lifecycle skill with mode: 'destroy'.
</routing>
```

**Verification:**
- [ ] Command blocks when no plugin name provided
- [ ] Command blocks when plugin doesn't exist in PLUGINS.md
- [ ] Command blocks when plugin status is 🚧 In Progress
- [ ] Clear error messages displayed for each precondition failure
- [ ] Successful validation proceeds to skill invocation

**Token impact:** +150 tokens (safety enforcement)

### Fix 1.2: Frontmatter Field Name Standardization
**Location:** Line 4
**Operation:** REPLACE
**Severity:** CRITICAL (standards compliance)

**Before:**
```yaml
---
name: destroy
description: Completely remove plugin - source code, binaries, registry entries, everything
args: "[PluginName]"
---
```

**After:**
```yaml
---
name: destroy
description: Completely remove plugin - source code, binaries, registry entries, everything
argument-hint: "[PluginName]"
---
```

**Verification:**
- [ ] YAML frontmatter parses correctly
- [ ] `/help` displays command with description
- [ ] Autocomplete shows argument hint

**Token impact:** 0 tokens (field name change only)

## Phase 2: Content Extraction (Token Reduction)

No extraction operations needed. Command is already lean at 74 lines.

## Phase 3: Polish (Clarity & Optimization)

### Fix 3.1: Wrap Critical Sequence in XML
**Location:** Lines 15-16
**Operation:** WRAP (covered by Fix 1.1)
**Severity:** MEDIUM

Already addressed in Fix 1.1 via `<routing>` XML wrapper. The precondition → skill invocation flow is now structurally enforced.

**Verification:**
- [ ] Routing logic wrapped in `<routing>` tags
- [ ] Critical sequence (preconditions → skill) cannot be bypassed
- [ ] XML structure matches Claude Code conventions

**Token impact:** 0 tokens (included in Fix 1.1)

### Fix 3.2: Add State File Contract Documentation
**Location:** After line 29 (after "## Implementation")
**Operation:** INSERT
**Severity:** MEDIUM

**Insert:**
```markdown
## State File Contract

**Reads:**
- `PLUGINS.md` - Validates plugin exists, checks status field
- `plugins/[PluginName]/` - Source directory to be removed

**Writes:**
- `PLUGINS.md` - Removes plugin entry
- `backups/destroyed/[PluginName]_[timestamp].tar.gz` - Creates backup archive

**Modified by skill:** All state updates handled by plugin-lifecycle skill
```

**Verification:**
- [ ] State file contract clearly documented
- [ ] Read operations listed
- [ ] Write operations listed
- [ ] Skill responsibility clarified

**Token impact:** -70 tokens (documentation completeness)

## Special Instructions

None. This command correctly delegates to the plugin-lifecycle skill and does not need architectural changes. The fixes add safety enforcement appropriate for a destructive operation.

## File Operations Manifest

**Files to create:**
None

**Files to modify:**
1. `.claude/commands/destroy.md` - Add preconditions, fix frontmatter, add state contract

**Files to archive:**
None

## Execution Checklist

**Phase 1 (Critical):**
- [ ] YAML frontmatter uses `argument-hint` instead of `args`
- [ ] Preconditions wrapped in `<preconditions enforcement="blocking">`
- [ ] Plugin name argument validation present
- [ ] PLUGINS.md existence check enforced
- [ ] Status field check prevents destroying in-progress work
- [ ] Routing logic wrapped in `<routing>` tags

**Phase 2 (Extraction):**
- [x] No extractions needed (command already lean)

**Phase 3 (Polish):**
- [ ] Critical sequence XML enforced (via Fix 1.1)
- [ ] State file contract documented
- [ ] All instructions remain imperative
- [ ] Verification steps included

**Final Verification:**
- [ ] Command loads without errors
- [ ] Command appears in `/help` with correct description
- [ ] Autocomplete works with argument hints
- [ ] Precondition checks block invalid inputs
- [ ] Routing to plugin-lifecycle skill succeeds
- [ ] Health score improved from 31/40 to 38/40 (estimated)

## Estimated Impact

**Before:**
- Health score: 31/40
- Line count: 74 lines
- Token count: ~1,100 tokens
- Critical issues: 1

**After:**
- Health score: 38/40 (target)
- Line count: 92 lines (+18 lines)
- Token count: ~1,250 tokens (+150 tokens)
- Critical issues: 0

**Improvement:** +7 health points, +13.6% tokens

**Justification for token increase:**
The `/destroy` command performs irreversible deletion. The 150-token overhead for precondition enforcement is a worthwhile investment for operational safety. Early validation:
- Prevents confusing error messages
- Improves user experience
- Protects in-progress work
- Ensures skill receives valid inputs
- Self-documents command requirements

This is the rare case where adding tokens improves the system. The cost is minimal compared to the safety and UX benefits.

## Alternative Minimal Approach (Not Recommended)

If tokens must be minimized at all costs, an alternative ultra-lean version:

```markdown
---
name: destroy
description: Completely remove plugin - source code, binaries, registry entries, everything
argument-hint: "[PluginName]"
---

⚠️ **WARNING:** Irreversible deletion. Creates backup before removal.

Invoke plugin-lifecycle skill with:
- mode: 'destroy'
- plugin_name: $1

Skill handles all validation and safety checks.
```

This reduces to ~40 lines (~600 tokens) but:
- Less self-documenting
- Harder to debug routing failures
- No early validation
- Poorer user experience

**Recommendation:** Use the main fix plan (Phase 1-3) for this destructive operation.
