#!/usr/bin/env bash
# NVIDIA 32-bit drivers and Wine setup for RTX 3070
set -euo pipefail

readonly PACMAN_CONF="/etc/pacman.conf"
readonly LOG_FILE="/tmp/wine-nvidia-setup.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

error_exit() {
    log "ERROR: $1" >&2
    exit 1
}

backup_config() {
    local backup_file="${PACMAN_CONF}.backup.$(date +%Y%m%d_%H%M%S)"
    sudo cp "$PACMAN_CONF" "$backup_file"
    log "Configuration backed up to $backup_file"
}

enable_multilib() {
    log "Enabling multilib repository..."
    
    if ! grep -q "#\[multilib\]" "$PACMAN_CONF" && ! grep -q "^\[multilib\]" "$PACMAN_CONF"; then
        error_exit "Multilib section not found in $PACMAN_CONF"
    fi
    
    if grep -q "^\[multilib\]" "$PACMAN_CONF"; then
        log "Multilib repository already enabled"
        return 0
    fi
    
    sudo sed -i '/\[multilib\]/,+1 s/^#//' "$PACMAN_CONF"
    log "Multilib repository enabled"
}

install_nvidia_32bit() {
    log "Installing 32-bit NVIDIA drivers..."
    
    local packages=(
        "lib32-nvidia-utils"
        "lib32-mesa"
        "lib32-libgl"
        "lib32-gcc-libs"
        "lib32-libx11"
        "lib32-libxcursor"
        "lib32-libxi"
        "lib32-libxrandr"
        "lib32-libxss"
        "lib32-libxtst"
    )
    
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm "${packages[@]}"
    log "32-bit NVIDIA drivers installed"
}

install_wine() {
    log "Installing Wine and dependencies..."
    
    local wine_packages=(
        "wine"
        "wine-mono"
        "wine-gecko"
        "winetricks"
    )
    
    sudo pacman -S --noconfirm "${wine_packages[@]}"
    log "Wine installed"
}

verify_installation() {
    log "Verifying installation..."
    
    if ! pacman -Q lib32-nvidia-utils >/dev/null 2>&1; then
        error_exit "lib32-nvidia-utils not installed"
    fi
    
    if ! ldconfig -p | grep -q "libGL.so.1.*i386"; then
        error_exit "32-bit OpenGL libraries not found"
    fi
    
    log "Installation verified successfully"
}

main() {
    log "Starting Wine and NVIDIA 32-bit setup for RTX 3070..."
    
    backup_config
    enable_multilib
    install_nvidia_32bit
    install_wine
    verify_installation
    
    log "Setup completed successfully"
    log "Run 'winecfg' to configure Wine settings"
}

main "$@"