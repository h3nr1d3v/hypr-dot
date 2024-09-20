#!/bin/bash
# Location: ~/.config/waybar/scripts/swwwallpaper.sh

NEXT_WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CURRENT_WALLPAPER="$HOME/.current_wallpaper"

get_next_wallpaper() {
    wallpapers=("$NEXT_WALLPAPER_DIR"/*)
    current=$(<"$CURRENT_WALLPAPER")
    for i in "${!wallpapers[@]}"; do
        if [[ "${wallpapers[$i]}" == "$current" ]]; then
            next_index=$(( (i + 1) % ${#wallpapers[@]} ))
            echo "${wallpapers[$next_index]}"
            return
        fi
    done
    echo "${wallpapers[0]}"
}

get_previous_wallpaper() {
    wallpapers=("$NEXT_WALLPAPER_DIR"/*)
    current=$(<"$CURRENT_WALLPAPER")
    for i in "${!wallpapers[@]}"; do
        if [[ "${wallpapers[$i]}" == "$current" ]]; then
            prev_index=$(( (i - 1 + ${#wallpapers[@]}) % ${#wallpapers[@]} ))
            echo "${wallpapers[$prev_index]}"
            return
        fi
    done
    echo "${wallpapers[0]}"
}

case "$1" in
    -n) wallpaper=$(get_next_wallpaper) ;;
    -p) wallpaper=$(get_previous_wallpaper) ;;
    *) echo "Usage: $0 {-n|-p}" && exit 1 ;;
esac

swww img "$wallpaper" && echo "$wallpaper" > "$CURRENT_WALLPAPER"

# Actualiza los colores de waybar
~/.config/waybar/scripts/update_waybar_colors.sh


# Recarga Alacritty
~/.config/alacritty/reload.sh

# Recarga Hyper
hyprctl reload

# Recarga Firefox
pkill -f firefox && firefox &

# Recargar colores en Neovim si está en ejecución
nvim --server /tmp/nvim.pipe --remote-send ":lua require('catppuccin').load()<CR>"

#Recargar colores en Ranger
~/.config/ranger/reload.sh

#Recargar los colores de pipes.sh
~/.config/pipes/generate_config.sh


# Actualiza la configuración de cmatrix
~/.config/cmatrix/dynamic_cmatrix.sh
