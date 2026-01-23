#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

error_exit() {
    echo "Error: $1" >&2
    exit 1
}

install_essential_packages() {
    log "Installing essential development packages..."
    sudo pacman -S --noconfirm \
        gcc \
        make \
        cmake \
        python \
        python-pip \
        nodejs \
        npm \
        docker \
        docker-compose \
        postgresql \
        redis
}

setup_vscode() {
    log "Setting up VSCode..."
    if command -v code >/dev/null 2>&1; then
        log "Installing VSCode extensions..."
        code --install-extension ms-python.python
        code --install-extension ms-vscode.cpptools
        code --install-extension bradlc.vscode-tailwindcss
        code --install-extension esbenp.prettier-vscode
    fi
}

setup_neovim() {
    log "Setting up Neovim..."
    if command -v nvim >/dev/null 2>&1; then
        mkdir -p ~/.config/nvim
        git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 || true
        nvim +PackerSync +qa
    fi
}

setup_docker() {
    log "Setting up Docker..."
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo usermod -aG docker "$USER"
}

setup_python_environment() {
    log "Setting up Python development environment..."
    python -m pip install --upgrade pip
    pip install virtualenv black flake8 pytest
}

setup_node_environment() {
    log "Setting up Node.js development environment..."
    npm install -g typescript ts-node yarn
}

main() {
    log "Setting up development environment..."
    
    install_essential_packages
    setup_vscode
    setup_neovim
    setup_docker
    setup_python_environment
    setup_node_environment
    
    log "Development setup completed successfully!"
    log "You may need to re-login for Docker group changes to take effect."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi