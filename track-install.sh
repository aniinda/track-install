#!/bin/bash
# Installation Tracker - save as /usr/local/bin/track-install

INSTALL_LOG="$HOME/.server-installs.log"
LABEL="${TRACK_LABEL:-server-tools}"

function install_and_track() {
    local packages=("$@")
    
    # Install packages
    if command -v apt &> /dev/null; then
        sudo apt install -y "${packages[@]}"
        install_status=$?
    elif command -v yum &> /dev/null; then
        sudo yum install -y "${packages[@]}"
        install_status=$?
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y "${packages[@]}"
        install_status=$?
    else
        echo "Package manager not found"
        exit 1
    fi
    
    # Log only if installation was successful
    if [ $install_status -eq 0 ]; then
        for package in "${packages[@]}"; do
            echo "$(date '+%Y-%m-%d %H:%M:%S') | $LABEL | $package | $(whoami)" >> "$INSTALL_LOG"
        done
        echo "Tracked: ${packages[*]} under label '$LABEL'"
    fi
}

function show_installs() {
    if [ ! -f "$INSTALL_LOG" ]; then
        echo "No installations tracked yet"
        return
    fi
    
    local search_label="${1:-$LABEL}"
    echo "=== Installations under label: $search_label ==="
    grep "| $search_label |" "$INSTALL_LOG" | while IFS='|' read -r date label package user; do
        package=$(echo "$package" | xargs)  # trim whitespace
        # Check if still installed
        if command -v apt &> /dev/null && dpkg -l | grep -q "^ii.*$package "; then
            status="✓ installed"
        elif command -v rpm &> /dev/null && rpm -q "$package" &>/dev/null; then
            status="✓ installed" 
        else
            status="? check manually"
        fi
        printf "%-20s %s (%s)\n" "$package" "$status" "$(echo $date | xargs)"
    done
}

function list_all() {
    if [ ! -f "$INSTALL_LOG" ]; then
        echo "No installations tracked yet"
        return
    fi
    
    echo "=== All tracked installations ==="
    sort "$INSTALL_LOG" | while IFS='|' read -r date label package user; do
        printf "%s | %-15s | %s\n" "$(echo $date | xargs)" "$(echo $label | xargs)" "$(echo $package | xargs)"
    done
}

# Main command
case "$1" in
    "")
        if [ $# -eq 0 ]; then
            echo "Usage: track-install <packages...>  OR  track-install show [label]  OR  track-install all"
            echo "Set TRACK_LABEL environment variable to change label (default: server-tools)"
        else
            install_and_track "$@"
        fi
        ;;
    "show")
        show_installs "$2"
        ;;
    "all")
        list_all
        ;;
    *)
        install_and_track "$@"
        ;;
esac
