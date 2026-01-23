#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly DOCKER_GROUP="docker"

log_info() {
    echo "[INFO] $1"
}

log_error() {
    echo "[ERROR] $1" >&2
}

check_docker_installed() {
    if command -v docker >/dev/null 2>&1; then
        log_info "Docker is already installed"
        docker --version
        return 0
    fi
    return 1
}

install_docker() {
    log_info "Installing Docker..."
    
    sudo pacman -Syu
    sudo pacman -S docker
    
    log_info "Enabling and starting Docker service..."
    sudo systemctl enable docker
    sudo systemctl start docker
    
    log_info "Adding user to docker group..."
    if ! groups "$USER" | grep -q "$DOCKER_GROUP"; then
        sudo usermod -aG "$DOCKER_GROUP" "$USER"
        log_info "User added to docker group. Please log out and log back in to apply changes."
    fi
}

install_docker_compose() {
    log_info "Installing Docker Compose..."
    sudo pacman -S docker-compose
}

verify_installation() {
    log_info "Verifying Docker installation..."
    
    if sudo docker run hello-world >/dev/null 2>&1; then
        log_info "Docker installation verified successfully"
    else
        log_error "Docker installation verification failed"
        exit 1
    fi
    
    if command -v docker-compose >/dev/null 2>&1; then
        log_info "Docker Compose is available: $(docker-compose --version)"
    fi
}

main() {
    log_info "Starting Docker installation..."
    
    if ! check_docker_installed; then
        install_docker
        install_docker_compose
        verify_installation
    fi
    
    log_info "Docker installation completed successfully"
    log_info "Run 'newgrp docker' or relogin to use Docker without sudo"
}

main "$@"