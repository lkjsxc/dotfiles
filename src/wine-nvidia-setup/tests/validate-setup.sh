#!/usr/bin/env bash
# Validation script for Wine and NVIDIA 32-bit setup
set -euo pipefail

readonly EXIT_SUCCESS=0
readonly EXIT_FAILURE=1

check_package() {
    local package="$1"
    if pacman -Q "$package" >/dev/null 2>&1; then
        echo "✓ $package installed"
        return 0
    else
        echo "✗ $package NOT installed"
        return 1
    fi
}

check_library() {
    local library="$1"
    local arch="${2:-64}"
    
    if ldconfig -p | grep -q "$library.*$arch"; then
        echo "✓ $library ($arch-bit) available"
        return 0
    else
        echo "✗ $library ($arch-bit) NOT available"
        return 1
    fi
}

check_multilib() {
    echo "Checking multilib repository..."
    
    if pacman -Sl multilib >/dev/null 2>&1; then
        echo "✓ Multilib repository enabled"
        return 0
    else
        echo "✗ Multilib repository NOT enabled"
        return 1
    fi
}

check_nvidia_drivers() {
    echo "Checking NVIDIA drivers..."
    
    local failed=0
    
    check_package "nvidia-utils" || failed=1
    check_package "lib32-nvidia-utils" || failed=1
    
    check_library "libGL.so.1" "64" || failed=1
    check_library "libGL.so.1" "i386" || failed=1
    
    return $failed
}

check_wine() {
    echo "Checking Wine installation..."
    
    local failed=0
    
    check_package "wine" || failed=1
    check_package "wine-mono" || failed=1
    check_package "winetricks" || failed=1
    check_package "dxvk" || failed=1
    
    if command -v wine >/dev/null 2>&1; then
        echo "✓ Wine executable available"
        local wine_version=$(wine --version)
        echo "  Version: $wine_version"
    else
        echo "✗ Wine executable NOT found"
        failed=1
    fi
    
    return $failed
}

check_opengl() {
    echo "Checking OpenGL support..."
    
    if command -v glxinfo >/dev/null 2>&1; then
        local renderer=$(glxinfo | grep "OpenGL renderer" | cut -d: -f2 | xargs)
        if [[ -n "$renderer" ]]; then
            echo "✓ OpenGL renderer: $renderer"
            return 0
        fi
    fi
    
    echo "✗ OpenGL information unavailable"
    return 1
}

run_wine_test() {
    echo "Testing Wine functionality..."
    
    if command -v wine >/dev/null 2>&1; then
        timeout 5 wine cmd /c exit 0 >/dev/null 2>&1 && echo "✓ Wine basic functionality OK" || echo "✗ Wine basic test FAILED"
    fi
}

main() {
    echo "=== Wine and NVIDIA 32-bit Setup Validation ==="
    echo
    
    local failed=0
    
    check_multilib || failed=1
    echo
    
    check_nvidia_drivers || failed=1
    echo
    
    check_wine || failed=1
    echo
    
    check_opengl || failed=1
    echo
    
    run_wine_test
    echo
    
    if [[ $failed -eq 0 ]]; then
        echo "🎉 All checks passed! Setup is complete."
        exit $EXIT_SUCCESS
    else
        echo "❌ Some checks failed. Please review the output above."
        exit $EXIT_FAILURE
    fi
}

main "$@"