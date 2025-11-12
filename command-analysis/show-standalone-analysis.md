# Command Analysis: show-standalone

## Executive Summary
- Overall health: **Yellow** (Functional but lacks enforcement structure)
- Critical issues: **2** (No XML precondition enforcement, missing allowed-tools in frontmatter)
- Optimization opportunities: **3** (Context efficiency, precondition structure, error handling structure)
- Estimated context savings: **150 tokens (19% reduction)**

## Dimension Scores (1-5)
1. Structure Compliance: **3/5** (Has description, missing allowed-tools for bash operations)
2. Routing Clarity: **5/5** (Explicitly states "no skill routing", direct execution)
3. Instruction Clarity: **4/5** (Clear imperative steps, minor pronoun usage in success output)
4. XML Organization: **2/5** (No XML usage, all prose instructions)
5. Context Efficiency: **4/5** (77 lines, lean but could be more structured)
6. Claude-Optimized Language: **4/5** (Mostly imperative, some user-facing prose)
7. System Integration: **4/5** (Documents build paths and processes, no state file interaction)
8. Precondition Enforcement: **2/5** (Listed preconditions but no structural enforcement)

**Overall Score: 28/40 (Yellow)**

## Critical Issues (blockers for Claude comprehension)

### Issue #1: Missing allowed-tools in Frontmatter (Lines 1-3)
**Severity:** CRITICAL
**Impact:** Command uses bash extensively but doesn't declare it in frontmatter, blocking proper tool access

Current frontmatter:
```yaml
---
name: show-standalone
description: Open plugin UI in Standalone mode for visual inspection
---
```

**Problem:** Command executes cmake and open commands but doesn't specify allowed-tools. According to Claude Code best practices, bash commands require explicit tool permission.

**Recommended Fix:**
```yaml
---
name: show-standalone
description: Open plugin UI in Standalone mode for visual inspection
allowed-tools: [bash]
---
```

**Impact:** Without this, the command may fail silently or require additional permission checks.

### Issue #2: Preconditions Lack XML Enforcement (Lines 10-15)
**Severity:** HIGH
**Impact:** Critical preconditions may be skipped under token pressure

Current approach:
```markdown
## Preconditions

- Plugin must exist
- Plugin must have source code (any stage)

This command works at any stage of development, even before completion.
```

**Problem:** No structural enforcement of preconditions. Claude may proceed without validating plugin existence, leading to confusing bash errors.

**Recommended Fix:**
```xml
<preconditions enforcement="validate_before_execute">
  <check target="plugin_source" condition="directory_exists" path="plugins/$ARGUMENTS">
    Plugin source directory must exist at plugins/$ARGUMENTS
  </check>
  <check target="source_code" condition="has_source" scope="any_stage">
    Plugin must have source code (works at any development stage)
  </check>
</preconditions>
```

**Token savings:** 0 tokens (slightly more verbose but structurally enforced)

## Optimization Opportunities

### Optimization #1: Execution Sequence Lacks XML Structure (Lines 17-32)
**Potential savings:** 80 tokens (15% reduction)
**Current:** Prose description with inline bash examples
**Recommended:** Structured sequence with enforcement

Current approach (lines 19-32):
```markdown
1. Identify plugin name from argument or context
2. Check for existing Standalone build:
   ```
   build/plugins/[PluginName]/[PluginName]_artefacts/Debug/Standalone/[PluginName].app
   ```
3. If build doesn't exist, build it:
   ```bash
   cmake --build build --target [PluginName]_Standalone
   ```
4. Launch the application:
   ```bash
   open "build/plugins/[PluginName]/[PluginName]_artefacts/Debug/Standalone/[PluginName].app"
   ```
5. Report success
```

**Recommended Fix:**
```xml
<execution_sequence>
  <step order="1" required="true">
    Extract plugin name from $ARGUMENTS or context
  </step>

  <step order="2" conditional="true">
    Check if Standalone build exists:
    `build/plugins/$PLUGIN_NAME/${PLUGIN_NAME}_artefacts/Debug/Standalone/${PLUGIN_NAME}.app`
  </step>

  <step order="3" condition="!build_exists" tool="bash">
    Build Standalone target:
    `cmake --build build --target ${PLUGIN_NAME}_Standalone`
  </step>

  <step order="4" required="true" tool="bash">
    Launch application:
    `open "build/plugins/$PLUGIN_NAME/${PLUGIN_NAME}_artefacts/Debug/Standalone/${PLUGIN_NAME}.app"`
  </step>

  <step order="5" required="true">
    Report success with testing guidance
  </step>
</execution_sequence>
```

**Benefits:**
- Clearer conditional logic (step 3 only if build doesn't exist)
- Tool attribution (bash) explicit
- Sequential ordering enforced
- More token-efficient (removes redundant descriptions)

### Optimization #2: Success Output Has User-Facing Prose (Lines 34-43)
**Potential savings:** 40 tokens (30% reduction of this section)
**Current:** Verbose user-facing guidance
**Recommended:** Concise imperative format

Current approach:
```markdown
## Success Output

```
✓ [PluginName] UI opened successfully

The plugin window should now be visible on your screen.
- Test all controls for proper layout and behavior
- Check parameter ranges and default values
- Verify graphics and custom components render correctly
```
```

**Problem:** Natural language descriptions are token-inefficient and not Claude-optimized.

**Recommended Fix:**
```xml
<success_response>
  <output format="compact">
    ✓ $PLUGIN_NAME UI opened successfully

    Testing checklist:
    - Controls layout and behavior
    - Parameter ranges and defaults
    - Graphics and component rendering
  </output>
</success_response>
```

**Token savings:** ~40 tokens (removes redundant phrases like "should now be visible on your screen")

### Optimization #3: Troubleshooting Section Could Use Structured Error Mapping (Lines 45-69)
**Potential savings:** 30 tokens (10% reduction of this section)
**Current:** Three subsections with bullets
**Recommended:** Structured error-to-solution mapping

Current structure (lines 45-61):
```markdown
## Troubleshooting

**If build fails:**
- Verify CMakeLists.txt includes Standalone in FORMATS
- Check for compilation errors
- Try clean rebuild: `cmake --build build --target [Plugin]_Standalone --clean-first`

**If app won't launch:**
- Check Console.app for crash logs
- Verify .app bundle exists at expected path
- Try running from terminal to see error output

**UI appears blank:**
- Check paint() method in PluginEditor.cpp
- Verify component initialization in constructor
- Look for assertion failures
```

**Recommended Fix:**
```xml
<error_handling>
  <error condition="build_fails">
    1. Verify CMakeLists.txt includes Standalone in FORMATS
    2. Check compilation errors
    3. Clean rebuild: `cmake --build build --target $PLUGIN_NAME_Standalone --clean-first`
  </error>

  <error condition="app_wont_launch">
    1. Check Console.app for crash logs
    2. Verify .app bundle exists at expected path
    3. Run from terminal for error output
  </error>

  <error condition="ui_blank">
    1. Check paint() method in PluginEditor.cpp
    2. Verify component initialization in constructor
    3. Look for assertion failures
  </error>
</error_handling>
```

**Benefits:**
- Machine-readable error conditions
- Numbered remediation steps (more Claude-friendly)
- Token-efficient structure

## Implementation Priority

1. **Immediate** (Critical issues blocking comprehension)
   - Add `allowed-tools: [bash]` to frontmatter
   - Wrap preconditions in XML enforcement structure

2. **High** (Major optimizations)
   - Restructure execution sequence with XML (80 token savings)

3. **Medium** (Minor improvements)
   - Simplify success output (40 token savings)
   - Structure error handling (30 token savings)

## Verification Checklist

After implementing fixes, verify:
- [x] YAML frontmatter includes `allowed-tools: [bash]`
- [ ] Preconditions use XML enforcement with validation attributes
- [ ] Execution sequence structured in XML with conditional logic
- [ ] Success output is concise and imperative
- [ ] Error handling uses structured mapping
- [x] Command remains under 200 lines (currently 77 lines)
- [x] No skill routing (direct execution model)
- [ ] State file interactions documented (N/A - this is a stateless utility command)

## Summary

The show-standalone command is **functional** but lacks the structural enforcement patterns that make Claude Code commands robust. Key improvements:

1. **Add bash to allowed-tools** (critical for execution)
2. **XML-wrap preconditions** to ensure validation happens
3. **Structure the 5-step execution sequence** for clarity
4. **Simplify success and error output** for token efficiency

These changes would reduce context from ~800 tokens to ~650 tokens (19% reduction) while improving Claude's ability to reliably execute the command under various conditions.

The command is appropriately scoped as a direct-execution utility (no skill routing needed) and correctly avoids state file interactions. It's a good candidate for structural improvements without scope expansion.
