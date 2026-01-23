#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly COMPOSE_FILE="$SCRIPT_DIR/../config-files/docker-compose.yml"

log_info() {
    echo "[INFO] $1"
}

log_error() {
    echo "[ERROR] $1" >&2
}

check_docker_daemon() {
    log_info "Checking Docker daemon status..."
    if ! sudo systemctl is-active --quiet docker; then
        log_error "Docker daemon is not running"
        return 1
    fi
    log_info "Docker daemon is running"
}

check_docker_command() {
    log_info "Checking Docker command availability..."
    if ! command -v docker >/dev/null 2>&1; then
        log_error "Docker command not found"
        return 1
    fi
    log_info "Docker version: $(docker --version)"
}

check_docker_compose() {
    log_info "Checking Docker Compose..."
    if ! command -v docker-compose >/dev/null 2>&1; then
        log_error "Docker Compose not found"
        return 1
    fi
    log_info "Docker Compose version: $(docker-compose --version)"
}

check_user_permissions() {
    log_info "Checking user Docker permissions..."
    if groups "$USER" | grep -q "docker"; then
        log_info "User is in docker group"
    else
        log_error "User is not in docker group"
        return 1
    fi
}

test_docker_run() {
    log_info "Testing Docker container execution..."
    if docker run --rm hello-world >/dev/null 2>&1; then
        log_info "Docker container execution test passed"
    else
        log_error "Docker container execution test failed"
        return 1
    fi
}

test_compose_services() {
    log_info "Testing Docker Compose services..."
    if [[ ! -f "$COMPOSE_FILE" ]]; then
        log_error "Docker Compose file not found: $COMPOSE_FILE"
        return 1
    fi
    
    cd "$(dirname "$COMPOSE_FILE")"
    
    if docker-compose config >/dev/null 2>&1; then
        log_info "Docker Compose configuration is valid"
    else
        log_error "Docker Compose configuration is invalid"
        return 1
    fi
    
    if docker-compose ps -q >/dev/null 2>&1; then
        log_info "Docker Compose can query service status"
    else
        log_error "Docker Compose service status query failed"
        return 1
    fi
}

check_daemon_config() {
    log_info "Checking Docker daemon configuration..."
    local daemon_config="/etc/docker/daemon.json"
    
    if [[ -f "$daemon_config" ]]; then
        log_info "Docker daemon configuration file exists"
        if jq empty "$daemon_config" 2>/dev/null; then
            log_info "Docker daemon configuration is valid JSON"
        else
            log_error "Docker daemon configuration is invalid JSON"
            return 1
        fi
    else
        log_info "Docker daemon configuration file not found (using defaults)"
    fi
}

main() {
    log_info "Starting Docker setup validation..."
    
    local failed=0
    
    check_docker_daemon || failed=1
    check_docker_command || failed=1
    check_docker_compose || failed=1
    check_user_permissions || failed=1
    test_docker_run || failed=1
    test_compose_services || failed=1
    check_daemon_config || failed=1
    
    if [[ $failed -eq 0 ]]; then
        log_info "All Docker setup validation tests passed!"
    else
        log_error "Some Docker setup validation tests failed"
        exit 1
    fi
}

main "$@"