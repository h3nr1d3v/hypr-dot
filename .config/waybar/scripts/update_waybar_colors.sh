#!/bin/bash

# Activar modo de depuración
set -x

# Lee la ruta del fondo de pantalla actual
WALLPAPER_PATH=$(cat "$HOME/.current_wallpaper")

echo "Ruta del fondo de pantalla: $WALLPAPER_PATH"

# Verifica si el archivo existe
if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Error: El archivo de fondo de pantalla no existe: $WALLPAPER_PATH" >&2
    exit 1
fi

# Obtén el color dominante del fondo de pantalla
COLOR=$(~/.config/waybar/scripts/get_dominant_color.sh "$WALLPAPER_PATH")

echo "Color obtenido: $COLOR"

# Verifica que COLOR sea un valor hexadecimal válido
if [[ ! $COLOR =~ ^[0-9A-Fa-f]{6}$ ]]; then
    echo "Error: Color inválido obtenido: $COLOR" >&2
    exit 1
fi

# Extrae los valores RGB del color hexadecimal
R=$(printf "%d" "0x${COLOR:0:2}")
G=$(printf "%d" "0x${COLOR:2:2}")
B=$(printf "%d" "0x${COLOR:4:2}")

echo "Valores RGB: R=$R, G=$G, B=$B"

# Calcula colores complementarios
INV_R=$((255 - R))
INV_G=$((255 - G))
INV_B=$((255 - B))

echo "Valores RGB invertidos: INV_R=$INV_R, INV_G=$INV_G, INV_B=$INV_B"

# Define los colores para Rofi
cat <<EOF > ~/.config/rofi/colors.rasi
* {
    bg2:    rgba($R, $G, $B, 0.5);
    fg0:    rgba($INV_R, $INV_G, $INV_B, 1);
    fg1:    rgba($INV_R, $INV_G, $INV_B, 0.8);
    fg2:    rgba($INV_R, $INV_G, $INV_B, 0.6);
    fg3:    rgba($INV_R, $INV_G, $INV_B, 0.4);
}
EOF

echo "Archivo colors.rasi actualizado para Rofi"

# Define el color de fondo y primer plano en formato CSS
cat <<EOF > ~/.config/waybar/theme.css
@define-color bar-bg rgba($R, $G, $B, 0.4);
@define-color main-bg rgba($R, $G, $B, 0.8);
@define-color main-fg rgba($INV_R, $INV_G, $INV_B, 1);

@define-color wb-act-bg rgba($INV_R, $INV_G, $INV_B, 0.8);
@define-color wb-act-fg rgba($R, $G, $B, 1);

@define-color wb-hvr-bg rgba($R, $G, $B, 0.6);
@define-color wb-hvr-fg rgba($INV_R, $INV_G, $INV_B, 1);
EOF

echo "Archivo theme.css actualizado:"
cat ~/.config/waybar/theme.css

# Calcula colores intermedios para el gradiente de Cava
MID_R1=$((R + (INV_R - R) / 4))
MID_G1=$((G + (INV_G - G) / 4))
MID_B1=$((B + (INV_B - B) / 4))

MID_R2=$((R + (INV_R - R) / 2))
MID_G2=$((G + (INV_G - G) / 2))
MID_B2=$((B + (INV_B - B) / 2))

MID_R3=$((R + 3 * (INV_R - R) / 4))
MID_G3=$((G + 3 * (INV_G - G) / 4))
MID_B3=$((B + 3 * (INV_B - B) / 4))

# Genera la configuración de colores para Cava
sed -i "s/gradient_color_1 = .*/gradient_color_1 = '#$(printf "%02x%02x%02x" $R $G $B)'/g" ~/.config/cava/config
sed -i "s/gradient_color_2 = .*/gradient_color_2 = '#$(printf "%02x%02x%02x" $MID_R1 $MID_G1 $MID_B1)'/g" ~/.config/cava/config
sed -i "s/gradient_color_3 = .*/gradient_color_3 = '#$(printf "%02x%02x%02x" $MID_R2 $MID_G2 $MID_B2)'/g" ~/.config/cava/config
sed -i "s/gradient_color_4 = .*/gradient_color_4 = '#$(printf "%02x%02x%02x" $MID_R3 $MID_G3 $MID_B3)'/g" ~/.config/cava/config
sed -i "s/gradient_color_5 = .*/gradient_color_5 = '#$(printf "%02x%02x%02x" $INV_R $INV_G $INV_B)'/g" ~/.config/cava/config
sed -i "s/gradient_color_6 = .*/gradient_color_6 = '#$(printf "%02x%02x%02x" $INV_R $INV_G $INV_B)'/g" ~/.config/cava/config
sed -i "s/gradient_color_7 = .*/gradient_color_7 = '#$(printf "%02x%02x%02x" $INV_R $INV_G $INV_B)'/g" ~/.config/cava/config
sed -i "s/gradient_color_8 = .*/gradient_color_8 = '#$(printf "%02x%02x%02x" $INV_R $INV_G $INV_B)'/g" ~/.config/cava/config

echo "Configuración de colores de Cava actualizada"

# Genera la configuración de colores para Alacritty
cat <<EOF > ~/.config/alacritty/colors.toml
[colors.primary]
background = "#$(printf "%02x%02x%02x" $R $G $B)"
foreground = "#$(printf "%02x%02x%02x" $INV_R $INV_G $INV_B)"

[colors.normal]
black = "#$(printf "%02x%02x%02x" $((R/4)) $((G/4)) $((B/4)))"
red = "#$(printf "%02x%02x%02x" $((INV_R)) $((G/4)) $((B/4)))"
green = "#$(printf "%02x%02x%02x" $((R/4)) $((INV_G)) $((B/4)))"
yellow = "#$(printf "%02x%02x%02x" $((INV_R)) $((INV_G)) $((B/4)))"
blue = "#$(printf "%02x%02x%02x" $((R/4)) $((G/4)) $((INV_B)))"
magenta = "#$(printf "%02x%02x%02x" $((INV_R)) $((G/4)) $((INV_B)))"
cyan = "#$(printf "%02x%02x%02x" $((R/4)) $((INV_G)) $((INV_B)))"
white = "#$(printf "%02x%02x%02x" $((INV_R)) $((INV_G)) $((INV_B)))"

[colors.bright]
black = "#$(printf "%02x%02x%02x" $((R/2)) $((G/2)) $((B/2)))"
red = "#$(printf "%02x%02x%02x" $((255)) $((G/2)) $((B/2)))"
green = "#$(printf "%02x%02x%02x" $((R/2)) $((255)) $((B/2)))"
yellow = "#$(printf "%02x%02x%02x" $((255)) $((255)) $((B/2)))"
blue = "#$(printf "%02x%02x%02x" $((R/2)) $((G/2)) $((255)))"
magenta = "#$(printf "%02x%02x%02x" $((255)) $((G/2)) $((255)))"
cyan = "#$(printf "%02x%02x%02x" $((R/2)) $((255)) $((255)))"
white = "#ffffff"
EOF

echo "Archivo colors.toml actualizado para Alacritty"

# Genera la configuración de colores para Hyprland
cat <<EOF > ~/.config/hypr/colors.conf
general {
    col.active_border = rgba(${R}${G}${B}ee) rgba(${INV_R}${INV_G}${INV_B}ee) 45deg
    col.inactive_border = rgba(${R}${G}${B}aa) rgba(${INV_R}${INV_G}${INV_B}aa) 45deg
}

group {
    col.border_active = rgba(${R}${G}${B}ff) rgba(${INV_R}${INV_G}${INV_B}ff) 45deg
    col.border_inactive = rgba(${R}${G}${B}cc) rgba(${INV_R}${INV_G}${INV_B}cc) 45deg
    col.border_locked_active = rgba(${R}${G}${B}ff) rgba(${INV_R}${INV_G}${INV_B}ff) 45deg
    col.border_locked_inactive = rgba(${R}${G}${B}cc) rgba(${INV_R}${INV_G}${INV_B}cc) 45deg
}
EOF

# Función para formatear valores de color
format_color() {
    printf "%02x" $1
}

# Genera la configuración de colores para Hyprland
cat <<EOF > ~/.config/hypr/colors.conf
general {
    col.active_border = rgba($(format_color $R)$(format_color $G)$(format_color $B)ee) rgba($(format_color $INV_R)$(format_color $INV_G)$(format_color $INV_B)ee) 45deg
    col.inactive_border = rgba($(format_color $R)$(format_color $G)$(format_color $B)aa) rgba($(format_color $INV_R)$(format_color $INV_G)$(format_color $INV_B)aa) 45deg
}

group {
    col.border_active = rgba($(format_color $R)$(format_color $G)$(format_color $B)ff) rgba($(format_color $INV_R)$(format_color $INV_G)$(format_color $INV_B)ff) 45deg
    col.border_inactive = rgba($(format_color $R)$(format_color $G)$(format_color $B)cc) rgba($(format_color $INV_R)$(format_color $INV_G)$(format_color $INV_B)cc) 45deg
    col.border_locked_active = rgba($(format_color $R)$(format_color $G)$(format_color $B)ff) rgba($(format_color $INV_R)$(format_color $INV_G)$(format_color $INV_B)ff) 45deg
    col.border_locked_inactive = rgba($(format_color $R)$(format_color $G)$(format_color $B)cc) rgba($(format_color $INV_R)$(format_color $INV_G)$(format_color $INV_B)cc) 45deg
}
EOF

echo "Archivo colors.conf actualizado para Hyprland"

# Genera un archivo JSON con los colores
cat <<EOF > ~/.config/waybar/colors.json
{
    "background": "#$(printf "%02x%02x%02x" $R $G $B)",
    "foreground": "#$(printf "%02x%02x%02x" $INV_R $INV_G $INV_B)",
    "primary": "#$(printf "%02x%02x%02x" $((R+INV_R)/2) $((G+INV_G)/2) $((B+INV_B)/2))",
    "secondary": "#$(printf "%02x%02x%02x" $((R+50)%256) $((G+50)%256) $((B+50)%256))",
    "tertiary": "#$(printf "%02x%02x%02x" $((INV_R+50)%256) $((INV_G+50)%256) $((INV_B+50)%256))"
}
EOF

echo "Archivo colors.json actualizado para Waybar"

# Genera la configuración de colores para Kitty
cat <<EOF > ~/.config/kitty/colors.conf
# The basic colors
foreground              #$(printf "%02x%02x%02x" $INV_R $INV_G $INV_B)
background              #$(printf "%02x%02x%02x" $R $G $B)
selection_foreground    #$(printf "%02x%02x%02x" $R $G $B)
selection_background    #$(printf "%02x%02x%02x" $INV_R $INV_G $INV_B)

# Cursor colors
cursor                  #$(printf "%02x%02x%02x" $INV_R $INV_G $INV_B)
cursor_text_color       #$(printf "%02x%02x%02x" $R $G $B)

# URL underline color when hovering with mouse
url_color               #$(printf "%02x%02x%02x" $INV_R $INV_G $INV_B)

# Kitty window border colors
active_border_color     #$(printf "%02x%02x%02x" $((R+INV_R)/2) $((G+INV_G)/2) $((B+INV_B)/2))
inactive_border_color   #$(printf "%02x%02x%02x" $((R+50)%256) $((G+50)%256) $((B+50)%256))
bell_border_color       #$(printf "%02x%02x%02x" $((INV_R+50)%256) $((INV_G+50)%256) $((INV_B+50)%256))

# Tab bar colors
active_tab_foreground   #$(printf "%02x%02x%02x" $R $G $B)
active_tab_background   #$(printf "%02x%02x%02x" $INV_R $INV_G $INV_B)
inactive_tab_foreground #$(printf "%02x%02x%02x" $INV_R $INV_G $INV_B)
inactive_tab_background #$(printf "%02x%02x%02x" $((R+25)%256) $((G+25)%256) $((B+25)%256))
tab_bar_background      #$(printf "%02x%02x%02x" $R $G $B)

# The 16 terminal colors
# black
color0 #$(printf "%02x%02x%02x" $((R/4)) $((G/4)) $((B/4)))
color8 #$(printf "%02x%02x%02x" $((R/2)) $((G/2)) $((B/2)))

# red
color1 #$(printf "%02x%02x%02x" $((INV_R)) $((G/4)) $((B/4)))
color9 #$(printf "%02x%02x%02x" $((255)) $((G/2)) $((B/2)))

# green
color2  #$(printf "%02x%02x%02x" $((R/4)) $((INV_G)) $((B/4)))
color10 #$(printf "%02x%02x%02x" $((R/2)) $((255)) $((B/2)))

# yellow
color3  #$(printf "%02x%02x%02x" $((INV_R)) $((INV_G)) $((B/4)))
color11 #$(printf "%02x%02x%02x" $((255)) $((255)) $((B/2)))

# blue
color4  #$(printf "%02x%02x%02x" $((R/4)) $((G/4)) $((INV_B)))
color12 #$(printf "%02x%02x%02x" $((R/2)) $((G/2)) $((255)))

# magenta
color5  #$(printf "%02x%02x%02x" $((INV_R)) $((G/4)) $((INV_B)))
color13 #$(printf "%02x%02x%02x" $((255)) $((G/2)) $((255)))

# cyan
color6  #$(printf "%02x%02x%02x" $((R/4)) $((INV_G)) $((INV_B)))
color14 #$(printf "%02x%02x%02x" $((R/2)) $((255)) $((255)))

# white
color7  #$(printf "%02x%02x%02x" $((INV_R)) $((INV_G)) $((INV_B)))
color15 #ffffff
EOF

echo "Archivo colors.conf actualizado para Kitty"

# Recarga la configuración de Kitty
killall -SIGUSR1 kitty

# Recarga waybar
killall -SIGUSR2 waybar && echo "Señal de recarga enviada a Waybar"

# Toca el archivo CSS para asegurar que Waybar detecte el cambio
touch ~/.config/waybar/style.css

dunstify "Colores actualizados" "Los colores de los programas han sido actualizados con éxito"
