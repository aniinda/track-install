#!/bin/bash

# track-install.sh — Initial setup script for installing track-install system
# Usage: curl -fsSL https://yourdomain.com/track-install.sh | bash

INSTALL_PATH="/usr/local/bin/track-install"
LOG_FILE="$HOME/.server-installs.log"

# Create the track-install command
cat << 'EOF' > "$INSTALL_PATH"
#!/bin/bash

LOG_FILE="$HOME/.server-installs.log"
LABEL="${TRACK_LABEL:-server-tools}"
USER=$(whoami)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Ensure log file exists
touch "$LOG_FILE"

# Show log contents
if [[ "$1" == "show" ]]; then
    if [[ "$2" == "all" ]]; then
        echo "=== All Logged Installations ==="
        awk -F ' *\\| *' '{ print $2 ": " $3 }' "$LOG_FILE"
    elif [[ "$2" == "labels" ]]; then
        echo "=== All Created Labels ==="
        awk -F ' *\\| *' '{ print $2 }' "$LOG_FILE" | sort | uniq | while read -r lbl; do
            count=$(awk -F ' *\\| *' -v label="$lbl" '$2 == label' "$LOG_FILE" | wc -l)
            echo "$lbl ($count packages)"
        done
    else
        LABEL_QUERY="${2:-$LABEL}"
        echo "=== Installations under label: $LABEL_QUERY ==="
        awk -F ' *\\| *' -v label="$LABEL_QUERY" '$2 == label { print $3 }' "$LOG_FILE" | while read -r pkg; do
            dpkg -s "$pkg" &> /dev/null && echo "$pkg                ✓ installed" || echo "$pkg                ✗ not found"
        done
    fi
    exit 0
fi

# Update package lists first
sudo apt update -qq

# Main logic: handle multiple packages or commands
for pkg in "$@"; do
    if sudo apt install -y "$pkg"; then
        IFS=',' read -ra LABELS <<< "$LABEL"
        for lbl in "${LABELS[@]}"; do
            echo "$TIMESTAMP | $lbl | $pkg | $USER" >> "$LOG_FILE"
        done
        echo "✅ Installed and tracked: $pkg"
    else
        echo "❌ Failed to install: $pkg"
    fi
done
EOF

# Make executable
chmod +x "$INSTALL_PATH"

# Optional: add aliases
if ! grep -q "alias ti=" ~/.bashrc; then
    echo "alias ti='track-install'" >> ~/.bashrc
    echo "alias ts='track-install show'" >> ~/.bashrc
    echo "alias ta='track-install all'" >> ~/.bashrc
    echo "✅ Aliases added to ~/.bashrc (ti, ts, ta)"
fi

echo "✅ track-install is now available as a global command."
echo "📄 Log file: $LOG_FILE"
echo "ℹ️ Usage examples:"
echo "   TRACK_LABEL=\"web,nginx\" track-install nginx curl"
echo "   track-install show web"
echo "   track-install show labels"
echo "   track-install show all"
