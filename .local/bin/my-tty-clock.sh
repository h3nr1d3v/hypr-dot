#!/bin/bash

# Lee el color dominante del fondo de pantalla
WALLPAPER_PATH=$(cat "$HOME/.current_wallpaper")
COLOR=$(~/.config/waybar/scripts/get_dominant_color.sh "$WALLPAPER_PATH")

# Extrae los valores RGB
R=$(printf "%d" "0x${COLOR:0:2}")
G=$(printf "%d" "0x${COLOR:2:2}")
B=$(printf "%d" "0x${COLOR:4:2}")

# Calcula el color complementario
INV_R=$((255 - R))
INV_G=$((255 - G))
INV_B=$((255 - B))

# Configura el color de la terminal
tput setaf $(( 16 + 36 * INV_R / 255 + 6 * INV_G / 255 + INV_B / 255 ))

# Ejecuta tty-clock
tty-clock "$@" -c

# Restaura los colores de la terminal
tput sgr0
