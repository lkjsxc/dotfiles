#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

setup_gaming() {
    log "Setting up gaming environment..."
    
    # Install gaming packages
    yay -S --noconfirm lutris steam wine-staging
    
    # Setup gaming directories
    mkdir -p ~/Games ~/Wine-prefixes
    
    log "Gaming setup completed"
}

setup_language() {
    log "Setting up Japanese language support..."
    
    # Install language packages
    sudo pacman -S --noconfirm fcitx5-im fcitx5-mozc
    
    # Configure environment (add to shell profile)
    if ! grep -q "GTK_IM_MODULE" ~/.bash_profile; then
        echo "export GTK_IM_MODULE=fcitx" >> ~/.bash_profile
        echo "export QT_IM_MODULE=fcitx" >> ~/.bash_profile
        echo "export XMODIFIERS=@im=fcitx" >> ~/.bash_profile
    fi
    
    log "Language support setup completed"
}

setup_network() {
    log "Setting up network storage..."
    
    # Install Samba client
    yay -S --noconfirm cifs-utils
    
    # Create mount point
    sudo mkdir -p /mnt/lkjsxc-server
    
    log "Network storage setup completed"
}

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

main() {
    local component="${1:-all}"
    
    case "$component" in
        "gaming")
            setup_gaming
            ;;
        "language")
            setup_language
            ;;
        "network")
            setup_network
            ;;
        "all")
            setup_gaming
            setup_language
            setup_network
            ;;
        *)
            echo "Usage: $0 [gaming|language|network|all]"
            exit 1
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi