#!/bin/bash

# Lee el color dominante del fondo de pantalla
WALLPAPER_PATH=$(cat "$HOME/.current_wallpaper")
COLOR=$(~/.config/waybar/scripts/get_dominant_color.sh "$WALLPAPER_PATH")

# Extrae los valores RGB
R=$(printf "%d" "0x${COLOR:0:2}")
G=$(printf "%d" "0x${COLOR:2:2}")
B=$(printf "%d" "0x${COLOR:4:2}")

# Calcula colores complementarios
INV_R=$((255 - R))
INV_G=$((255 - G))
INV_B=$((255 - B))

# Genera colores para pipes.sh
COLOR1=$(printf "\x1b[38;2;%d;%d;%dm" $R $G $B)
COLOR2=$(printf "\x1b[38;2;%d;%d;%dm" $INV_R $INV_G $INV_B)
COLOR3=$(printf "\x1b[38;2;%d;%d;%dm" $((R+INV_R)/2) $((G+INV_G)/2) $((B+INV_B)/2))
COLOR4=$(printf "\x1b[38;2;%d;%d;%dm" $((R+50)%256) $((G+50)%256) $((B+50)%256))

# Crea el archivo de configuración para pipes.sh
cat <<EOF > ~/.config/pipes/config
#!/bin/bash
PIPES_COLORS=($COLOR1 $COLOR2 $COLOR3 $COLOR4)
EOF
