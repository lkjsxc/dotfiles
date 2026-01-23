#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ROOT_DIR="$(dirname "$SCRIPT_DIR")"

VERBOSE=${1:-""}
REPORT_FILE=""

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

log_verbose() {
    if [[ -n "$VERBOSE" || "$VERBOSE" == "--verbose" ]]; then
        log "$*"
    fi
}

test_result() {
    local test_name="$1"
    local result="$2"
    local message="$3"
    
    if [[ "$result" == "PASS" ]]; then
        log_verbose "✓ PASS: $test_name"
        return 0
    else
        log "✗ FAIL: $test_name - $message"
        return 1
    fi
}

check_package() {
    local package="$1"
    local command_name="${2:-$package}"
    
    log_verbose "Checking package: $package"
    
    if command -v "$command_name" >/dev/null 2>&1; then
        test_result "Package $package" "PASS" "Installed"
        return 0
    else
        test_result "Package $package" "FAIL" "Not found"
        return 1
    fi
}

check_service() {
    local service="$1"
    
    log_verbose "Checking service: $service"
    
    if systemctl is-active --quiet "$service"; then
        test_result "Service $service" "PASS" "Active"
        return 0
    else
        test_result "Service $service" "FAIL" "Not active"
        return 1
    fi
}

check_config_file() {
    local config_path="$1"
    local owner="$2"
    
    log_verbose "Checking config: $config_path"
    
    if [[ -f "$config_path" ]]; then
        local actual_owner=$(stat -c "%U" "$config_path" 2>/dev/null || echo "unknown")
        
        if [[ "$actual_owner" == "$owner" ]]; then
            test_result "Config $config_path" "PASS" "Exists with correct owner"
            return 0
        else
            test_result "Config $config_path" "FAIL" "Owner is $actual_owner (expected $owner)"
            return 1
        fi
    else
        test_result "Config $config_path" "FAIL" "File not found"
        return 1
    fi
}

test_system_packages() {
    log "Testing system packages..."
    local failures=0
    
    # Essential system packages
    check_package "pacman" || ((failures++))
    check_package "yay" || ((failures++))
    check_package "git" || ((failures++))
    check_package "curl" || ((failures++))
    check_package "wget" || ((failures++))
    
    # Development tools
    check_package "neovim" "nvim" || ((failures++))
    check_package "python" "python3" || ((failures++))
    check_package "node" "nodejs" || ((failures++))
    check_package "npm" || ((failures++))
    
    # Desktop applications
    check_package "microsoft-edge" "microsoft-edge-stable" || ((failures++))
    check_package "code" || ((failures++))
    
    return $failures
}

test_services() {
    log "Testing system services..."
    local failures=0
    
    # Check if service commands exist before testing
    if command -v systemctl >/dev/null 2>&1; then
        check_service "systemd-journald" || ((failures++))
        
        # Docker (if installed)
        if command -v docker >/dev/null 2>&1; then
            check_service "docker" || ((failures++))
        fi
        
        # NetworkManager (if installed)
        if command -v NetworkManager >/dev/null 2>&1; then
            check_service "NetworkManager" || ((failures++))
        fi
    else
        log_verbose "systemctl not available, skipping service tests"
    fi
    
    return $failures
}

test_configurations() {
    log "Testing configuration files..."
    local failures=0
    
    # User configuration files
    check_config_file "$HOME/.bashrc" "$USER" || ((failures++))
    check_config_file "$HOME/.bash_profile" "$USER" || ((failures++))
    check_config_file "$HOME/.gitconfig" "$USER" || ((failures++))
    
    # Development configurations
    check_config_file "$HOME/.config" "$USER" || ((failures++))
    
    return $failures
}

test_development_environment() {
    log "Testing development environment..."
    local failures=0
    
    # Test Git configuration
    if command -v git >/dev/null 2>&1; then
        local git_name=$(git config --global user.name || echo "")
        local git_email=$(git config --global user.email || echo "")
        
        if [[ -n "$git_name" && -n "$git_email" ]]; then
            test_result "Git configuration" "PASS" "User configured"
        else
            test_result "Git configuration" "FAIL" "Missing user config"
            ((failures++))
        fi
    fi
    
    # Test Python environment
    if command -v pip >/dev/null 2>&1; then
        if pip list >/dev/null 2>&1; then
            test_result "Python pip" "PASS" "Working"
        else
            test_result "Python pip" "FAIL" "Not working"
            ((failures++))
        fi
    fi
    
    # Test Node.js environment
    if command -v npm >/dev/null 2>&1; then
        if npm --version >/dev/null 2>&1; then
            test_result "Node.js npm" "PASS" "Working"
        else
            test_result "Node.js npm" "FAIL" "Not working"
            ((failures++))
        fi
    fi
    
    return $failures
}

test_directories() {
    log "Testing directory structure..."
    local failures=0
    
    local required_dirs=(
        "$HOME/Documents"
        "$HOME/Downloads"
        "$HOME/Pictures"
        "$HOME/Videos"
        "$HOME/Music"
        "$HOME/Projects"
    )
    
    for dir in "${required_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            test_result "Directory $dir" "PASS" "Exists"
        else
            test_result "Directory $dir" "FAIL" "Missing"
            ((failures++))
        fi
    done
    
    return $failures
}

generate_summary() {
    local total_tests="$1"
    local total_failures="$2"
    local passed=$((total_tests - total_failures))
    
    log "=== VALIDATION SUMMARY ==="
    log "Total Tests: $total_tests"
    log "Passed: $passed"
    log "Failed: $total_failures"
    
    if [[ $total_failures -eq 0 ]]; then
        log "✓ ALL TESTS PASSED"
        return 0
    else
        log "✗ SOME TESTS FAILED"
        return 1
    fi
}

main() {
    log "Starting Arch Linux system validation..."
    
    local total_failures=0
    local total_tests=0
    
    # Run test categories
    test_system_packages && ((total_tests++)) || ((total_failures++))
    test_services && ((total_tests++)) || ((total_failures++))
    test_configurations && ((total_tests++)) || ((total_failures++))
    test_development_environment && ((total_tests++)) || ((total_failures++))
    test_directories && ((total_tests++)) || ((total_failures++))
    
    # Generate summary
    generate_summary $total_tests $total_failures
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi