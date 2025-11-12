---
name: test
description: Validate plugins through automated tests
---

# /test

When user runs `/test [PluginName?] [mode?]`, invoke the plugin-testing skill or build-automation skill.

## Preconditions

<preconditions enforcement="blocking">
  <check target="PLUGINS.md" condition="plugin_exists">
    Plugin entry MUST exist in PLUGINS.md
  </check>
  <check target="PLUGINS.md::status" condition="not_equals(💡 Ideated)">
    Status MUST NOT be 💡 Ideated (requires implementation to test)
  </check>
  <rejection_message status="💡 Ideated">
[PluginName] is not implemented yet (Status: 💡 Ideated).
Use /implement [PluginName] to build it first.
  </rejection_message>
</preconditions>

<state_interactions>
  <reads>
    - PLUGINS.md (plugin status, test capabilities)
  </reads>
  <writes>
    - None (testing results logged to console, skills handle any state updates)
  </writes>
</state_interactions>

## Three Test Methods

<routing_logic>
  <mode name="automated" argument="automated">
    <requirement path="plugins/{PluginName}/Tests/" type="directory" />
    <routes_to skill="plugin-testing" />
    <duration estimate="2 minutes" />
    <tests>
      - Parameter stability (all combinations, edge cases)
      - State save/restore (preset corruption)
      - Processing stability (buffer sizes, sample rates)
      - Thread safety (concurrent access)
      - Edge case handling (silence, extremes, denormals)
    </tests>
  </mode>

  <mode name="build" argument="build">
    <requirement>Always available (no dependencies)</requirement>
    <routes_to skill="build-automation" />
    <duration estimate="5-10 minutes" />
    <steps>
      1. Build Release mode (VST3 + AU)
      2. Run pluginval with strict settings (level 10)
      3. Install to system folders
      4. Clear DAW caches
    </steps>
  </mode>

  <mode name="manual" argument="manual">
    <requirement>Always available</requirement>
    <routes_to>Display checklist directly (no skill invocation)</routes_to>
    <checklist_items>
      - Load & initialize
      - Audio processing
      - Parameter testing
      - State management
      - Performance
      - Compatibility
      - Stress testing
    </checklist_items>
  </mode>
</routing_logic>

## Behavior

<behavior>
  <case arguments="none">
    List available plugins with test status from PLUGINS.md
  </case>
  <case arguments="plugin_only">
    Present test method decision menu (adapt based on Tests/ directory existence)
  </case>
  <case arguments="plugin_and_mode">
    Execute test directly via appropriate skill
  </case>
</behavior>

## Integration

This command is also auto-invoked by plugin-workflow after Stage 4 (DSP) and Stage 5 (GUI).

## Error Handling

<error_handling>
  <on_failure type="automated_tests|build|pluginval">
    Present standard failure menu:
    1. Investigate (trigger deep-research skill)
    2. Show me the code
    3. Show full output
    4. I'll fix it manually (or continue anyway for pluginval)
  </on_failure>
</error_handling>

## Output

After successful testing, display:
- Success message with test method
- Next step suggestions (manual DAW testing, /improve if issues found)
