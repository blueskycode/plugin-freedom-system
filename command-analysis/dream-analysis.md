# Command Analysis: dream

## Executive Summary
- Overall health: **Yellow** (Functional but lacks structural enforcement)
- Critical issues: **3** (No XML enforcement, implicit routing logic, missing precondition checks)
- Optimization opportunities: **4** (Structure enforcement, explicit routing, argument handling, output documentation)
- Estimated context savings: **150 tokens (28% reduction)**

## Dimension Scores (1-5)
1. Structure Compliance: **4/5** (Has YAML frontmatter with description, missing argument-hint)
2. Routing Clarity: **3/5** (Routing described but mixed with behavior details, not structurally enforced)
3. Instruction Clarity: **4/5** (Clear behavior description, needs imperative restructuring)
4. XML Organization: **2/5** (No XML structure, relies on prose descriptions)
5. Context Efficiency: **4/5** (Compact at 54 lines, some redundancy in route descriptions)
6. Claude-Optimized Language: **3/5** (Mix of descriptive and imperative, needs conversion to direct commands)
7. System Integration: **4/5** (Documents output files well, missing state file interactions)
8. Precondition Enforcement: **2/5** (States "None" but actually needs PLUGINS.md check for plugin-specific mode)

## Critical Issues (blockers for Claude comprehension)

### Issue #1: Routing Logic Not Structurally Enforced (Lines 13-29)
**Severity:** CRITICAL
**Impact:** Claude may implement routing incorrectly or skip decision logic under token pressure

Current approach uses prose to describe routing:
```markdown
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
```

**Problem:** The routing mapping is not structurally enforced. Claude must parse natural language to understand the skill invocation logic.

**Recommended Fix:** Use XML structure with explicit routing rules:
```xml
<routing_protocol>
  <argument_check>
    <case condition="no_argument">
      <action>Present interactive menu with 5 options</action>
      <menu>
        <option id="1" label="New plugin idea" route_to="plugin-ideation" mode="new"/>
        <option id="2" label="Improve existing plugin" route_to="plugin-ideation" mode="improvement"/>
        <option id="3" label="Create UI mockup" route_to="ui-mockup"/>
        <option id="4" label="Create aesthetic template" route_to="aesthetic-dreaming"/>
        <option id="5" label="Research problem" route_to="deep-research"/>
      </menu>
    </case>

    <case condition="plugin_name_provided">
      <precondition check="PLUGINS.md" action="verify_existence"/>
      <if_exists>
        <action>Present plugin-specific menu (improvement, mockup, research)</action>
      </if_exists>
      <if_not_exists>
        <action>Route to plugin-ideation skill for creative brief</action>
      </if_not_exists>
    </case>
  </argument_check>
</routing_protocol>
```

**Token Savings:** ~80 tokens (converts 15 lines of prose to structured XML that's faster to parse)

### Issue #2: Preconditions Falsely Stated (Lines 40-42)
**Severity:** HIGH
**Impact:** Claude may skip necessary validation check, causing errors

Current statement:
```markdown
## Preconditions

None - brainstorming is always available.
```

**Problem:** This is incorrect. When a plugin name is provided (line 36-38), the command MUST check PLUGINS.md to determine routing. The "None" statement conflicts with the actual behavior.

**Recommended Fix:** Replace with accurate preconditions:
```xml
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

**Token Savings:** ~20 tokens (clearer structure reduces parsing ambiguity)

### Issue #3: Implicit Argument Handling (Lines 8-38)
**Severity:** HIGH
**Impact:** Missing YAML argument-hint prevents autocomplete, unclear parameter behavior

Current YAML frontmatter:
```yaml
---
name: dream
description: Explore plugin ideas without implementing
---
```

**Problem:** Missing `argument-hint` field means Claude Code cannot provide autocomplete for the optional parameter, reducing discoverability.

**Recommended Fix:** Add argument-hint to frontmatter:
```yaml
---
name: dream
description: Explore plugin ideas without implementing
argument-hint: "[concept or PluginName?]"
---
```

And restructure argument handling with explicit instructions:
```xml
<argument_handling>
  <parameter name="concept_or_name" optional="true">
    If provided:
    - Check if $1 matches existing plugin in PLUGINS.md
    - If match found: Route to plugin-specific menu
    - If no match: Route to plugin-ideation skill with concept as seed

    If not provided:
    - Present interactive discovery menu (5 options)
  </parameter>
</argument_handling>
```

**Token Savings:** ~30 tokens (structured conditional vs prose description)

## Optimization Opportunities

### Optimization #1: Convert Prose to Imperative Commands (Lines 13-38)
**Potential savings:** 40 tokens (15% reduction)
**Current:** Descriptive language ("Present interactive menu", "Route based on selection")
**Recommended:** Direct imperative instructions

Before:
```markdown
**Without argument:**
Present interactive menu:
```
What would you like to explore?
...
```

Route based on selection:
```

After:
```markdown
<no_argument_flow>
  1. Present menu: "What would you like to explore?" with 5 numbered options
  2. Capture user selection (1-5)
  3. Invoke corresponding skill via Skill tool using routing table
</no_argument_flow>
```

### Optimization #2: Extract Menu Template (Lines 14-22)
**Potential savings:** Improves maintainability, centralizes menu definition
**Current:** Menu text inline in command
**Recommended:** Reference menu template from skill asset

Before:
```markdown
Present interactive menu:
```
What would you like to explore?

1. New plugin idea
2. Improve existing plugin
3. Create UI mockup
4. Create aesthetic template
5. Research problem
```
```

After:
```xml
<menu source=".claude/skills/plugin-ideation/assets/discovery-menu.txt">
  Read menu template from asset file and present to user.
  Map selections to skills using routing table.
</menu>
```

Create template file at `.claude/skills/plugin-ideation/assets/discovery-menu.txt`:
```
What would you like to explore?

1. New plugin idea
2. Improve existing plugin
3. Create UI mockup
4. Create aesthetic template
5. Research problem
```

**Benefit:** Single source of truth for menu, reduces duplication if menu appears in multiple places

### Optimization #3: Consolidate Output Documentation (Lines 44-53)
**Potential savings:** 20 tokens (20% reduction in output section)
**Current:** List of 5 different output patterns
**Recommended:** Reference centralized documentation

Before:
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

After:
```xml
<output_contract>
  All /dream operations create documentation in `.ideas/` subdirectories.
  No implementation occurs - purely exploratory.

  See skill-specific documentation for file patterns:
  - plugin-ideation → creative-brief.md, improvements/
  - ui-mockup → mockups/v[N]-*
  - aesthetic-dreaming → .claude/aesthetics/
  - deep-research → troubleshooting/
</output_contract>
```

### Optimization #4: Add State File Documentation (Missing)
**Potential savings:** Clarifies system integration
**Current:** No mention of state file interactions
**Recommended:** Document which state files are read

```xml
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

## Implementation Priority

1. **Immediate** (Critical issues blocking comprehension)
   - Issue #1: Add XML routing structure with explicit skill mapping
   - Issue #2: Fix preconditions to accurately reflect PLUGINS.md check
   - Issue #3: Add argument-hint to YAML frontmatter

2. **High** (Major optimizations)
   - Optimization #1: Convert prose to imperative commands
   - Optimization #4: Add state file documentation

3. **Medium** (Minor improvements)
   - Optimization #2: Extract menu template to asset file
   - Optimization #3: Consolidate output documentation

## Recommended Refactored Structure

```yaml
---
name: dream
description: Explore plugin ideas without implementing
argument-hint: "[concept or PluginName?]"
---

# /dream - Plugin Ideation & Exploration

<purpose>
Entry point for all exploratory activities: brainstorming, improving, designing, researching.
Routes to appropriate skill based on argument and user selection.
</purpose>

<argument_handling>
  <parameter name="concept_or_name" optional="true">
    If provided: Check PLUGINS.md for existing plugin match
    If not provided: Present interactive discovery menu
  </parameter>
</argument_handling>

<preconditions enforcement="conditional">
  <check condition="plugin_name_provided">
    <target>PLUGINS.md</target>
    <validation>Verify plugin existence to determine routing</validation>
  </check>
</preconditions>

<routing_protocol>
  <case condition="no_argument">
    <step order="1">Present discovery menu with 5 options</step>
    <step order="2">Invoke selected skill via Skill tool</step>

    <skill_mapping>
      <option id="1" skill="plugin-ideation" mode="new"/>
      <option id="2" skill="plugin-ideation" mode="improvement"/>
      <option id="3" skill="ui-mockup"/>
      <option id="4" skill="aesthetic-dreaming"/>
      <option id="5" skill="deep-research"/>
    </skill_mapping>
  </case>

  <case condition="plugin_exists">
    <step order="1">Present plugin-specific menu (improve, mockup, research)</step>
    <step order="2">Invoke selected skill with plugin context</step>
  </case>

  <case condition="plugin_not_exists">
    <step>Invoke plugin-ideation skill with concept as seed</step>
  </case>
</routing_protocol>

<state_files>
  <reads>
    <file>PLUGINS.md</file>
    <purpose>Check plugin existence when name provided</purpose>
  </reads>
</state_files>

<output_contract>
  All /dream operations create documentation only - no implementation.
  Output locations managed by invoked skills.
</output_contract>
```

**Token count:**
- Before: ~540 tokens
- After: ~390 tokens
- **Savings: 150 tokens (28% reduction)**

## Verification Checklist

After implementing fixes, verify:
- [x] YAML frontmatter includes `argument-hint`
- [x] Preconditions accurately reflect PLUGINS.md check requirement
- [x] Routing logic wrapped in XML with explicit skill mapping
- [x] Command under 200 lines (currently 54, will remain compact)
- [x] State file interactions documented
- [x] All prose converted to imperative commands
- [ ] Menu template extracted to asset file (optional enhancement)
- [x] Clear separation between routing logic and skill behavior

## Notes

The `/dream` command is fundamentally sound but suffers from:
1. **Implicit behavior** - Routing logic described in prose rather than structured
2. **False preconditions** - Claims "None" but actually checks PLUGINS.md
3. **Missing discovery** - No argument-hint prevents autocomplete

The refactored version maintains the same behavior while making the routing logic explicit and structurally enforced. This ensures Claude can reliably execute the command even under token pressure or context compression.

The command is already compact (54 lines), so the primary benefit is **clarity and reliability** rather than dramatic token savings. The XML structure makes it impossible to misinterpret the routing rules.
