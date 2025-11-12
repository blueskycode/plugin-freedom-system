# Fix Plan: /show-standalone

## Summary
- Critical fixes: 2
- Extraction operations: 0
- Optimization fixes: 3
- Total estimated changes: 5
- Estimated time: 15 minutes
- Token savings: 150 tokens (19% reduction)

## Phase 1: Critical Fixes (Blocking Issues)

### Fix 1.1: Add allowed-tools to Frontmatter
**Location:** Lines 1-3
**Operation:** REPLACE
**Severity:** CRITICAL

**Before:**
```yaml
---
name: show-standalone
description: Open plugin UI in Standalone mode for visual inspection
---
```

**After:**
```yaml
---
name: show-standalone
description: Open plugin UI in Standalone mode for visual inspection
allowed-tools: [bash]
---
```

**Verification:**
- [ ] YAML frontmatter parses correctly
- [ ] Command can execute bash operations without permission errors
- [ ] `/help` displays command with correct metadata

**Token impact:** +10 tokens (frontmatter clarity)

### Fix 1.2: Add XML Enforcement for Preconditions
**Location:** Lines 10-15
**Operation:** REPLACE
**Severity:** HIGH

**Before:**
```markdown
## Preconditions

- Plugin must exist
- Plugin must have source code (any stage)

This command works at any stage of development, even before completion.
```

**After:**
```markdown
## Preconditions

<preconditions enforcement="validate_before_execute">
  <check target="plugin_source" condition="directory_exists" path="plugins/$ARGUMENTS">
    Plugin source directory must exist at plugins/$ARGUMENTS
  </check>
  <check target="source_code" condition="has_source" scope="any_stage">
    Plugin must have source code (works at any development stage)
  </check>
</preconditions>

Note: This command works at any stage of development, even before completion.
```

**Verification:**
- [ ] XML preconditions enforce validation before execution
- [ ] Claude validates plugin directory exists before proceeding
- [ ] Error message is clear if preconditions fail

**Token impact:** +40 tokens (structural enforcement)

## Phase 2: Polish (Clarity & Optimization)

### Fix 2.1: Structure Execution Sequence with XML
**Location:** Lines 17-32
**Operation:** REPLACE
**Severity:** MEDIUM (optimization)

**Before:**
```markdown
## Execution

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

**After:**
```markdown
## Execution

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

**Verification:**
- [ ] Conditional logic is explicit (step 3 only if build doesn't exist)
- [ ] Tool attribution (bash) is clear
- [ ] Sequential ordering enforced
- [ ] Variable substitution ($PLUGIN_NAME) is consistent

**Token impact:** -80 tokens (structural efficiency)

### Fix 2.2: Simplify Success Output
**Location:** Lines 34-43
**Operation:** REPLACE
**Severity:** MEDIUM (optimization)

**Before:**
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

**After:**
```markdown
## Success Output

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

**Verification:**
- [ ] Success message is concise and imperative
- [ ] Testing checklist is clear without redundant prose
- [ ] Variable substitution ($PLUGIN_NAME) is used

**Token impact:** -40 tokens (removed redundant prose)

### Fix 2.3: Structure Error Handling
**Location:** Lines 45-69
**Operation:** REPLACE
**Severity:** MEDIUM (optimization)

**Before:**
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

## Technical Context

Build path structure:
```
build/
  plugins/
    [PluginName]/
      [PluginName]_artefacts/
        Debug/
          Standalone/
            [PluginName].app
```

This differs from the standard install location and is specific to the build directory.
```

**After:**
```markdown
## Troubleshooting

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

## Technical Context

Build path structure:
```
build/
  plugins/
    [PluginName]/
      [PluginName]_artefacts/
        Debug/
          Standalone/
            [PluginName].app
```

Note: This differs from the standard install location and is specific to the build directory.
```

**Verification:**
- [ ] Error conditions are machine-readable
- [ ] Remediation steps are numbered and imperative
- [ ] Variable substitution ($PLUGIN_NAME) is consistent
- [ ] Technical context section is preserved

**Token impact:** -30 tokens (structural efficiency)

## File Operations Manifest

**Files to modify:**
1. `.claude/commands/show-standalone.md` - All fixes apply to this file

**Files to create:**
None

**Files to archive:**
None

## Execution Checklist

**Phase 1 (Critical):**
- [ ] YAML frontmatter includes `allowed-tools: [bash]`
- [ ] Preconditions wrapped in `<preconditions enforcement="validate_before_execute">`
- [ ] XML checks specify target, condition, and path/scope
- [ ] Precondition failure provides clear error messaging

**Phase 2 (Polish):**
- [ ] Execution sequence structured in `<execution_sequence>` tags
- [ ] Steps include order, required/conditional attributes
- [ ] Tool attribution explicit (tool="bash")
- [ ] Success output uses `<success_response>` structure
- [ ] Error handling uses `<error_handling>` with structured conditions
- [ ] All variable substitution uses consistent format ($PLUGIN_NAME)
- [ ] Redundant prose removed while maintaining clarity

**Final Verification:**
- [ ] Command loads without errors
- [ ] Command appears in `/help` with correct description
- [ ] Bash tool access works without permission errors
- [ ] Precondition validation occurs before execution
- [ ] Health score improved from 28/40 to estimated 38/40

## Estimated Impact

**Before:**
- Health score: 28/40
- Line count: 77 lines
- Token count: ~800 tokens
- Critical issues: 2
- XML enforcement: None

**After:**
- Health score: 38/40 (target)
- Line count: 85 lines (slight increase due to XML structure)
- Token count: ~650 tokens
- Critical issues: 0
- XML enforcement: Full (preconditions, execution, output, errors)

**Improvement:** +10 health points, -19% tokens, full structural enforcement

## Notes

- This is a direct-execution command (no skill routing needed)
- Command is stateless (no .continue-here.md or PLUGINS.md interaction)
- XML structure adds slight verbosity but improves reliability under token pressure
- Variable substitution standardized to $PLUGIN_NAME throughout
- All bash operations now properly declared in allowed-tools
