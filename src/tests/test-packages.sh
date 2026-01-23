#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

test_package_installation() {
    log "Testing package installation..."
    
    local packages=(
        # System packages
        "git"
        "curl"
        "wget"
        "htop"
        "tree"
        
        # Development tools
        "neovim"
        "python"
        "node"
        "npm"
        
        # Check for AUR packages
        "yay"
    )
    
    local missing_packages=()
    local found_packages=()
    
    for package in "${packages[@]}"; do
        if command -v "$package" >/dev/null 2>&1; then
            found_packages+=("$package")
        else
            missing_packages+=("$package")
        fi
    done
    
    # Report results
    log "Package Installation Test Results:"
    log "  Found packages: ${#found_packages[@]}"
    log "  Missing packages: ${#missing_packages[@]}"
    
    if [[ ${#missing_packages[@]} -gt 0 ]]; then
        log "Missing packages: ${missing_packages[*]}"
        return 1
    fi
    
    log "✓ All required packages are installed"
    return 0
}

test_package_updates() {
    log "Testing package update capability..."
    
    # Check if pacman can check for updates
    if pacman -Sy >/dev/null 2>&1; then
        log "✓ Package database update successful"
        
        # Check for available updates (don't actually update)
        local updates=$(pacman -Qu | wc -l)
        log "  Available updates: $updates packages"
        
        return 0
    else
        log "✗ Failed to update package database"
        return 1
    fi
}

test_aur_functionality() {
    log "Testing AUR functionality..."
    
    if command -v yay >/dev/null 2>&1; then
        # Test yay basic functionality
        if yay -Qi yay >/dev/null 2>&1; then
            log "✓ AUR helper (yay) is functional"
            return 0
        else
            log "✗ AUR helper (yay) is not working properly"
            return 1
        fi
    else
        log "✗ AUR helper (yay) not installed"
        return 1
    fi
}

test_package_integrity() {
    log "Testing package integrity..."
    
    # Check for broken packages
    if pacman -Qk >/dev/null 2>&1; then
        log "✓ Package integrity check passed"
        return 0
    else
        log "✗ Package integrity check failed"
        return 1
    fi
}

test_cache_cleanup() {
    log "Testing package cache..."
    
    # Check cache size
    local cache_size=$(du -sh /var/cache/pacman/pkg 2>/dev/null | cut -f1 || echo "unknown")
    log "Package cache size: $cache_size"
    
    # Note: Don't actually clean, just report
    log "✓ Package cache accessible"
    return 0
}

main() {
    log "Starting package installation tests..."
    
    local failures=0
    
    test_package_installation || ((failures++))
    test_package_updates || ((failures++))
    test_aur_functionality || ((failures++))
    test_package_integrity || ((failures++))
    test_cache_cleanup || ((failures++))
    
    if [[ $failures -eq 0 ]]; then
        log "✓ All package tests passed"
        return 0
    else
        log "✗ $failures package tests failed"
        return 1
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi