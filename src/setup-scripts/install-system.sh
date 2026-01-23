#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ROOT_DIR="$(dirname "$SCRIPT_DIR")"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

error_exit() {
    echo "Error: $1" >&2
    exit 1
}

check_root() {
    [[ $EUID -eq 0 ]] || error_exit "This script must be run as root"
}

update_system() {
    log "Updating system packages..."
    pacman -Syu --noconfirm
}

install_build_tools() {
    log "Installing build tools..."
    pacman -S --needed --noconfirm git base-devel
}

install_aur_helper() {
    log "Installing yay AUR helper..."
    if ! command -v yay >/dev/null 2>&1; then
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd /
        rm -rf /tmp/yay
    fi
}

install_base_packages() {
    log "Installing base packages..."
    pacman -S --noconfirm \
        neovim \
        git \
        curl \
        wget \
        htop \
        tree \
        rsync \
        unzip \
        zip \
        sshfs
}

install_aur_packages() {
    log "Installing AUR packages..."
    yay -S --noconfirm \
        microsoft-edge-stable-bin \
        visual-studio-code-bin \
        opencode
}

setup_git() {
    log "Configuring git..."
    git config --global user.email "lkjsxc@gmail.com"
    git config --global user.name "lkjsxc"
}

main() {
    log "Starting Arch Linux system setup..."
    
    check_root
    update_system
    install_build_tools
    install_aur_helper
    install_base_packages
    install_aur_packages
    setup_git
    
    log "System setup completed successfully!"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi