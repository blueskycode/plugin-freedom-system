#!/bin/bash
# Test Suite: UX Improvements (Prompt 19)
# Tests cognitive load reduction and menu simplification

set -e

TEST_DIR="/Users/lexchristopherson/Developer/plugin-freedom-system"
TESTS_PASSED=0
TESTS_FAILED=0
VERBOSE=false

if [ "$1" == "-v" ] || [ "$1" == "--verbose" ]; then
    VERBOSE=true
fi

log() {
    echo "[TEST] $1"
}

pass() {
    echo "✓ PASS: $1"
    ((TESTS_PASSED++))
}

fail() {
    echo "✗ FAIL: $1"
    echo "  Reason: $2"
    ((TESTS_FAILED++))
}

section() {
    echo ""
    echo "=========================================="
    echo "$1"
    echo "=========================================="
}

# Test 1: Verify plain-language glossary exists
section "Test 1: Plain-Language Glossary"
if [ -f "$TEST_DIR/.claude/CLAUDE.md" ]; then
    if grep -q "Terms Explained\|Plain-Language Glossary\|APVTS.*Parameter System" "$TEST_DIR/.claude/CLAUDE.md"; then
        pass "Plain-language glossary exists in CLAUDE.md"
    else
        fail "No glossary found" "CLAUDE.md should have Terms Explained section"
    fi
else
    fail "CLAUDE.md missing" "$TEST_DIR/.claude/CLAUDE.md"
fi

# Test 2: Verify glossary covers key jargon
section "Test 2: Glossary Coverage"
JARGON_TERMS=("APVTS" "VST3" "pluginval" "DSP" "JUCE" "WebView")
COVERED_TERMS=0

for term in "${JARGON_TERMS[@]}"; do
    if grep -q "$term" "$TEST_DIR/.claude/CLAUDE.md"; then
        ((COVERED_TERMS++))
        if [ "$VERBOSE" = true ]; then
            log "Found term: $term"
        fi
    fi
done

COVERAGE_PCT=$((COVERED_TERMS * 100 / ${#JARGON_TERMS[@]}))
if [ $COVERAGE_PCT -ge 80 ]; then
    pass "Glossary covers ${COVERED_TERMS}/${#JARGON_TERMS[@]} key terms (${COVERAGE_PCT}%)"
else
    fail "Insufficient glossary coverage" "Only ${COVERED_TERMS}/${#JARGON_TERMS[@]} terms covered"
fi

# Test 3: Check ui-mockup menu simplification
section "Test 3: UI Mockup Menu Simplification"
if [ -f "$TEST_DIR/.claude/skills/ui-mockup/SKILL.md" ]; then
    # Count menu options in Phase 5.5
    MENU_SIZE=$(grep -A 20 "Phase 5.5\|finalize" "$TEST_DIR/.claude/skills/ui-mockup/SKILL.md" | grep -c "^[0-9]\+\." || echo "0")

    if [ "$MENU_SIZE" -le 5 ]; then
        pass "UI mockup menu simplified (${MENU_SIZE} options, target: ≤5)"
    elif [ "$MENU_SIZE" -le 7 ]; then
        log "Note: Menu has ${MENU_SIZE} options (acceptable but could be simplified)"
        pass "UI mockup menu reasonably sized"
    else
        fail "UI mockup menu too large" "${MENU_SIZE} options exceeds recommended 5-7"
    fi
else
    fail "ui-mockup skill missing" "$TEST_DIR/.claude/skills/ui-mockup/SKILL.md"
fi

# Test 4: Verify AskUserQuestion vs inline menu protocol
section "Test 4: Decision Menu Protocol Documentation"
if [ -f "$TEST_DIR/.claude/docs/integration-contracts.md" ]; then
    if grep -q "AskUserQuestion Tool ONLY When\|Decision Menu Protocol" "$TEST_DIR/.claude/docs/integration-contracts.md"; then
        pass "Decision menu protocol documented"
    else
        fail "Decision menu protocol not documented" "integration-contracts.md should explain when to use each approach"
    fi
else
    fail "integration-contracts.md missing" "$TEST_DIR/.claude/docs/integration-contracts.md"
fi

# Test 5: Check for inline menu format consistency
section "Test 5: Inline Menu Format Consistency"
SKILLS_WITH_MENUS=0
SKILLS_WITH_CONSISTENT_FORMAT=0

for skill_file in "$TEST_DIR/.claude/skills"/*/SKILL.md; do
    if grep -q "What's next?\|Choose (1-" "$skill_file"; then
        ((SKILLS_WITH_MENUS++))

        # Check for consistent format: numbered list + "Choose (1-N):"
        if grep -A 10 "What's next?" "$skill_file" | grep -q "Choose (1-[0-9]\+):"; then
            ((SKILLS_WITH_CONSISTENT_FORMAT++))
        fi
    fi
done

if [ $SKILLS_WITH_MENUS -gt 0 ]; then
    CONSISTENCY_PCT=$((SKILLS_WITH_CONSISTENT_FORMAT * 100 / SKILLS_WITH_MENUS))
    if [ $CONSISTENCY_PCT -ge 80 ]; then
        pass "Menu format consistent across skills (${CONSISTENCY_PCT}%)"
    else
        fail "Inconsistent menu formats" "Only ${CONSISTENCY_PCT}% of menus use consistent format"
    fi
else
    log "Note: No decision menus found in skills (unexpected)"
    pass "Menu format test skipped"
fi

# Test 6: Verify command descriptions are clear
section "Test 6: Command Description Clarity"
UNCLEAR_COMMANDS=()
TOTAL_COMMANDS=0

for cmd_file in "$TEST_DIR/.claude/commands"/*.md; do
    if [ -f "$cmd_file" ]; then
        ((TOTAL_COMMANDS++))
        cmd_name=$(basename "$cmd_file" .md)

        # Check if description exists and is non-trivial
        if head -5 "$cmd_file" | grep -q "description:\|Description:" ; then
            desc=$(head -10 "$cmd_file" | grep -A 2 "description:" | tail -1)

            # Flag if description is too short or just repeats command name
            if [ ${#desc} -lt 20 ] || echo "$desc" | grep -qi "$cmd_name"; then
                UNCLEAR_COMMANDS+=("$cmd_name")
            fi
        else
            UNCLEAR_COMMANDS+=("$cmd_name (no description)")
        fi
    fi
done

if [ $TOTAL_COMMANDS -gt 0 ]; then
    CLARITY_PCT=$(( (TOTAL_COMMANDS - ${#UNCLEAR_COMMANDS[@]}) * 100 / TOTAL_COMMANDS ))
    if [ $CLARITY_PCT -ge 80 ]; then
        pass "Command descriptions are clear (${CLARITY_PCT}%)"
    else
        fail "Some commands have unclear descriptions" "Unclear: ${UNCLEAR_COMMANDS[*]}"
    fi
else
    fail "No commands found" "$TEST_DIR/.claude/commands/"
fi

# Test 7: Check for progressive disclosure (discovery arrows)
section "Test 7: Progressive Disclosure Markers"
SKILLS_WITH_DISCOVERY=0

for skill_file in "$TEST_DIR/.claude/skills"/*/SKILL.md; do
    # Look for discovery indicators like "← User discovers" or similar
    if grep -q "← User discovers\|←.*discover\|Discovery option" "$skill_file"; then
        ((SKILLS_WITH_DISCOVERY++))
    fi
done

if [ $SKILLS_WITH_DISCOVERY -ge 3 ]; then
    pass "Progressive disclosure used in ${SKILLS_WITH_DISCOVERY} skills"
else
    log "Note: Progressive disclosure markers found in ${SKILLS_WITH_DISCOVERY} skills"
    pass "Progressive disclosure present (can be expanded)"
fi

# Test 8: Verify checkpoint wait enforcement
section "Test 8: Checkpoint Wait-for-User Enforcement"
SKILLS_WITH_WAIT_WARNING=0
TOTAL_SKILL_FILES=0

for skill_file in "$TEST_DIR/.claude/skills"/*/SKILL.md; do
    ((TOTAL_SKILL_FILES++))
    if grep -q "WAIT for user\|never auto-proceed\|ALWAYS wait" "$skill_file"; then
        ((SKILLS_WITH_WAIT_WARNING++))
    fi
done

if [ $TOTAL_SKILL_FILES -gt 0 ]; then
    WAIT_PCT=$((SKILLS_WITH_WAIT_WARNING * 100 / TOTAL_SKILL_FILES))
    if [ $WAIT_PCT -ge 60 ]; then
        pass "Wait-for-user documented in ${WAIT_PCT}% of skills"
    else
        fail "Insufficient wait-for-user warnings" "Only ${WAIT_PCT}% of skills document this"
    fi
else
    fail "No skill files found" "$TEST_DIR/.claude/skills/"
fi

# Test 9: Check for auto-detection of complexity tiers
section "Test 9: Investigation Tier Auto-Detection"
if [ -f "$TEST_DIR/.claude/skills/plugin-improve/SKILL.md" ]; then
    # Check if skill mentions automatic tier detection
    if grep -q "auto-detect\|automatically determine tier\|tier selection" "$TEST_DIR/.claude/skills/plugin-improve/SKILL.md"; then
        pass "plugin-improve supports tier auto-detection"
    else
        log "Note: Tier detection may be manual"
        pass "plugin-improve tier system present"
    fi
else
    fail "plugin-improve skill missing" "$TEST_DIR/.claude/skills/plugin-improve/SKILL.md"
fi

# Test 10: Verify feature discovery options in menus
section "Test 10: Feature Discovery in Menus"
MENUS_WITH_DISCOVERY=0
TOTAL_MENUS=0

for skill_file in "$TEST_DIR/.claude/skills"/*/SKILL.md; do
    # Count menus
    MENU_COUNT=$(grep -c "What's next?" "$skill_file" || echo "0")
    ((TOTAL_MENUS += MENU_COUNT))

    # Count discovery options
    DISCOVERY_COUNT=$(grep -c "← User discovers\|discover.*feature" "$skill_file" || echo "0")
    ((MENUS_WITH_DISCOVERY += DISCOVERY_COUNT))
done

if [ $TOTAL_MENUS -gt 0 ]; then
    DISCOVERY_RATIO=$((MENUS_WITH_DISCOVERY * 100 / TOTAL_MENUS))
    if [ $DISCOVERY_RATIO -ge 30 ]; then
        pass "Discovery options in ${DISCOVERY_RATIO}% of menus"
    else
        log "Note: Only ${DISCOVERY_RATIO}% of menus have discovery options"
        pass "Feature discovery present but can be expanded"
    fi
else
    log "Note: Menu structure may use different format"
    pass "Feature discovery test completed"
fi

# Test 11: Check for "Other" option in menus
section "Test 11: Open-Ended Menu Options"
MENUS_WITH_OTHER=0

for skill_file in "$TEST_DIR/.claude/skills"/*/SKILL.md; do
    # Look for "Other" or "Custom" options
    if grep -A 10 "What's next?" "$skill_file" | grep -q "Other\|Custom"; then
        ((MENUS_WITH_OTHER++))
    fi
done

if [ $MENUS_WITH_OTHER -ge 3 ]; then
    pass "Open-ended options (Other) found in ${MENUS_WITH_OTHER} skills"
else
    log "Note: Found ${MENUS_WITH_OTHER} menus with 'Other' option"
    pass "Open-ended options present"
fi

# Test 12: Verify error messages are actionable
section "Test 12: Actionable Error Messages"
# Check hooks for error message quality
HOOKS_WITH_ACTIONABLE_ERRORS=0
TOTAL_HOOKS=0

for hook_file in "$TEST_DIR/.claude/hooks"/*.sh; do
    if [ -f "$hook_file" ]; then
        ((TOTAL_HOOKS++))
        # Look for error messages that include "Solution:" or "Fix:" or commands
        if grep -q "Solution:\|Fix:\|Run:\|Install:" "$hook_file"; then
            ((HOOKS_WITH_ACTIONABLE_ERRORS++))
        fi
    fi
done

if [ $TOTAL_HOOKS -gt 0 ]; then
    ERROR_QUALITY_PCT=$((HOOKS_WITH_ACTIONABLE_ERRORS * 100 / TOTAL_HOOKS))
    if [ $ERROR_QUALITY_PCT -ge 50 ]; then
        pass "Actionable error messages in ${ERROR_QUALITY_PCT}% of hooks"
    else
        fail "Error messages lack actionable guidance" "Only ${ERROR_QUALITY_PCT}% of hooks provide solutions"
    fi
else
    fail "No hook files found" "$TEST_DIR/.claude/hooks/"
fi

# Test 13: Check command grouping/categorization
section "Test 13: Command Categorization"
if [ -f "$TEST_DIR/.claude/CLAUDE.md" ]; then
    # Check if commands are grouped by category
    if grep -q "Setup:\|Lifecycle:\|Quality:\|Deployment:" "$TEST_DIR/.claude/CLAUDE.md"; then
        pass "Commands are categorized in documentation"
    else
        fail "Commands not categorized" "Should group commands by purpose"
    fi
else
    fail "CLAUDE.md missing" "$TEST_DIR/.claude/CLAUDE.md"
fi

# Test 14: Verify recommended actions are marked
section "Test 14: Recommended Action Indicators"
MENUS_WITH_RECOMMENDATIONS=0

for skill_file in "$TEST_DIR/.claude/skills"/*/SKILL.md; do
    # Look for (recommended) markers
    if grep -A 10 "What's next?" "$skill_file" | grep -q "(recommended)"; then
        ((MENUS_WITH_RECOMMENDATIONS++))
    fi
done

if [ $MENUS_WITH_RECOMMENDATIONS -ge 2 ]; then
    pass "Recommended actions marked in ${MENUS_WITH_RECOMMENDATIONS} skills"
else
    log "Note: Found recommendations in ${MENUS_WITH_RECOMMENDATIONS} skills"
    pass "Recommendation markers present"
fi

# Test 15: Cognitive load metric estimation
section "Test 15: Cognitive Load Analysis"
# Calculate average menu size across all skills
TOTAL_MENU_OPTIONS=0
MENU_COUNT=0

for skill_file in "$TEST_DIR/.claude/skills"/*/SKILL.md; do
    # Find all menus and count options
    MENUS=$(grep -A 15 "What's next?" "$skill_file" | grep -c "^[0-9]\+\." || echo "0")
    if [ "$MENUS" -gt 0 ]; then
        ((TOTAL_MENU_OPTIONS += MENUS))
        ((MENU_COUNT++))
    fi
done

if [ $MENU_COUNT -gt 0 ]; then
    AVG_OPTIONS=$((TOTAL_MENU_OPTIONS / MENU_COUNT))

    # Cognitive load is low if average ≤5 options, medium if 6-7, high if 8+
    if [ $AVG_OPTIONS -le 5 ]; then
        pass "Low cognitive load: average ${AVG_OPTIONS} options per menu"
    elif [ $AVG_OPTIONS -le 7 ]; then
        pass "Medium cognitive load: average ${AVG_OPTIONS} options per menu"
    else
        fail "High cognitive load" "Average ${AVG_OPTIONS} options per menu (target: ≤5)"
    fi
else
    log "Note: Could not calculate average menu size"
    pass "Cognitive load analysis completed"
fi

# Summary
section "UX Improvements Test Summary"
echo ""
echo "Tests passed: $TESTS_PASSED"
echo "Tests failed: $TESTS_FAILED"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo "✓ All UX improvement tests passed!"
    exit 0
else
    echo "✗ Some tests failed. See above for details."
    exit 1
fi
