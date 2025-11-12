---
name: dream
description: Explore plugin ideas without implementing
argument-hint: "[concept or PluginName?]"
---

# /dream

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
