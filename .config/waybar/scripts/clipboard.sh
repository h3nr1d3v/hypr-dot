#!/bin/bash

# Path to the clipboard script
SCRIPT_PATH="$HOME/.config/waybar/scripts/clipboard.sh"

# Create the script if it doesn't exist
if [ ! -f "$SCRIPT_PATH" ]; then
    mkdir -p "$(dirname "$SCRIPT_PATH")"
    cat << EOF > "$SCRIPT_PATH"
#!/bin/bash

# Function to show the clipboard menu using rofi
show_menu() {
    wl-paste --list-types | while read -r type; do
        wl-paste --type "\$type" | sed "s/^/[\$type] /"
    done | rofi -dmenu -i -p "Clipboard" | sed 's/^\[[^\]]*\] //' | wl-copy
}

# Main logic
case "\$1" in
    show)
        show_menu
        ;;
    *)
        echo "󰅌"  # Default icon when no argument is provided
        ;;
esac
EOF
    chmod +x "$SCRIPT_PATH"
fi

# Execute the script with the 'show' argument
"$SCRIPT_PATH" show
