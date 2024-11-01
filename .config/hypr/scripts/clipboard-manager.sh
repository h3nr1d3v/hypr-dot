#!/bin/bash

CLIPBOARD_STORE="$HOME/.cache/clipboard-store"
MAX_ITEMS=100
DEBUG_LOG="$HOME/.cache/clipboard-debug.log"
ROFI_CONFIG="$HOME/.config/rofi/Rofi.rasi"

# Ensure the clipboard store and debug log exist
mkdir -p "$(dirname "$CLIPBOARD_STORE")"
touch "$CLIPBOARD_STORE"
touch "$DEBUG_LOG"

log_debug() {
    echo "$(date): $1" >> "$DEBUG_LOG"
}

# Function to add content to store
add_to_store() {
    local content="$1"
    log_debug "Attempting to add: $content"
    if [ -n "$content" ]; then
        if ! grep -Fxq "$content" "$CLIPBOARD_STORE"; then
            echo "$content" | cat - "$CLIPBOARD_STORE" | head -n $MAX_ITEMS > "$CLIPBOARD_STORE.tmp"
            mv "$CLIPBOARD_STORE.tmp" "$CLIPBOARD_STORE"
            log_debug "Added successfully"
            notify-send "Clipboard Manager" "New item added to clipboard history"
        else
            log_debug "Not added (duplicate)"
        fi
    else
        log_debug "Not added (empty)"
    fi
    
    log_debug "Current clipboard store contents:"
    cat "$CLIPBOARD_STORE" >> "$DEBUG_LOG"
}

# Function to display clipboard history using rofi
show_menu() {
    log_debug "Showing menu"
    local selection
    selection=$(cat "$CLIPBOARD_STORE" | nl -w3 -s'. ' | \
                rofi -dmenu -i -p "Clipboard Search" -theme "$ROFI_CONFIG" \
                -kb-custom-1 "Alt+d" \
                -mesg "Enter to copy, Alt+d to delete")
    
    local rofi_exit="$?"
    
    if [ -n "$selection" ]; then
        local item_number=$(echo "$selection" | cut -d. -f1)
        local item_content=$(echo "$selection" | cut -d' ' -f2-)
        
        log_debug "Selected item: $item_number - $item_content"
        
        if [ "$rofi_exit" = 0 ]; then
            echo -n "$item_content" | wl-copy
            log_debug "Copied: $item_content"
            notify-send "Clipboard Manager" "Copied: $item_content"
        elif [ "$rofi_exit" = 10 ]; then
            if [[ "$item_number" =~ ^[0-9]+$ ]]; then
                delete_item "$item_number"
                show_menu  # Show the menu again after deletion
            else
                log_debug "Cannot delete: not an existing item (item_number: $item_number)"
                notify-send "Clipboard Manager" "Cannot delete: not an existing item"
            fi
        fi
    else
        log_debug "No selection made"
    fi
}

# Function to delete an item from the clipboard store
delete_item() {
    local item_number="$1"
    log_debug "Attempting to delete item number: $item_number"
    
    if [ -n "$item_number" ] && [ "$item_number" -gt 0 ]; then
        sed -i "${item_number}d" "$CLIPBOARD_STORE"
        log_debug "Deleted item number: $item_number"
        notify-send "Clipboard Manager" "Item deleted from clipboard history"
    else
        log_debug "Invalid item number: $item_number"
        notify-send "Clipboard Manager" "Error: Invalid item number"
    fi
}

# Function to clear the entire clipboard store
clear_clipboard() {
    > "$CLIPBOARD_STORE"
    log_debug "Cleared clipboard store"
    notify-send "Clipboard Manager" "Clipboard history cleared"
}

# Main logic
case "$1" in
    add)
        content=$(wl-paste -n 2>> "$DEBUG_LOG")
        log_debug "Content from wl-paste: $content"
        add_to_store "$content"
        ;;
    show)
        show_menu
        ;;
    clear)
        clear_clipboard
        ;;
    *)
        echo "Usage: $0 {add|show|clear}"
        exit 1
        ;;
esac
