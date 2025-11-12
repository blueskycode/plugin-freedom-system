---
name: improve
description: Modify completed plugins with versioning
argument-hint: "[PluginName] [description?]"
---

# /improve

When user runs `/improve [PluginName] [description?]`, route based on argument presence (see Routing section below).

## Preconditions

<preconditions enforcement="blocking">
  <status_verification target="PLUGINS.md" required="true">
    <check condition="plugin_exists">
      Plugin entry MUST exist in PLUGINS.md
    </check>

    <check condition="status_in(✅ Working, 📦 Installed)">
      Status MUST be ✅ Working OR 📦 Installed

      <on_violation status="🚧 In Development">
        REJECT with message:
        "[PluginName] is still in development (Stage [N]).
        Complete the workflow first with /continue [PluginName].
        Cannot use /improve on in-progress plugins."
      </on_violation>

      <on_violation status="💡 Ideated">
        REJECT with message:
        "[PluginName] is not implemented yet (Status: 💡 Ideated).
        Use /implement [PluginName] to build it first."
      </on_violation>

      <on_violation status="[any other status]">
        REJECT with message:
        "[PluginName] has status '[Status]' in PLUGINS.md.
        Only ✅ Working or 📦 Installed plugins can be improved."
      </on_violation>
    </check>
  </status_verification>
</preconditions>

## Routing

<routing_logic>
  <decision_gate type="argument_routing">
    <path condition="no_plugin_name">
      Read PLUGINS.md and filter for plugins with status ✅ Working OR 📦 Installed

      <menu_presentation>
        Display: "Which plugin would you like to improve?"

        [Numbered list of completed plugins with status emoji]

        Example:
        1. DriveVerb (📦 Installed)
        2. CompressorPro (✅ Working)
        3. Other (specify name)

        WAIT for user selection
      </menu_presentation>

      After selection, proceed to path condition="plugin_name_only"
    </path>

    <path condition="plugin_name_only">
      Check for existing improvement briefs in plugins/[PluginName]/improvements/*.md

      <decision_menu>
        IF briefs exist:
          Display:
          "What would you like to improve in [PluginName]?

          1. From existing brief: [brief-name-1].md
          2. From existing brief: [brief-name-2].md
          3. Describe a new change"

        IF no briefs:
          Display:
          "What would you like to improve in [PluginName]?

          Describe the change:"

        WAIT for user response
      </decision_menu>

      After description provided, proceed to vagueness_check
    </path>

    <path condition="plugin_name_and_description">
      Perform vagueness_check (see below)

      <vagueness_check>
        IF request is vague:
          Present vagueness handling menu (see Vagueness Detection section)
        ELSE IF request is specific:
          Proceed to plugin-improve skill with Phase 0.5 investigation
      </vagueness_check>
    </path>
  </decision_gate>

  <skill_invocation trigger="after_routing_complete">
    Once plugin name and specific description are obtained, invoke plugin-improve skill:

    <invocation_syntax>
      Use Skill tool: skill="plugin-improve"

      Pass context:
      - pluginName: [name]
      - description: [specific change description]
      - vagueness_resolution: [if applicable, which path user chose from vagueness menu]
    </invocation_syntax>
  </skill_invocation>
</routing_logic>

## Vagueness Detection

<vagueness_detection>
  <criteria>
    Request IS vague if it lacks ANY of:
    <required_element>Specific feature name (parameter, UI component, DSP element)</required_element>
    <required_element>Specific action (add, fix, remove, modify, increase, decrease)</required_element>
    <required_element>Acceptance criteria (range, value, behavior, constraint)</required_element>
  </criteria>

  <evaluation_pattern>
    Parse user description for presence of:
    - Feature identifier: Look for component names, parameter names, specific UI elements
    - Action verb: Look for add/fix/remove/modify/increase/decrease/change
    - Measurable criteria: Look for numbers, ranges, specific behaviors, constraints

    IF any element missing → classify as VAGUE
    ELSE → classify as SPECIFIC
  </evaluation_pattern>

  <examples>
    <vague_examples>
      - "improve the filters" (lacks: which filter? what aspect? how much?)
      - "better presets" (lacks: better how? which preset? specific values?)
      - "UI feels cramped" (lacks: which component? by how much? specific dimension?)
    </vague_examples>

    <specific_examples>
      - "add resonance parameter to filter, range 0-1" (has: feature=resonance, action=add, criteria=range 0-1)
      - "fix bypass parameter - not muting audio" (has: feature=bypass, action=fix, criteria=mute audio)
      - "increase window height to 500px" (has: feature=height, action=increase, criteria=500px)
    </specific_examples>
  </examples>

  <decision_gate type="vagueness_handling">
    <condition check="request_is_vague">
      IF vague:
        Present choice menu:
        ```
        Your request is vague. How should I proceed?

        1. Brainstorm approaches first → creates improvement brief in plugins/[Name]/improvements/
        2. Just implement something reasonable → Phase 0.5 investigation (I'll propose a specific approach)

        Choose (1-2):
        ```
        WAIT for user response

        IF user chooses 1 (brainstorm):
          Invoke plugin-ideation skill in improvement mode
        ELSE IF user chooses 2 (implement):
          Proceed to plugin-improve skill with Phase 0.5 investigation
    </condition>

    <condition check="request_is_specific">
      IF specific:
        Proceed directly to plugin-improve skill with Phase 0.5 investigation
    </condition>
  </decision_gate>
</vagueness_detection>

## Plugin-Improve Workflow

<skill_workflow>
  The plugin-improve skill executes a complete improvement cycle:

  <workflow_overview>
    1. Investigation (Phase 0.5 root cause analysis)
    2. Approval gate (user confirmation)
    3. Version selection (PATCH/MINOR/MAJOR)
    4. Backup → Implement → Document → Build → Deploy
  </workflow_overview>

  <reference>
    See plugin-improve skill documentation for full 10-step workflow details.
  </reference>

  <output_guarantee>
    Changes are production-ready:
    - Versioned and backed up (backups/[Plugin]/v[X.Y.Z]/)
    - Built in Release mode
    - Installed to system folders
    - Documented in CHANGELOG
    - Git history preserved (commit + tag)
  </output_guarantee>
</skill_workflow>

## State Management

<state_management>
  <files_read>
    - PLUGINS.md (precondition check: status must be ✅ or 📦)
    - plugins/[PluginName]/.ideas/plan.md (workflow context)
    - plugins/[PluginName]/CHANGELOG.md (version history)
    - plugins/[PluginName]/improvements/*.md (existing improvement briefs)
  </files_read>

  <files_written>
    - plugins/[PluginName]/CHANGELOG.md (version and changes)
    - plugins/[PluginName]/backups/v[X.Y.Z]/* (pre-change backup)
    - PLUGINS.md (Last Updated timestamp)
  </files_written>

  <git_operations>
    - Commit: "feat([Plugin]): [description] (v[X.Y.Z])"
    - Tag: "v[X.Y.Z]"
  </git_operations>
</state_management>
