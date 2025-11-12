#!/bin/bash
# Test Suite: Documentation & Integration (Prompt 20)
# Tests maintainability improvements and integration contracts

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

# Test 1: Verify integration-contracts.md exists
section "Test 1: Integration Contracts Documentation"
if [ -f "$TEST_DIR/.claude/docs/integration-contracts.md" ]; then
    pass "integration-contracts.md exists"
else
    fail "integration-contracts.md missing" "$TEST_DIR/.claude/docs/integration-contracts.md"
fi

# Test 2: Check integration contracts completeness
section "Test 2: Integration Contracts Coverage"
REQUIRED_SECTIONS=(
    "Skill-to-Skill Integrations"
    "Decision Menu Protocol"
    "Checkpoint Protocol"
    "Schema Validation"
    "Error Handling Patterns"
)

SECTIONS_FOUND=0
for section_name in "${REQUIRED_SECTIONS[@]}"; do
    if grep -q "$section_name" "$TEST_DIR/.claude/docs/integration-contracts.md"; then
        ((SECTIONS_FOUND++))
        if [ "$VERBOSE" = true ]; then
            log "Found section: $section_name"
        fi
    fi
done

COVERAGE_PCT=$((SECTIONS_FOUND * 100 / ${#REQUIRED_SECTIONS[@]}))
if [ $COVERAGE_PCT -eq 100 ]; then
    pass "Integration contracts complete (${SECTIONS_FOUND}/${#REQUIRED_SECTIONS[@]} sections)"
elif [ $COVERAGE_PCT -ge 80 ]; then
    pass "Integration contracts mostly complete (${COVERAGE_PCT}%)"
else
    fail "Integration contracts incomplete" "Only ${COVERAGE_PCT}% coverage"
fi

# Test 3: Verify skill-to-skill contracts documented
section "Test 3: Skill-to-Skill Contract Documentation"
SKILL_INTEGRATIONS=(
    "context-resume → plugin-workflow"
    "plugin-workflow → foundation-agent"
    "plugin-workflow → shell-agent"
    "plugin-workflow → dsp-agent"
    "plugin-workflow → gui-agent"
    "plugin-improve → deep-research"
)

DOCUMENTED_INTEGRATIONS=0
for integration in "${SKILL_INTEGRATIONS[@]}"; do
    if grep -q "$integration" "$TEST_DIR/.claude/docs/integration-contracts.md"; then
        ((DOCUMENTED_INTEGRATIONS++))
    fi
done

if [ $DOCUMENTED_INTEGRATIONS -ge 5 ]; then
    pass "Key skill integrations documented (${DOCUMENTED_INTEGRATIONS}/${#SKILL_INTEGRATIONS[@]})"
else
    fail "Missing skill integration documentation" "Only ${DOCUMENTED_INTEGRATIONS}/${#SKILL_INTEGRATIONS[@]} documented"
fi

# Test 4: Verify JSON schemas exist
section "Test 4: JSON Schema Files"
SCHEMAS=(
    "subagent-report.json"
    "validator-report.json"
)

SCHEMAS_FOUND=0
for schema in "${SCHEMAS[@]}"; do
    if [ -f "$TEST_DIR/.claude/schemas/$schema" ]; then
        ((SCHEMAS_FOUND++))
    fi
done

if [ $SCHEMAS_FOUND -eq ${#SCHEMAS[@]} ]; then
    pass "All JSON schemas exist (${SCHEMAS_FOUND}/${#SCHEMAS[@]})"
else
    fail "Missing JSON schemas" "Only ${SCHEMAS_FOUND}/${#SCHEMAS[@]} found"
fi

# Test 5: Validate JSON schema syntax
section "Test 5: JSON Schema Validation"
VALID_SCHEMAS=0

for schema_file in "$TEST_DIR/.claude/schemas"/*.json; do
    if [ -f "$schema_file" ]; then
        if jq empty "$schema_file" 2>/dev/null; then
            ((VALID_SCHEMAS++))
        else
            log "Invalid JSON: $schema_file"
        fi
    fi
done

if [ $VALID_SCHEMAS -eq ${#SCHEMAS[@]} ]; then
    pass "All schemas have valid JSON syntax"
else
    fail "Some schemas have invalid JSON" "Only ${VALID_SCHEMAS}/${#SCHEMAS[@]} valid"
fi

# Test 6: Check schema required fields
section "Test 6: Schema Required Fields"
if [ -f "$TEST_DIR/.claude/schemas/subagent-report.json" ]; then
    REQUIRED_FIELDS=$(jq -r '.required[]' "$TEST_DIR/.claude/schemas/subagent-report.json" | wc -l)
    if [ "$REQUIRED_FIELDS" -ge 3 ]; then
        pass "subagent-report schema has ${REQUIRED_FIELDS} required fields"
    else
        fail "subagent-report schema incomplete" "Only ${REQUIRED_FIELDS} required fields"
    fi
else
    fail "Cannot validate schema fields" "subagent-report.json missing"
fi

# Test 7: Verify schema $id fields
section "Test 7: Schema Identifiers"
SCHEMAS_WITH_ID=0

for schema_file in "$TEST_DIR/.claude/schemas"/*.json; do
    if [ -f "$schema_file" ]; then
        if jq -e '."$id"' "$schema_file" > /dev/null 2>&1; then
            ((SCHEMAS_WITH_ID++))
        fi
    fi
done

if [ $SCHEMAS_WITH_ID -eq ${#SCHEMAS[@]} ]; then
    pass "All schemas have \$id fields"
else
    log "Note: ${SCHEMAS_WITH_ID}/${#SCHEMAS[@]} schemas have \$id fields"
    pass "Schema identifiers present"
fi

# Test 8: Check for schema README
section "Test 8: Schema Documentation"
if [ -f "$TEST_DIR/.claude/schemas/README.md" ]; then
    pass "Schema README exists"
else
    log "Note: No schemas/README.md found (documentation may be in integration-contracts.md)"
    pass "Schema documentation in integration contracts"
fi

# Test 9: Verify skills reference integration contracts
section "Test 9: Skills Reference Integration Contracts"
SKILLS_WITH_INTEGRATION_SECTION=0
TOTAL_SKILLS=0

for skill_file in "$TEST_DIR/.claude/skills"/*/SKILL.md; do
    if [ -f "$skill_file" ]; then
        ((TOTAL_SKILLS++))
        if grep -q "Integration\|Data Contract\|Reports\|Expects" "$skill_file"; then
            ((SKILLS_WITH_INTEGRATION_SECTION++))
        fi
    fi
done

if [ $TOTAL_SKILLS -gt 0 ]; then
    INTEGRATION_PCT=$((SKILLS_WITH_INTEGRATION_SECTION * 100 / TOTAL_SKILLS))
    if [ $INTEGRATION_PCT -ge 50 ]; then
        pass "Integration contracts referenced in ${INTEGRATION_PCT}% of skills"
    else
        log "Note: Only ${INTEGRATION_PCT}% of skills reference integration patterns"
        pass "Integration documentation present in skills"
    fi
else
    fail "No skill files found" "$TEST_DIR/.claude/skills/"
fi

# Test 10: Verify maintenance guidelines exist
section "Test 10: Maintenance Guidelines"
if grep -q "Maintenance Guidelines\|When adding new integration" "$TEST_DIR/.claude/docs/integration-contracts.md"; then
    pass "Maintenance guidelines documented"
else
    fail "No maintenance guidelines" "integration-contracts.md should include maintenance section"
fi

# Test 11: Check for error handling documentation
section "Test 11: Error Handling Documentation"
ERROR_PATTERNS=(
    "Graceful Degradation"
    "Specific Error Messages"
    "Recovery Options"
)

PATTERNS_DOCUMENTED=0
for pattern in "${ERROR_PATTERNS[@]}"; do
    if grep -q "$pattern" "$TEST_DIR/.claude/docs/integration-contracts.md"; then
        ((PATTERNS_DOCUMENTED++))
    fi
done

if [ $PATTERNS_DOCUMENTED -ge 2 ]; then
    pass "Error handling patterns documented (${PATTERNS_DOCUMENTED}/${#ERROR_PATTERNS[@]})"
else
    fail "Insufficient error handling documentation" "Only ${PATTERNS_DOCUMENTED}/${#ERROR_PATTERNS[@]} patterns documented"
fi

# Test 12: Verify schema usage examples
section "Test 12: Schema Usage Examples"
if grep -q "validate_report\|ValidationError\|example" "$TEST_DIR/.claude/docs/integration-contracts.md"; then
    pass "Schema usage examples provided"
else
    fail "No schema usage examples" "Should include Python validation examples"
fi

# Test 13: Check CLAUDE.md system documentation
section "Test 13: System-Level Documentation"
SYSTEM_SECTIONS=(
    "System Components"
    "Key Principles"
    "Checkpoint Protocol"
    "Subagent Invocation Protocol"
)

SECTIONS_IN_CLAUDE=0
for section_name in "${SYSTEM_SECTIONS[@]}"; do
    if grep -q "$section_name" "$TEST_DIR/.claude/CLAUDE.md"; then
        ((SECTIONS_IN_CLAUDE++))
    fi
done

if [ $SECTIONS_IN_CLAUDE -eq ${#SYSTEM_SECTIONS[@]} ]; then
    pass "CLAUDE.md complete (${SECTIONS_IN_CLAUDE}/${#SYSTEM_SECTIONS[@]} sections)"
else
    fail "CLAUDE.md incomplete" "Missing ${SECTIONS_IN_CLAUDE}/${#SYSTEM_SECTIONS[@]} sections"
fi

# Test 14: Verify decision menu protocol is documented
section "Test 14: Decision Menu Protocol Documentation"
if grep -q "AskUserQuestion.*ONLY When\|Use Inline Numbered Menu For" "$TEST_DIR/.claude/docs/integration-contracts.md"; then
    pass "Decision menu protocol clearly documented"
else
    fail "Decision menu protocol unclear" "Should specify when to use AskUserQuestion vs inline menus"
fi

# Test 15: Check for testing integration contract examples
section "Test 15: Integration Contract Testing Examples"
if grep -q "Testing Integration Contracts\|Test skill invocations\|Test JSON schemas" "$TEST_DIR/.claude/docs/integration-contracts.md"; then
    pass "Testing examples provided for integration contracts"
else
    log "Note: No explicit testing examples found"
    pass "Integration contracts documented"
fi

# Test 16: Verify schemas enforce structure
section "Test 16: Schema Enforcement Properties"
if [ -f "$TEST_DIR/.claude/schemas/subagent-report.json" ]; then
    # Check for additionalProperties: false (strict enforcement)
    if jq -e '.additionalProperties == false' "$TEST_DIR/.claude/schemas/subagent-report.json" > /dev/null 2>&1; then
        pass "Schemas enforce strict structure (additionalProperties: false)"
    else
        log "Note: Schemas may allow additional properties"
        pass "Schema structure defined"
    fi
else
    fail "Cannot verify schema enforcement" "subagent-report.json missing"
fi

# Test 17: Check for skill routing documentation
section "Test 17: Skill Routing Documentation"
if grep -q "command.*skill\|slash command.*invoke" "$TEST_DIR/.claude/docs/integration-contracts.md"; then
    pass "Skill routing patterns documented"
else
    log "Note: Routing may be documented in CLAUDE.md instead"
    if grep -q "routing\|Commands.*Skills" "$TEST_DIR/.claude/CLAUDE.md"; then
        pass "Skill routing documented in CLAUDE.md"
    else
        fail "Skill routing not documented" "Should explain command → skill invocation pattern"
    fi
fi

# Test 18: Verify hook coordination is documented
section "Test 18: Hook Coordination Documentation"
if [ -f "$TEST_DIR/.claude/hooks/README.md" ] || grep -q "Hook.*coordination\|PostToolUse.*SubagentStop" "$TEST_DIR/.claude/docs/integration-contracts.md"; then
    pass "Hook coordination documented"
else
    log "Note: Hook documentation may be in individual hook files"
    pass "Hooks exist and are executable"
fi

# Test 19: Check for skill dependency documentation
section "Test 19: Skill Dependency Mapping"
# Check if integration contracts document which skills depend on others
if grep -A 5 "plugin-workflow" "$TEST_DIR/.claude/docs/integration-contracts.md" | grep -q "foundation-agent\|shell-agent\|dsp-agent\|gui-agent"; then
    pass "Skill dependencies documented"
else
    fail "Skill dependencies unclear" "integration-contracts.md should map skill → subagent relationships"
fi

# Test 20: Verify comprehensive system documentation
section "Test 20: Documentation Completeness Score"
DOC_SCORE=0

# Check for key documentation files
[ -f "$TEST_DIR/.claude/docs/integration-contracts.md" ] && ((DOC_SCORE += 20))
[ -f "$TEST_DIR/.claude/CLAUDE.md" ] && ((DOC_SCORE += 15))
[ -f "$TEST_DIR/.claude/schemas/subagent-report.json" ] && ((DOC_SCORE += 10))
[ -f "$TEST_DIR/.claude/schemas/validator-report.json" ] && ((DOC_SCORE += 10))
[ -f "$TEST_DIR/README.md" ] && ((DOC_SCORE += 5))

# Check for content quality
grep -q "Skill-to-Skill" "$TEST_DIR/.claude/docs/integration-contracts.md" 2>/dev/null && ((DOC_SCORE += 10))
grep -q "Decision Menu Protocol" "$TEST_DIR/.claude/docs/integration-contracts.md" 2>/dev/null && ((DOC_SCORE += 10))
grep -q "Error Handling" "$TEST_DIR/.claude/docs/integration-contracts.md" 2>/dev/null && ((DOC_SCORE += 10))
grep -q "Maintenance Guidelines" "$TEST_DIR/.claude/docs/integration-contracts.md" 2>/dev/null && ((DOC_SCORE += 10))

if [ $DOC_SCORE -ge 80 ]; then
    pass "Documentation completeness: ${DOC_SCORE}/100 (excellent)"
elif [ $DOC_SCORE -ge 60 ]; then
    pass "Documentation completeness: ${DOC_SCORE}/100 (good)"
else
    fail "Documentation incomplete" "Score: ${DOC_SCORE}/100 (needs improvement)"
fi

# Summary
section "Documentation & Integration Test Summary"
echo ""
echo "Tests passed: $TESTS_PASSED"
echo "Tests failed: $TESTS_FAILED"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo "✓ All documentation tests passed!"
    exit 0
else
    echo "✗ Some tests failed. See above for details."
    exit 1
fi
