#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ROOT_DIR="$(dirname "$SCRIPT_DIR")"
readonly CONFIG_DIR="$ROOT_DIR/config-files"

DRY_RUN=${1:-""}
CATEGORY=${2:-""}

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

error_exit() {
    echo "Error: $1" >&2
    exit 1
}

backup_file() {
    local file_path="$1"
    local backup_path="${file_path}.backup.$(date +%Y%m%d_%H%M%S)"
    
    if [[ -f "$file_path" ]]; then
        cp "$file_path" "$backup_path"
        log "Backed up $file_path to $backup_path"
    fi
}

deploy_file() {
    local source="$1"
    local target="$2"
    local owner="${3:-$USER}"
    
    log "Deploying $source to $target"
    
    if [[ "$DRY_RUN" == "--dry-run" ]]; then
        log "DRY RUN: Would deploy $source to $target"
        return 0
    fi
    
    # Create parent directory if needed
    local target_dir=$(dirname "$target")
    mkdir -p "$target_dir"
    
    # Backup existing file
    backup_file "$target"
    
    # Copy file
    cp "$source" "$target"
    chown "$owner:$owner" "$target"
    chmod 644 "$target"
    
    log "Deployed $source to $target"
}

deploy_configs() {
    local category="$1"
    
    case "$category" in
        "shell")
            deploy_shell_configs
            ;;
        "development")
            deploy_development_configs
            ;;
        "system")
            deploy_system_configs
            ;;
        "all"|"" )
            deploy_shell_configs
            deploy_development_configs
            deploy_system_configs
            ;;
        *)
            error_exit "Unknown category: $category"
            ;;
    esac
}

deploy_shell_configs() {
    log "Deploying shell configurations..."
    
    # Bash configuration
    if [[ -f "$CONFIG_DIR/shell/.bashrc" ]]; then
        deploy_file "$CONFIG_DIR/shell/.bashrc" "$HOME/.bashrc"
    fi
    
    if [[ -f "$CONFIG_DIR/shell/.bash_profile" ]]; then
        deploy_file "$CONFIG_DIR/shell/.bash_profile" "$HOME/.bash_profile"
    fi
    
    log "Shell configurations deployed"
}

deploy_development_configs() {
    log "Deploying development configurations..."
    
    # Git configuration
    if [[ -f "$CONFIG_DIR/development/.gitconfig" ]]; then
        deploy_file "$CONFIG_DIR/development/.gitconfig" "$HOME/.gitconfig"
    fi
    
    # VSCode settings
    if [[ -f "$CONFIG_DIR/development/settings.json" ]]; then
        deploy_file "$CONFIG_DIR/development/settings.json" "$HOME/.config/Code/User/settings.json"
    fi
    
    log "Development configurations deployed"
}

deploy_system_configs() {
    log "Deploying system configurations..."
    
    # System configurations (require sudo)
    if [[ "$DRY_RUN" != "--dry-run" ]]; then
        # Ask for sudo password
        sudo -v
        
        # Deploy system configs if they exist
        if [[ -d "$CONFIG_DIR/system" ]]; then
            find "$CONFIG_DIR/system" -type f -name "*.*" | while read -r config_file; do
                local relative_path=${config_file#$CONFIG_DIR/system/}
                local target_path="/etc/$relative_path"
                
                log "Would deploy system config: $config_file to $target_path"
                # Uncomment below to actually deploy system configs
                # sudo cp "$config_file" "$target_path"
            done
        fi
    else
        log "DRY RUN: System configs would be deployed with sudo"
    fi
    
    log "System configurations deployment completed"
}

validate_deployment() {
    log "Validating deployment..."
    
    local validation_errors=0
    
    # Check shell configs
    if [[ ! -f "$HOME/.bashrc" ]]; then
        log "Validation error: ~/.bashrc not found"
        ((validation_errors++))
    fi
    
    # Check git config
    if [[ ! -f "$HOME/.gitconfig" ]]; then
        log "Validation error: ~/.gitconfig not found"
        ((validation_errors++))
    fi
    
    # Check git configuration
    if command -v git >/dev/null 2>&1; then
        local git_name=$(git config --global user.name || echo "")
        local git_email=$(git config --global user.email || echo "")
        
        if [[ -z "$git_name" || -z "$git_email" ]]; then
            log "Validation warning: Git user configuration incomplete"
        fi
    fi
    
    if [[ $validation_errors -eq 0 ]]; then
        log "✓ Deployment validation passed"
        return 0
    else
        log "✗ Deployment validation failed with $validation_errors errors"
        return 1
    fi
}

show_usage() {
    cat << EOF
Usage: $0 [--dry-run] [--category <category>]

Options:
  --dry-run     Show what would be deployed without making changes
  --category    Deploy specific category (shell, development, system, all)
  --help        Show this help message

Categories:
  shell         Deploy shell configurations (.bashrc, .bash_profile)
  development   Deploy development configurations (.gitconfig, VSCode)
  system        Deploy system configurations (requires sudo)
  all           Deploy all configurations (default)

Examples:
  $0                           # Deploy all configurations
  $0 --dry-run                 # Preview deployment
  $0 --category shell         # Deploy only shell configs
  $0 --category development    # Deploy only development configs
EOF
}

main() {
    log "Starting configuration deployment..."
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN="--dry-run"
                shift
                ;;
            --category)
                CATEGORY="$2"
                shift 2
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                error_exit "Unknown option: $1. Use --help for usage."
                ;;
        esac
    done
    
    if [[ "$DRY_RUN" == "--dry-run" ]]; then
        log "=== DRY RUN MODE - No changes will be made ==="
    fi
    
    # Deploy configurations
    deploy_configs "$CATEGORY"
    
    # Validate deployment
    if [[ "$DRY_RUN" != "--dry-run" ]]; then
        validate_deployment
    fi
    
    log "Configuration deployment completed!"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi