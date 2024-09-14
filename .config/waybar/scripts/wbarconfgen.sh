#!/bin/bash
# Location: ~/.config/waybar/scripts/wbarconfgen.sh

BAR_CONFIGS=("bar1" "bar2" "bar3")
CURRENT_BAR_FILE="$HOME/.current_bar"

get_next_bar() {
    current=$(<"$CURRENT_BAR_FILE")
    for i in "${!BAR_CONFIGS[@]}"; do
        if [[ "${BAR_CONFIGS[$i]}" == "$current" ]]; then
            next_index=$(( (i + 1) % ${#BAR_CONFIGS[@]} ))
            echo "${BAR_CONFIGS[$next_index]}"
            return
        fi
    done
    echo "${BAR_CONFIGS[0]}"
}

get_previous_bar() {
    current=$(<"$CURRENT_BAR_FILE")
    for i in "${!BAR_CONFIGS[@]}"; do
        if [[ "${BAR_CONFIGS[$i]}" == "$current" ]]; then
            prev_index=$(( (i - 1 + ${#BAR_CONFIGS[@]}) % ${#BAR_CONFIGS[@]} ))
            echo "${BAR_CONFIGS[$prev_index]}"
            return
        fi
    done
    echo "${BAR_CONFIGS[0]}"
}

case "$1" in
    n) next_bar=$(get_next_bar) ;;
    p) prev_bar=$(get_previous_bar) ;;
    *) echo "Usage: $0 {n|p}" && exit 1 ;;
esac

# Apply the bar configuration here
# For example: ln -sf "$HOME/.config/waybar/bars/$next_bar" "$HOME/.config/waybar/current_bar"
echo "$next_bar" > "$CURRENT_BAR_FILE"
