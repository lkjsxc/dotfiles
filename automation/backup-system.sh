#!/usr/bin/env bash
set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly ROOT_DIR="$(dirname "$SCRIPT_DIR")"

BACKUP_DIR="${1:-"$HOME/.dotfiles-backups"}"
ACTION="${2:-"create"}"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

error_exit() {
    echo "Error: $1" >&2
    exit 1
}

create_backup() {
    local backup_dir="$1"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local full_backup_dir="$backup_dir/$timestamp"
    
    log "Creating backup in $full_backup_dir"
    
    # Create backup directory
    mkdir -p "$full_backup_dir"
    
    # Backup home directory configurations
    log "Backing up home configurations..."
    
    local home_configs=(
        "$HOME/.bashrc"
        "$HOME/.bash_profile"
        "$HOME/.gitconfig"
        "$HOME/.config/nvim"
        "$HOME/.config/Code/User/settings.json"
    )
    
    for config in "${home_configs[@]}"; do
        if [[ -e "$config" ]]; then
            local relative_path="${config#$HOME/}"
            local target_dir="$full_backup_dir/home/$(dirname "$relative_path")"
            mkdir -p "$target_dir"
            cp -r "$config" "$target_dir/"
            log "Backed up $config"
        fi
    done
    
    # Backup system configurations (requires sudo)
    log "Backing up system configurations..."
    
    local system_configs=(
        "/etc/hosts"
        "/etc/fstab"
        "/etc/systemd/system"
    )
    
    for config in "${system_configs[@]}"; do
        if [[ -e "$config" ]]; then
            local target_dir="$full_backup_dir/system$(dirname "$config")"
            sudo mkdir -p "$target_dir"
            sudo cp -r "$config" "$target_dir/"
            log "Backed up $config"
        fi
    done
    
    # Backup package lists
    log "Backing up package information..."
    
    # Official packages
    pacman -Qqe > "$full_backup_dir/packages/official-packages.txt"
    
    # AUR packages
    if command -v yay >/dev/null 2>&1; then
        yay -Qqe > "$full_backup_dir/packages/aur-packages.txt"
    fi
    
    # Create backup info
    cat > "$full_backup_dir/backup-info.txt" << EOF
Backup created: $(date)
Hostname: $(hostname)
User: $USER
OS: $(uname -a)
Description: Arch Linux dotfiles backup

Contents:
- home/          - User configuration files
- system/        - System configuration files  
- packages/      - Package lists
EOF
    
    # Compress backup
    log "Compressing backup..."
    cd "$backup_dir"
    tar -czf "backup-$timestamp.tar.gz" "$timestamp"
    rm -rf "$timestamp"
    
    log "Backup completed: $backup_dir/backup-$timestamp.tar.gz"
}

restore_backup() {
    local backup_file="$1"
    
    if [[ ! -f "$backup_file" ]]; then
        error_exit "Backup file not found: $backup_file"
    fi
    
    log "Restoring from backup: $backup_file"
    
    # Extract backup
    local temp_dir=$(mktemp -d)
    tar -xzf "$backup_file" -C "$temp_dir"
    
    # Find the backup directory (should be the only directory in temp_dir)
    local backup_dir=$(find "$temp_dir" -maxdepth 1 -type d | tail -n 1)
    
    # Restore home configurations
    if [[ -d "$backup_dir/home" ]]; then
        log "Restoring home configurations..."
        cp -rT "$backup_dir/home/" "$HOME/"
        log "Home configurations restored"
    fi
    
    # Restore system configurations (requires sudo)
    if [[ -d "$backup_dir/system" ]]; then
        log "Restoring system configurations..."
        sudo cp -rT "$backup_dir/system/" "/"
        log "System configurations restored"
    fi
    
    # Clean up
    rm -rf "$temp_dir"
    
    log "Backup restoration completed!"
}

list_backups() {
    local backup_dir="$1"
    
    log "Available backups in $backup_dir:"
    
    if [[ -d "$backup_dir" ]]; then
        find "$backup_dir" -name "backup-*.tar.gz" -type f | sort | while read -r backup; do
            local basename=$(basename "$backup")
            local size=$(du -h "$backup" | cut -f1)
            echo "  $basename ($size)"
        done
    else
        log "No backup directory found"
    fi
}

show_usage() {
    cat << EOF
Usage: $0 [--backup-dir <directory>] [--action <action>] [--backup-file <file>] [--list]

Options:
  --backup-dir    Directory to store backups (default: ~/.dotfiles-backups)
  --action        Action to perform (create, restore, list) (default: create)
  --backup-file   Backup file to restore from (required for restore action)
  --list          List available backups
  --help          Show this help message

Actions:
  create          Create a new system backup
  restore         Restore from backup file
  list            List available backups

Examples:
  $0                              # Create backup in default location
  $0 --backup-dir /tmp/backups    # Create backup in custom location
  $0 --action restore --backup-file ~/.dotfiles-backups/backup-20231201_120000.tar.gz
  $0 --action list                # List available backups
EOF
}

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --backup-dir)
                BACKUP_DIR="$2"
                shift 2
                ;;
            --action)
                ACTION="$2"
                shift 2
                ;;
            --backup-file)
                BACKUP_FILE="$2"
                shift 2
                ;;
            --list)
                ACTION="list"
                shift
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
    
    case "$ACTION" in
        "create")
            create_backup "$BACKUP_DIR"
            ;;
        "restore")
            if [[ -z "${BACKUP_FILE:-}" ]]; then
                error_exit "Backup file required for restore action"
            fi
            restore_backup "$BACKUP_FILE"
            ;;
        "list")
            list_backups "$BACKUP_DIR"
            ;;
        *)
            error_exit "Unknown action: $ACTION"
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi