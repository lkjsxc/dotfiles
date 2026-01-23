#!/usr/bin/env bash
# Lutris prefix cleanup utility
set -euo pipefail

readonly LUTRIS_DIR="$HOME/lutris"
readonly GAMES_DIR="$LUTRIS_DIR/Games"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

error_exit() {
    log "ERROR: $1" >&2
    exit 1
}

show_help() {
    cat << EOF
Lutris Prefix Cleanup Utility

Usage: $(basename "$0") [OPTIONS] [PREFIX_NAME]

Arguments:
  PREFIX_NAME    Name of the game prefix to remove (e.g., arknights-endfield)

Options:
  -l, --list     List all available game prefixes
  -a, --all      Remove all game prefixes (dangerous!)
  -h, --help     Show this help message

Examples:
  $(basename "$0") arknights-endfield    # Remove specific prefix
  $(basename "$0") --list                # List all prefixes
  $(basename "$0") --all                 # Remove all prefixes
EOF
}

list_prefixes() {
    log "Available game prefixes in $GAMES_DIR:"
    
    if [[ ! -d "$GAMES_DIR" ]]; then
        log "No games directory found at $GAMES_DIR"
        return 1
    fi
    
    local count=0
    for prefix in "$GAMES_DIR"/*; do
        if [[ -d "$prefix" ]]; then
            local basename_prefix=$(basename "$prefix")
            local size=$(du -sh "$prefix" 2>/dev/null | cut -f1 || echo "unknown")
            echo "  - $basename_prefix ($size)"
            ((count++))
        fi
    done
    
    if [[ $count -eq 0 ]]; then
        log "No game prefixes found"
    else
        log "Found $count game prefix(es)"
    fi
}

remove_prefix() {
    local prefix_name="$1"
    local prefix_path="$GAMES_DIR/$prefix_name"
    
    if [[ ! -d "$prefix_path" ]]; then
        error_exit "Prefix '$prefix_name' not found at $prefix_path"
    fi
    
    local size=$(du -sh "$prefix_path" 2>/dev/null | cut -f1 || echo "unknown")
    log "Removing prefix '$prefix_name' ($size)..."
    
    if rm -rf "$prefix_path"; then
        log "Successfully removed prefix '$prefix_name'"
    else
        error_exit "Failed to remove prefix '$prefix_name'"
    fi
}

remove_all_prefixes() {
    log "WARNING: This will remove ALL game prefixes!"
    read -p "Are you sure? (yes/no): " -r confirmation
    
    if [[ "$confirmation" != "yes" ]]; then
        log "Operation cancelled"
        exit 0
    fi
    
    if [[ ! -d "$GAMES_DIR" ]]; then
        log "No games directory found at $GAMES_DIR"
        return 0
    fi
    
    local count=0
    for prefix in "$GAMES_DIR"/*; do
        if [[ -d "$prefix" ]]; then
            local basename_prefix=$(basename "$prefix")
            remove_prefix "$basename_prefix"
            ((count++))
        fi
    done
    
    log "Removed $count game prefix(es)"
}

main() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -l|--list)
                list_prefixes
                exit $?
                ;;
            -a|--all)
                remove_all_prefixes
                exit $?
                ;;
            -*)
                error_exit "Unknown option: $1"
                ;;
            *)
                if [[ $# -eq 1 ]]; then
                    remove_prefix "$1"
                    exit $?
                else
                    error_exit "Too many arguments"
                fi
                ;;
        esac
        shift
    done
    
    show_help
    exit 1
}

main "$@"