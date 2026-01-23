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

setup_shell() {
    log "Setting up user shell..."
    [[ -f "$ROOT_DIR/config-files/.bashrc" ]] && cp "$ROOT_DIR/config-files/.bashrc" "$HOME/"
    [[ -f "$ROOT_DIR/config-files/.bash_profile" ]] && cp "$ROOT_DIR/config-files/.bash_profile" "$HOME/"
}

setup_fonts() {
    log "Installing fonts..."
    sudo pacman -S --noconfirm \
        noto-fonts-cjk \
        noto-fonts-emoji \
        noto-fonts
}

setup_directories() {
    log "Creating user directories..."
    mkdir -p ~/Documents ~/Downloads ~/Pictures ~/Videos ~/Music ~/Projects
}

setup_git_ssh() {
    log "Setting up SSH for Git..."
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    
    if [[ ! -f ~/.ssh/id_ed25519 ]]; then
        ssh-keygen -t ed25519 -C "lkjsxc@gmail.com" -f ~/.ssh/id_ed25519 -N ""
        log "SSH key generated. Add to GitHub:"
        cat ~/.ssh/id_ed25519.pub
    fi
}

install_user_aur_packages() {
    log "Installing user AUR packages..."
    yay -S --noconfirm \
        lutris \
        cifs-utils
}

main() {
    log "Setting up user environment..."
    
    setup_shell
    setup_fonts
    setup_directories
    setup_git_ssh
    install_user_aur_packages
    
    log "User setup completed successfully!"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi