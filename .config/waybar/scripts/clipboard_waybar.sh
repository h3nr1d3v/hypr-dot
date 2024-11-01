#!/bin/bash

# Path to the main clipboard script
CLIPBOARD_SCRIPT="$HOME/.config/waybar/scripts/clipboard.sh"

# Check if the script exists and is executable
if [[ -x "$CLIPBOARD_SCRIPT" ]]; then
    # If no arguments are provided, just output the icon
    if [[ $# -eq 0 ]]; then
        echo "󰅌"
    else
        # Otherwise, execute the main script with the provided argument
        "$CLIPBOARD_SCRIPT" "$1"
    fi
else
    echo "Error: Clipboard script not found or not executable"
fi
