# Command Analysis: destroy

## Executive Summary
- Overall health: **Yellow** (Functional routing layer with missing structural enforcement)
- Critical issues: **1** (No precondition validation)
- Optimization opportunities: **3** (XML structure, preconditions, sequence enforcement)
- Estimated context savings: **-150 tokens** (Negative = adding needed structure for reliability)

**Assessment:** The `/destroy` command is a clean 74-line routing layer that correctly delegates to the plugin-lifecycle skill. However, it lacks precondition checks and structural enforcement, which could allow destructive operations to proceed when they shouldn't. Given the irreversible nature of this command, this is the one place where precondition enforcement is actually critical.

## Dimension Scores (1-5)

1. **Structure Compliance: 4/5** - Has complete YAML frontmatter with `description` and `args`, but uses non-standard field name (`args` instead of `argument-hint`)
2. **Routing Clarity: 5/5** - Crystal clear delegation to plugin-lifecycle skill with mode: 'destroy'
3. **Instruction Clarity: 5/5** - Imperative language, explicit routing, no ambiguity
4. **XML Organization: 2/5** - No XML structure; critical warnings and confirmations are prose examples rather than enforced logic
5. **Context Efficiency: 5/5** - Lean 74-line routing layer, no duplication, appropriate documentation
6. **Claude-Optimized Language: 5/5** - Fully imperative, explicit instructions ("invoke the plugin-lifecycle skill")
7. **System Integration: 4/5** - Documents what gets removed but doesn't explicitly document preconditions or state file checks
8. **Precondition Enforcement: 1/5** - No preconditions despite being a destructive operation; relies entirely on skill to handle validation

**Total Score: 31/40 (Yellow)**

## Critical Issues (blockers for Claude comprehension)

### Issue #1: Missing Precondition Enforcement (Lines 1-74)
**Severity:** CRITICAL
**Impact:** A destructive command that permanently deletes code lacks basic safety checks. Claude could invoke this on non-existent plugins or plugins in invalid states, leading to confusing errors or partial cleanup. The warning about blocking status 🚧 (line 25) is documented but not enforced.

**Current structure:**
```markdown
## Behavior

When user runs `/destroy [PluginName]`, invoke the plugin-lifecycle skill with mode: 'destroy'.

...

**Safety features:**
- Timestamped backup created before deletion
- Requires typing exact plugin name to confirm
- Blocks if status is 🚧 (protects in-progress work)
```

**Problem:**
- No validation that `$1` (plugin name) was provided
- No check that plugin exists in PLUGINS.md
- Safety features are described but not enforced at the command level
- "Blocks if status is 🚧" is documented but not verified before skill invocation

**Recommended Fix:**
Add XML-wrapped preconditions before routing to skill:

```xml
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
  Preconditions verified. Invoke plugin-lifecycle skill with mode: 'destroy'.
</routing>
```

**Why this matters:**
For a command called "Nuclear Cleanup" that performs irreversible deletion, basic guard rails at the routing layer prevent Claude from even attempting invalid operations. This reduces error messages, improves user experience, and ensures the skill receives valid inputs.

## Optimization Opportunities

### Optimization #1: Frontmatter Field Name Standardization (Line 4)
**Potential savings:** 0 tokens (correctness fix, no impact on context size)
**Current:** Uses `args: "[PluginName]"`
**Recommended:** Use `argument-hint: "[PluginName]"` per Claude Code documentation

**Why:** The official field name for parameter hints is `argument-hint`, not `args`. While this likely still works, it's non-standard.

```yaml
---
name: destroy
description: Completely remove plugin - source code, binaries, registry entries, everything
argument-hint: "[PluginName]"
---
```

### Optimization #2: Wrap Critical Sequence (Lines 15-16)
**Potential savings:** -80 tokens (adding structure for reliability)
**Current:** Prose instruction for routing
**Recommended:** XML structure for critical sequence

```xml
<critical_sequence>
  <step order="1" required="true">Verify preconditions (block if failed)</step>
  <step order="2" required="true">Invoke plugin-lifecycle skill with mode: 'destroy'</step>
</critical_sequence>
```

**Why:** Structurally enforces the precondition → skill invocation flow, preventing Claude from accidentally skipping validation.

### Optimization #3: Document State File Contract (New Section)
**Potential savings:** -70 tokens (adding needed documentation)
**Current:** Doesn't explicitly document state file interactions
**Recommended:** Add state file documentation after line 30

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

**Why:** Makes data flow explicit for debugging and maintenance. Anyone reading this command knows exactly what files are affected.

## Implementation Priority

1. **Immediate** (Critical issues blocking safety)
   - Issue #1: Add precondition enforcement with XML structure (blocking execution on invalid inputs)

2. **High** (Correctness and maintainability)
   - Optimization #1: Fix frontmatter field name to `argument-hint`
   - Optimization #2: Wrap routing in `<critical_sequence>` XML

3. **Medium** (Documentation completeness)
   - Optimization #3: Add state file contract section

## Verification Checklist

After implementing fixes, verify:
- [x] YAML frontmatter includes required fields (has description)
- [ ] YAML frontmatter uses `argument-hint` instead of `args`
- [ ] Preconditions use XML enforcement with blocking attribute
- [ ] Plugin name argument is validated before skill invocation
- [ ] PLUGINS.md existence check is enforced
- [ ] Status field validation prevents destroying in-progress work
- [x] Command is under 200 lines (currently 74 lines)
- [x] Routing to skills is explicit (clearly invokes plugin-lifecycle)
- [ ] State file interactions documented in contract section

## Token Impact Analysis

**Current:** ~1,100 tokens
**After fixes:** ~1,250 tokens (+150 tokens)

**Justification for increase:**
This is the rare case where adding tokens improves safety. The 150-token overhead for precondition enforcement is a worthwhile investment for a destructive command that permanently deletes code. The cost is minimal compared to the UX improvement of catching errors before skill invocation.

**Alternative approach (if tokens must be minimized):**
Move validation to skill and keep command ultra-lean:

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

This reduces the command to ~40 lines (~600 tokens) but pushes all validation to the skill layer. Trade-off: Less self-documenting, harder to debug routing failures.

## Recommended Approach

**For this specific command:** Add preconditions at the routing layer.

**Rationale:**
- `/destroy` is destructive and irreversible
- Early validation prevents wasted skill invocations
- Clear error messages improve UX
- Safety checks are lightweight (150 tokens)
- Self-documenting command structure

The token investment is justified for operational safety and user experience.
