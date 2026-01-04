#!/bin/bash

# Terminal Config Setup Script
# Usage: ./setup.sh install|remove

# set -e

# Script directory (where setup.sh is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"

# Configuration files (source:target pairs)
CONFIG_FILES=(
    "init.lua:$HOME/.config/nvim/init.lua"
    "tmux.conf:$HOME/.tmux.conf"
    "wezterm.lua:$HOME/.wezterm.lua"
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print colored messages
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${YELLOW}→${NC} $1"; }

# Create backup of existing file
backup_file() {
    local target=$1
    local filename=$(basename "$target")

    if [ -e "$target" ] || [ -L "$target" ]; then
        mkdir -p "$BACKUP_DIR"
        local timestamp=$(date +%Y%m%d_%H%M%S)
        local backup_path="$BACKUP_DIR/${filename}.${timestamp}"

        # If it's a symlink, save the link target
        if [ -L "$target" ]; then
            readlink "$target" > "${backup_path}.symlink_target"
            print_info "Backed up symlink info: $target"
        else
            cp -a "$target" "$backup_path"
            print_info "Backed up existing file: $target"
        fi

        rm "$target"
        return 0
    fi
    return 1
}

# Install configuration files
install() {
    print_info "Installing terminal configurations..."
    echo ""

    local success_count=0
    local total_count=${#CONFIG_FILES[@]}

    for config_pair in "${CONFIG_FILES[@]}"; do
        # Split by colon
        local source_file="${config_pair%%:*}"
        local target_path="${config_pair##*:}"
        local source_path="$SCRIPT_DIR/$source_file"
        local target_dir=$(dirname "$target_path")

        print_info "Processing $source_file..."

        # Check if source file exists
        if [ ! -f "$source_path" ]; then
            print_error "Source file not found: $source_path"
            continue
        fi

        # Create target directory if it doesn't exist
        if [ ! -d "$target_dir" ]; then
            mkdir -p "$target_dir"
            print_info "Created directory: $target_dir"
        fi

        # Backup existing file/symlink
        backup_file "$target_path" || print_info "No existing config to backup for $source_file"

        # Create symlink
        ln -s "$source_path" "$target_path"
        print_success "Created symlink: $target_path -> $source_path"
        ((success_count++))
        echo ""
    done

    echo ""
    print_success "Installation complete! ($success_count/$total_count files configured)"

    if [ -d "$BACKUP_DIR" ]; then
        print_info "Backups stored in: $BACKUP_DIR"
    fi
}

# Remove configuration symlinks and restore backups
remove() {
    print_info "Removing terminal configurations..."
    echo ""

    local success_count=0

    for config_pair in "${CONFIG_FILES[@]}"; do
        local source_file="${config_pair%%:*}"
        local target_path="${config_pair##*:}"
        local filename=$(basename "$target_path")

        print_info "Processing $source_file..."

        # Remove symlink if it exists and points to our config
        if [ -L "$target_path" ]; then
            local link_target=$(readlink "$target_path")
            if [[ "$link_target" == "$SCRIPT_DIR/$source_file" ]]; then
                rm "$target_path"
                print_success "Removed symlink: $target_path"
                ((success_count++))

                # Restore most recent backup
                local latest_backup=$(ls -t "$BACKUP_DIR/${filename}".* 2>/dev/null | grep -v ".symlink_target" | head -1)
                if [ -n "$latest_backup" ]; then
                    cp -a "$latest_backup" "$target_path"
                    print_success "Restored backup: $target_path"
                else
                    print_info "No backup found to restore for $filename"
                fi
            else
                print_info "Skipped: $target_path (points to different location)"
            fi
        elif [ -e "$target_path" ]; then
            print_info "Not a symlink: $target_path (skipping)"
        else
            print_info "File doesn't exist: $target_path"
        fi
        echo ""
    done

    echo ""
    print_success "Removal complete! ($success_count files processed)"
}

# Show usage information
usage() {
    echo "Usage: $0 {install|remove}"
    echo ""
    echo "Commands:"
    echo "  install  - Create symlinks and backup existing configs"
    echo "  remove   - Remove symlinks and restore previous configs"
    echo ""
    echo "Configuration files:"
    for config_pair in "${CONFIG_FILES[@]}"; do
        echo "  - ${config_pair%%:*} -> ${config_pair##*:}"
    done
    exit 1
}

# Main script logic
main() {
    if [ $# -eq 0 ]; then
        usage
    fi

    case "$1" in
        install)
            install
            ;;
        remove)
            remove
            ;;
        *)
            print_error "Invalid command: $1"
            usage
            ;;
    esac
}

main "$@"

