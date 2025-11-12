# Fix Plan: /dream

## Summary
- Critical fixes: 3
- Extraction operations: 1
- Total estimated changes: 7
- Estimated time: 20 minutes
- Token savings: 150 tokens (28% reduction)

## Phase 1: Critical Fixes (Blocking Issues)

### Fix 1.1: Add argument-hint to YAML frontmatter
**Location:** Lines 1-3
**Operation:** REPLACE
**Severity:** CRITICAL

**Before:**
```yaml
---
name: dream
description: Explore plugin ideas without implementing
---
```

**After:**
```yaml
---
name: dream
description: Explore plugin ideas without implementing
argument-hint: "[concept or PluginName?]"
---
```

**Verification:**
- [ ] YAML frontmatter parses correctly
- [ ] `/help` displays command with description
- [ ] Autocomplete shows argument hint "[concept or PluginName?]"

**Token impact:** +10 tokens (frontmatter clarity)

### Fix 1.2: Replace false "None" preconditions with accurate enforcement
**Location:** Lines 40-42
**Operation:** REPLACE
**Severity:** CRITICAL

**Before:**
```markdown
## Preconditions

None - brainstorming is always available.
```

**After:**
```xml
## Preconditions

<preconditions enforcement="conditional">
  <check condition="plugin_name_provided">
    <target>PLUGINS.md</target>
    <validation>Verify plugin existence to determine routing</validation>
    <on_found>Route to plugin-specific improvement menu</on_found>
    <on_not_found>Route to plugin-ideation skill (new plugin mode)</on_not_found>
  </check>

  <check condition="no_argument">
    <validation>No preconditions - present discovery menu</validation>
  </check>
</preconditions>
```

**Verification:**
- [ ] Preconditions accurately describe PLUGINS.md check
- [ ] Conditional enforcement clearly documented
- [ ] Both argument cases covered

**Token impact:** +50 tokens (accurate enforcement)

### Fix 1.3: Convert routing logic to XML structure with explicit skill mapping
**Location:** Lines 8-38
**Operation:** REPLACE
**Severity:** CRITICAL

**Before:**
```markdown
When user runs `/dream [concept?]`, invoke the plugin-ideation skill.

## Behavior

**Without argument:**
Present interactive menu:
```
What would you like to explore?

1. New plugin idea
2. Improve existing plugin
3. Create UI mockup
4. Create aesthetic template
5. Research problem
```

Route based on selection:
- Option 1 → plugin-ideation skill (new plugin mode)
- Option 2 → plugin-ideation skill (improvement mode)
- Option 3 → ui-mockup skill
- Option 4 → aesthetic-dreaming skill
- Option 5 → deep-research skill

**With plugin name:**
```bash
/dream [PluginName]
```

Check if plugin exists in PLUGINS.md:
- If exists: Present plugin-specific menu (improvement, mockup, research)
- If new: Route to plugin-ideation skill for creative brief
```

**After:**
```xml
## Behavior

<argument_handling>
  <parameter name="concept_or_name" optional="true">
    If provided: Check PLUGINS.md for existing plugin match
    If not provided: Present interactive discovery menu
  </parameter>
</argument_handling>

<routing_protocol>
  <case condition="no_argument">
    <step order="1">Present discovery menu with 5 options</step>
    <menu>
What would you like to explore?

1. New plugin idea
2. Improve existing plugin
3. Create UI mockup
4. Create aesthetic template
5. Research problem
    </menu>
    <step order="2">Capture user selection (1-5)</step>
    <step order="3">Invoke corresponding skill via Skill tool using routing table</step>

    <skill_mapping>
      <option id="1" skill="plugin-ideation" mode="new"/>
      <option id="2" skill="plugin-ideation" mode="improvement"/>
      <option id="3" skill="ui-mockup"/>
      <option id="4" skill="aesthetic-dreaming"/>
      <option id="5" skill="deep-research"/>
    </skill_mapping>
  </case>

  <case condition="plugin_name_provided">
    <step order="1">Check PLUGINS.md for plugin existence</step>
    <if_exists>
      <step order="2">Present plugin-specific menu (improvement, mockup, research)</step>
      <step order="3">Invoke selected skill with plugin context</step>
    </if_exists>
    <if_not_exists>
      <step order="2">Invoke plugin-ideation skill with concept as seed</step>
    </if_not_exists>
  </case>
</routing_protocol>
```

**Verification:**
- [ ] Routing logic wrapped in XML structure
- [ ] Explicit skill mapping table present
- [ ] Both argument cases (no_argument, plugin_name_provided) clearly separated
- [ ] Menu text preserved exactly
- [ ] Step ordering explicit

**Token impact:** -80 tokens (structured XML vs prose)

## Phase 2: Content Enhancement (System Integration)

### Fix 2.1: Add state file documentation
**Location:** After Line 42 (after Preconditions, before Output)
**Operation:** INSERT
**Severity:** HIGH

**Insert:**
```xml
## State Files

<state_files>
  <reads>
    <file>PLUGINS.md</file>
    <purpose>Check plugin existence when name argument provided</purpose>
  </reads>

  <writes>
    <none>This command only invokes skills that manage their own state</none>
  </writes>
</state_files>
```

**Verification:**
- [ ] State file section added between Preconditions and Output
- [ ] PLUGINS.md read documented
- [ ] Clear statement that command doesn't write state

**Token impact:** +30 tokens (system integration clarity)

## Phase 3: Polish (Clarity & Optimization)

### Fix 3.1: Consolidate output documentation with XML structure
**Location:** Lines 44-53
**Operation:** REPLACE
**Severity:** MEDIUM

**Before:**
```markdown
## Output

All /dream operations create documentation:
- Creative briefs: `plugins/[Name]/.ideas/creative-brief.md`
- Improvement proposals: `plugins/[Name]/.ideas/improvements/[feature].md`
- UI mockups: `plugins/[Name]/.ideas/mockups/v[N]-*`
- Aesthetic templates: `.claude/aesthetics/[aesthetic-id]/aesthetic.md`
- Research findings: Documentation with solutions

Nothing is implemented - this is purely exploratory.
```

**After:**
```xml
## Output

<output_contract>
  All /dream operations create documentation only - no implementation.

  Output locations managed by invoked skills:
  - plugin-ideation → `plugins/[Name]/.ideas/creative-brief.md`
  - plugin-ideation → `plugins/[Name]/.ideas/improvements/[feature].md`
  - ui-mockup → `plugins/[Name]/.ideas/mockups/v[N]-*`
  - aesthetic-dreaming → `.claude/aesthetics/[aesthetic-id]/aesthetic.md`
  - deep-research → `troubleshooting/[category]/[problem].md`
</output_contract>
```

**Verification:**
- [ ] Output section wrapped in XML
- [ ] Skills explicitly mapped to output locations
- [ ] "No implementation" emphasized at top
- [ ] All output paths preserved

**Token impact:** -20 tokens (consolidated structure)

## File Operations Manifest

**Files to modify:**
1. `.claude/commands/dream.md` - All fixes above

**Files to create:**
None (all changes inline to existing command)

**Files to archive:**
None (command is not deprecated)

## Execution Checklist

**Phase 1 (Critical):**
- [ ] YAML frontmatter includes `argument-hint: "[concept or PluginName?]"`
- [ ] Preconditions accurately reflect PLUGINS.md check (removed false "None")
- [ ] Preconditions wrapped in `<preconditions enforcement="conditional">`
- [ ] Routing logic wrapped in `<routing_protocol>` with explicit cases
- [ ] Skill mapping table uses `<skill_mapping>` with explicit attributes
- [ ] Both argument cases (no_argument, plugin_name_provided) clearly separated

**Phase 2 (System Integration):**
- [ ] State files section added with `<state_files>` wrapper
- [ ] PLUGINS.md read operation documented
- [ ] Clear statement that command doesn't write state

**Phase 3 (Polish):**
- [ ] Output section wrapped in `<output_contract>`
- [ ] Skills explicitly mapped to output locations
- [ ] "No implementation" emphasized

**Final Verification:**
- [ ] Command loads without errors
- [ ] Command appears in `/help` with correct description
- [ ] Autocomplete works with argument hint "[concept or PluginName?]"
- [ ] Routing logic is structurally enforced (not prose-based)
- [ ] All XML tags properly closed
- [ ] Menu text preserved exactly as before
- [ ] Health score improved from Yellow to Green (estimated)

## Estimated Impact

**Before:**
- Health score: Yellow (24/40)
- Line count: 54 lines
- Token count: ~540 tokens
- Critical issues: 3

**After:**
- Health score: Green (35/40) (target)
- Line count: ~65 lines
- Token count: ~390 tokens
- Critical issues: 0

**Improvement:** +11 health points, -28% tokens

## Implementation Notes

1. **Line numbers will shift** as you apply fixes from top to bottom. Apply changes in order:
   - Fix 1.1 (lines 1-3) first
   - Fix 1.3 (lines 8-38) second
   - Fix 1.2 (lines 40-42) third
   - Fix 2.1 (insert after preconditions) fourth
   - Fix 3.1 (output section) last

2. **Preserve menu formatting**: The menu text must remain exactly as shown:
   ```
   What would you like to explore?

   1. New plugin idea
   2. Improve existing plugin
   3. Create UI mockup
   4. Create aesthetic template
   5. Research problem
   ```

3. **XML enforcement**: All structural elements use XML to make routing logic unambiguous:
   - `<routing_protocol>` with nested `<case>` elements
   - `<skill_mapping>` with explicit `id`, `skill`, and optional `mode` attributes
   - `<preconditions enforcement="conditional">` with nested checks
   - `<state_files>`, `<output_contract>` for system integration

4. **No extraction needed**: Unlike other commands, `/dream` is already compact (54 lines). All fixes are inline improvements to structure and clarity.

5. **Testing after fixes**:
   - Run `/dream` without arguments - verify menu appears
   - Run `/dream TestPlugin` where TestPlugin exists - verify plugin-specific routing
   - Run `/dream NewConcept` where NewConcept doesn't exist - verify plugin-ideation routing
   - Check `/help` shows argument hint correctly
