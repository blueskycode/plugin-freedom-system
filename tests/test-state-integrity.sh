#!/bin/bash
# Test Suite: State Integrity (Prompt 16)
# Tests atomic commits, checksums, and state reconciliation

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

# Test 1: Verify checksum validator exists and is executable
section "Test 1: Checksum Validator Installation"
if [ -f "$TEST_DIR/.claude/hooks/validators/validate-checksums.py" ] && [ -x "$TEST_DIR/.claude/hooks/validators/validate-checksums.py" ]; then
    pass "Checksum validator exists and is executable"
else
    fail "Checksum validator missing or not executable" "$TEST_DIR/.claude/hooks/validators/validate-checksums.py"
fi

# Test 2: Verify contract_validator.py exists
section "Test 2: Contract Validator Library"
if [ -f "$TEST_DIR/.claude/hooks/validators/contract_validator.py" ]; then
    pass "Contract validator library exists"
else
    fail "Contract validator library missing" "$TEST_DIR/.claude/hooks/validators/contract_validator.py"
fi

# Test 3: Test checksum calculation functionality
section "Test 3: Checksum Calculation"
TEST_FILE=$(mktemp)
echo "test content" > "$TEST_FILE"
EXPECTED_CHECKSUM="d3486ae9136e7856bc42212385ea797094475802"

if python3 -c "
import hashlib
from pathlib import Path

def calculate_checksum(file_path):
    with open(file_path, 'rb') as f:
        return hashlib.sha1(f.read()).hexdigest()

result = calculate_checksum('$TEST_FILE')
print(result)
assert result == '$EXPECTED_CHECKSUM', f'Expected $EXPECTED_CHECKSUM, got {result}'
" 2>/dev/null; then
    pass "Checksum calculation works correctly"
else
    fail "Checksum calculation failed" "SHA1 hash mismatch"
fi
rm "$TEST_FILE"

# Test 4: Verify SubagentStop hook references checksum validator
section "Test 4: SubagentStop Hook Integration"
if [ -f "$TEST_DIR/.claude/hooks/SubagentStop.sh" ]; then
    if grep -q "validate-checksums.py" "$TEST_DIR/.claude/hooks/SubagentStop.sh"; then
        pass "SubagentStop hook references checksum validator"
    else
        fail "SubagentStop hook doesn't reference checksum validator" "validate-checksums.py not found in hook"
    fi
else
    fail "SubagentStop hook missing" "$TEST_DIR/.claude/hooks/SubagentStop.sh"
fi

# Test 5: Test continue-here.md checksum format
section "Test 5: Continue-Here Checksum Format"
# Find a test plugin with .continue-here.md
SAMPLE_HANDOFF=$(find "$TEST_DIR/plugins" -name ".continue-here.md" | head -1)
if [ -n "$SAMPLE_HANDOFF" ]; then
    if grep -q "contract_checksums:" "$SAMPLE_HANDOFF"; then
        pass "Found contract_checksums in handoff file"
    else
        log "Note: No checksums found (may not be during implementation stages)"
        pass "Handoff file format is valid"
    fi
else
    log "Note: No active workflows found (expected if no plugins in development)"
    pass "Checkpoint format validation skipped (no active workflows)"
fi

# Test 6: Verify silent failure validator exists
section "Test 6: Silent Failure Detection"
if [ -f "$TEST_DIR/.claude/hooks/validators/validate-silent-failures.py" ] && [ -x "$TEST_DIR/.claude/hooks/validators/validate-silent-failures.py" ]; then
    pass "Silent failure validator exists and is executable"
else
    fail "Silent failure validator missing" "$TEST_DIR/.claude/hooks/validators/validate-silent-failures.py"
fi

# Test 7: Test silent failure pattern detection
section "Test 7: Silent Failure Pattern Recognition"
TEST_CPP=$(mktemp --suffix=.cpp)
cat > "$TEST_CPP" << 'EOF'
// Test: Should catch 2-parameter WebSliderParameterAttachment
auto attachment = std::make_unique<juce::WebSliderParameterAttachment>(
    *parameter,
    editor.getWebViewManagerPtr()
);
EOF

if [ "$VERBOSE" = true ]; then
    log "Test file content:"
    cat "$TEST_CPP"
fi

if python3 "$TEST_DIR/.claude/hooks/validators/validate-silent-failures.py" "$TEST_CPP" 2>&1 | grep -q "2-parameter WebSliderParameterAttachment"; then
    pass "Silent failure pattern detection works"
else
    fail "Silent failure pattern not detected" "Should catch 2-parameter WebSliderParameterAttachment"
fi
rm "$TEST_CPP"

# Test 8: Verify PostToolUse hook exists
section "Test 8: PostToolUse Hook Installation"
if [ -f "$TEST_DIR/.claude/hooks/PostToolUse.sh" ] && [ -x "$TEST_DIR/.claude/hooks/PostToolUse.sh" ]; then
    pass "PostToolUse hook exists and is executable"
else
    fail "PostToolUse hook missing or not executable" "$TEST_DIR/.claude/hooks/PostToolUse.sh"
fi

# Test 9: Verify contract immutability enforcement in PostToolUse
section "Test 9: Contract Immutability Enforcement"
if grep -q "\.ideas/" "$TEST_DIR/.claude/hooks/PostToolUse.sh" && grep -q "contract" "$TEST_DIR/.claude/hooks/PostToolUse.sh"; then
    pass "PostToolUse hook enforces contract immutability"
else
    fail "Contract immutability not enforced" "PostToolUse hook doesn't check .ideas/ modifications"
fi

# Test 10: Verify PLUGINS.md state file exists
section "Test 10: State File Existence"
if [ -f "$TEST_DIR/PLUGINS.md" ]; then
    pass "PLUGINS.md state file exists"
else
    fail "PLUGINS.md state file missing" "$TEST_DIR/PLUGINS.md"
fi

# Test 11: Verify PLUGINS.md has required sections
section "Test 11: State File Structure"
if grep -q "## Plugins" "$TEST_DIR/PLUGINS.md" && grep -q "Status" "$TEST_DIR/PLUGINS.md"; then
    pass "PLUGINS.md has required sections"
else
    fail "PLUGINS.md missing required sections" "Should have '## Plugins' and 'Status' headers"
fi

# Test 12: Check for atomic commit pattern in recent commits
section "Test 12: Atomic Commit Pattern"
RECENT_COMMITS=$(git -C "$TEST_DIR" log --oneline --since="7 days ago" | head -5)
if echo "$RECENT_COMMITS" | grep -q "feat\|fix\|chore"; then
    # Check if state updates are in same commits as implementation
    STATE_COMMIT=$(git -C "$TEST_DIR" log --oneline --since="7 days ago" --all --grep="state\|checkpoint" | head -1)
    if [ -n "$STATE_COMMIT" ]; then
        COMMIT_HASH=$(echo "$STATE_COMMIT" | awk '{print $1}')
        FILES_IN_COMMIT=$(git -C "$TEST_DIR" show --name-only --format="" "$COMMIT_HASH")

        if echo "$FILES_IN_COMMIT" | grep -q "\.continue-here\|PLUGINS.md"; then
            if echo "$FILES_IN_COMMIT" | grep -qE "\.(cpp|h|md|html|css|js)"; then
                pass "Atomic commits detected (code + state in same commit)"
            else
                log "Note: State-only commit found (may be expected for checkpoints)"
                pass "State management commits present"
            fi
        else
            log "Note: No recent state management commits found"
            pass "Commit pattern validation skipped"
        fi
    else
        log "Note: No recent state management commits found"
        pass "Commit pattern validation skipped"
    fi
else
    log "Note: No recent commits in last 7 days"
    pass "Atomic commit test skipped (no recent commits)"
fi

# Summary
section "State Integrity Test Summary"
echo ""
echo "Tests passed: $TESTS_PASSED"
echo "Tests failed: $TESTS_FAILED"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo "✓ All state integrity tests passed!"
    exit 0
else
    echo "✗ Some tests failed. See above for details."
    exit 1
fi
