# Archived Commands

Commands that have been deprecated and replaced by skills.

## troubleshoot-juce.md
**Replaced by:** deep-research skill (automatic invocation)
**Deprecated:** Phase 7 (2025-11)
**Reason:** Skills provide better integration with build-automation failure protocols

The troubleshooting workflow transitioned from user-initiated command to Claude-initiated skill because:
1. **Automatic activation** - Claude can invoke during build failures without user knowing the command
2. **Contextual awareness** - Skill has access to current plugin, build output, error context
3. **Seamless integration** - Directly integrates with build-automation and troubleshooting-docs skills
4. **Discovery through use** - Users don't need to remember command syntax

To troubleshoot JUCE build issues:
- Say "investigate this error" or "research this problem"
- Choose "Investigate" option in build failure decision menus
- Claude will automatically invoke the deep-research skill
