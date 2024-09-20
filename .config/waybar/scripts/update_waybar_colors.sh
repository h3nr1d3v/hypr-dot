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

# Genera el archivo CSS para la página de inicio de Firefox
cat <<EOF > ~/Documents/Home/firefox-colors.css
:root {
  --bg-color: rgba($R, $G, $B, 0.05);
  --fg-color: rgba($INV_R, $INV_G, $INV_B, 1);
  --accent-color: rgba($((R+INV_R)/2), $((G+INV_G)/2), $((B+INV_B)/2), 1);
  --hover-color: rgba($R, $G, $B, 0.05);
}
EOF

echo "Archivo firefox-colors.css actualizado para la página de inicio de Firefox"

# Añade esto al final del script update_waybar_colors.sh

# Función para actualizar los colores CSS
update_firefox_css() {
    local css_file="$1"
    local is_dark="$2"

    # Colores base
    local bg_color=$(printf "#%02x%02x%02x" $R $G $B)
    local fg_color=$(printf "#%02x%02x%02x" $INV_R $INV_G $INV_B)

    # Colores derivados
    local toolbar_bg=$(printf "#%02x%02x%02x" $((R*95/100)) $((G*95/100)) $((B*95/100)))
    local toolbar_fg=$(printf "#%02x%02x%02x" $INV_R $INV_G $INV_B)
    local tab_bg=$(printf "#%02x%02x%02x" $((R*90/100)) $((G*90/100)) $((B*90/100)))
    local tab_fg=$(printf "#%02x%02x%02x" $INV_R $INV_G $INV_B)
    local urlbar_bg=$(printf "#%02x%02x%02x" $((R*85/100)) $((G*85/100)) $((B*85/100)))
    local urlbar_fg=$(printf "#%02x%02x%02x" $INV_R $INV_G $INV_B)

    if [ "$is_dark" = "true" ]; then
        # Invertir colores para el tema oscuro
        local temp=$bg_color
        bg_color=$fg_color
        fg_color=$temp
        toolbar_bg=$(printf "#%02x%02x%02x" $((255-R*95/100)) $((255-G*95/100)) $((255-B*95/100)))
        tab_bg=$(printf "#%02x%02x%02x" $((255-R*90/100)) $((255-G*90/100)) $((255-B*90/100)))
        urlbar_bg=$(printf "#%02x%02x%02x" $((255-R*85/100)) $((255-G*85/100)) $((255-B*85/100)))
    fi

    # Actualizar colores en el archivo CSS
    sed -i "s/--gnome-browser-before-load-background: #[0-9a-fA-F]\{6\};/--gnome-browser-before-load-background: $bg_color;/" "$css_file"
    sed -i "s/--gnome-toolbar-background: #[0-9a-fA-F]\{6\};/--gnome-toolbar-background: $toolbar_bg;/" "$css_file"
    sed -i "s/--gnome-toolbar-color: #[0-9a-fA-F]\{6\};/--gnome-toolbar-color: $toolbar_fg;/" "$css_file"
    sed -i "s/--gnome-tabbar-tab-background: #[0-9a-fA-F]\{6\};/--gnome-tabbar-tab-background: $tab_bg;/" "$css_file"
    sed -i "s/--gnome-tabbar-tab-color: rgb([0-9]\+, [0-9]\+, [0-9]\+);/--gnome-tabbar-tab-color: $tab_fg;/" "$css_file"
    sed -i "s/--gnome-urlbar-background: #[0-9a-fA-F]\{6\};/--gnome-urlbar-background: $urlbar_bg;/" "$css_file"
    sed -i "s/--gnome-urlbar-color: #[0-9a-fA-F]\{6\};/--gnome-urlbar-color: $urlbar_fg;/" "$css_file"
}

# Actualizar archivos CSS de Firefox
firefox_profile_dir="$HOME/.mozilla/firefox/emjksyxk.default-release"
update_firefox_css "$firefox_profile_dir/chrome/WhiteSur/colors/light.css" "false"
update_firefox_css "$firefox_profile_dir/chrome/WhiteSur/colors/dark.css" "true"

echo "Archivos CSS de Firefox actualizados"


# Genera la configuración de colores para Neovim
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

# Función para asegurar que los valores RGB estén en el rango 0-255
clamp_color() {
    echo $(( $1 > 255 ? 255 : ($1 < 0 ? 0 : $1) ))
}

# Función para generar color hexadecimal válido
generate_hex_color() {
    local r=$(clamp_color $1)
    local g=$(clamp_color $2)
    local b=$(clamp_color $3)
    printf "%02x%02x%02x" $r $g $b
}

# Genera la configuración de colores para Neovim
cat <<EOF > ~/.config/nvim/colors.lua
return {
    rosewater = "#$(generate_hex_color $((R+80)) $((G+50)) $((B+50)))",
    flamingo = "#$(generate_hex_color $((R+70)) $((G+40)) $((B+40)))",
    pink = "#$(generate_hex_color $((R+60)) $((G+30)) $((B+50)))",
    mauve = "#$(generate_hex_color $((R+40)) $((G+20)) $((B+60)))",
    red = "#$(generate_hex_color $((R+100)) $((G+20)) $((B+20)))",
    maroon = "#$(generate_hex_color $((R+90)) $((G+30)) $((B+40)))",
    peach = "#$(generate_hex_color $((R+80)) $((G+40)) $((B+20)))",
    yellow = "#$(generate_hex_color $((R+70)) $((G+70)) $((B+10)))",
    green = "#$(generate_hex_color $((R+10)) $((G+80)) $((B+10)))",
    teal = "#$(generate_hex_color $((R+10)) $((G+70)) $((B+60)))",
    sky = "#$(generate_hex_color $((R+20)) $((G+60)) $((B+80)))",
    sapphire = "#$(generate_hex_color $((R+30)) $((G+50)) $((B+90)))",
    blue = "#$(generate_hex_color $((R+20)) $((G+40)) $((B+100)))",
    lavender = "#$(generate_hex_color $((R+40)) $((G+40)) $((B+90)))",
    text = "#$(generate_hex_color $INV_R $INV_G $INV_B)",
    subtext1 = "#$(generate_hex_color $((INV_R-20)) $((INV_G-20)) $((INV_B-20)))",
    subtext0 = "#$(generate_hex_color $((INV_R-40)) $((INV_G-40)) $((INV_B-40)))",
    overlay2 = "#$(generate_hex_color $((INV_R-60)) $((INV_G-60)) $((INV_B-60)))",
    overlay1 = "#$(generate_hex_color $((INV_R-80)) $((INV_G-80)) $((INV_B-80)))",
    overlay0 = "#$(generate_hex_color $((INV_R-100)) $((INV_G-100)) $((INV_B-100)))",
    surface2 = "#$(generate_hex_color $((R+40)) $((G+40)) $((B+40)))",
    surface1 = "#$(generate_hex_color $((R+20)) $((G+20)) $((B+20)))",
    surface0 = "#$(generate_hex_color $((R+10)) $((G+10)) $((B+10)))",
    base = "#$COLOR",
    mantle = "#$(generate_hex_color $((R-10)) $((G-10)) $((B-10)))",
    crust = "#$(generate_hex_color $((R-20)) $((G-20)) $((B-20)))",
}
EOF

echo "Archivo colors.lua actualizado para Neovim"



# Genera la configuración de colores para BetterDiscord

# Obtén el color dominante del fondo de pantalla
WALLPAPER_PATH=$(cat "$HOME/.current_wallpaper")
DOMINANT_COLOR=$(~/.config/waybar/scripts/get_dominant_color.sh "$WALLPAPER_PATH")

# Calcula colores complementarios
R=$(printf "%d" "0x${DOMINANT_COLOR:0:2}")
G=$(printf "%d" "0x${DOMINANT_COLOR:2:2}")
B=$(printf "%d" "0x${DOMINANT_COLOR:4:2}")

INV_R=$((255 - R))
INV_G=$((255 - G))
INV_B=$((255 - B))

# Función para generar un color hexadecimal
hex_color() {
    printf "%02x%02x%02x" $1 $2 $3
}

# Función para generar un color rgba
rgba_color() {
    echo "rgba($1, $2, $3, $4)"
}

# Actualiza el archivo CSS de BetterDiscord
cat <<EOF > ~/.config/BetterDiscord/themes/dynamic-colors.theme.css
/**
 * @name Dynamic Colors
 * @description Cambia los colores de Discord basándose en el fondo de pantalla
 * @version 1.0
 * @author H3nr1d3v
 */

:root {
  --brand-experiment: #$(hex_color $R $G $B);
  --background-primary: #$(hex_color $((R*15/100)) $((G*15/100)) $((B*15/100)));
  --background-secondary: #$(hex_color $((R*12/100)) $((G*12/100)) $((B*12/100)));
  --background-secondary-alt: #$(hex_color $((R*10/100)) $((G*10/100)) $((B*10/100)));
  --background-tertiary: #$(hex_color $((R*9/100)) $((G*9/100)) $((B*9/100)));
  --background-accent: #$(hex_color $R $G $B);
  --background-floating: #$(hex_color $((R*8/100)) $((G*8/100)) $((B*8/100)));
  --background-mobile-primary: var(--background-primary);
  --background-mobile-secondary: var(--background-secondary);
  
  --text-normal: #$(hex_color $INV_R $INV_G $INV_B);
  --text-muted: #$(hex_color $((INV_R*65/100)) $((INV_G*65/100)) $((INV_B*65/100)));
  --header-primary: var(--text-normal);
  --header-secondary: var(--text-muted);
  --text-link: #$(hex_color $((R*85/100)) $((G*85/100)) $B);
  
  --channeltextarea-background: var(--background-secondary);
  --input-background: var(--background-secondary);
  
  --interactive-normal: #$(hex_color $((INV_R*80/100)) $((INV_G*80/100)) $((INV_B*80/100)));
  --interactive-hover: #$(hex_color $INV_R $INV_G $INV_B);
  --interactive-active: var(--text-normal);
  --interactive-muted: #$(hex_color $((INV_R*40/100)) $((INV_G*40/100)) $((INV_B*40/100)));
  
  --background-modifier-hover: $(rgba_color $R $G $B 0.05);
  --background-modifier-active: $(rgba_color $R $G $B 0.1);
  --background-modifier-selected: $(rgba_color $R $G $B 0.15);
  --background-modifier-accent: $(rgba_color $R $G $B 0.2);
  
  --scrollbar-thin-thumb: $(rgba_color $R $G $B 0.3);
  --scrollbar-auto-thumb: $(rgba_color $R $G $B 0.4);
  --scrollbar-auto-track: $(rgba_color $R $G $B 0.1);
}

.theme-dark, .theme-light {
  --header-primary: var(--text-normal);
  --header-secondary: var(--text-muted);
  --background-primary: var(--background-primary);
  --background-secondary: var(--background-secondary);
  --background-secondary-alt: var(--background-secondary-alt);
  --background-tertiary: var(--background-tertiary);
  --background-accent: var(--background-accent);
  --background-floating: var(--background-floating);
  --text-normal: var(--text-normal);
  --text-muted: var(--text-muted);
  --interactive-normal: var(--interactive-normal);
  --interactive-hover: var(--interactive-hover);
  --interactive-active: var(--interactive-active);
  --interactive-muted: var(--interactive-muted);
}

/* Agrega aquí más reglas CSS personalizadas según sea necesario */

EOF

echo "Colores de Discord actualizados"

# Genera la configuración de colores para ranger
cat <<EOF > ~/.config/ranger/colorscheme.py
from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class MyColorScheme(ColorScheme):
    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            fg = green if context.selected else red
            if context.empty or context.error:
                fg = red
            if context.border:
                fg = yellow
            if context.media:
                if context.image:
                    fg = yellow
                else:
                    fg = magenta
            if context.container:
                fg = red
            if context.directory:
                fg = blue
            elif context.executable and not any((context.media, context.container,
                                                 context.fifo, context.socket)):
                fg = green
            if context.socket:
                fg = magenta
            if context.fifo or context.device:
                fg = yellow
            if context.link:
                fg = cyan if context.good else magenta
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (red, magenta):
                    fg = white
                else:
                    fg = red
            if not context.selected and (context.cut or context.copied):
                fg = black
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = yellow
            if context.badinfo:
                if attr & reverse:
                    bg = magenta
                else:
                    fg = magenta

        return fg, bg, attr

# Define los colores basados en el fondo de pantalla
default_colors = (
    int('0x$(printf "%02x%02x%02x" $INV_R $INV_G $INV_B)', 16),  # fg
    int('0x$(printf "%02x%02x%02x" $R $G $B)', 16),  # bg
    0  # attr
)

# Define otros colores
red = int('0x$(printf "%02x%02x%02x" $((INV_R+50)) $((G-50)) $((B-50))', 16)
green = int('0x$(printf "%02x%02x%02x" $((R-50)) $((INV_G+50)) $((B-50))', 16)
blue = int('0x$(printf "%02x%02x%02x" $((R-50)) $((G-50)) $((INV_B+50))', 16)
yellow = int('0x$(printf "%02x%02x%02x" $((INV_R+50)) $((INV_G+50)) $((B-50))', 16)
magenta = int('0x$(printf "%02x%02x%02x" $((INV_R+50)) $((G-50)) $((INV_B+50))', 16)
cyan = int('0x$(printf "%02x%02x%02x" $((R-50)) $((INV_G+50)) $((INV_B+50))', 16)
EOF

echo "Archivo colorscheme.py actualizado para ranger"

# Actualiza los colores de Spicetify
cat <<EOF > ~/.config/spicetify/Themes/catppuccin/color.ini
[latte]
text               = ${INV_R},${INV_G},${INV_B}
subtext            = $((INV_R*80/100)),$((INV_G*80/100)),$((INV_B*80/100))
main               = ${R},${G},${B}
sidebar            = $((R*95/100)),$((G*95/100)),$((B*95/100))
player             = $((R*90/100)),$((G*90/100)),$((B*90/100))
card               = $((R*85/100)),$((G*85/100)),$((B*85/100))
shadow             = ${R},${G},${B}
selected-row       = $((INV_R*90/100)),$((INV_G*90/100)),$((INV_B*90/100))
button             = $((INV_R*70/100)),$((INV_G*70/100)),$((INV_B*70/100))
button-active      = ${INV_R},${INV_G},${INV_B}
button-disabled    = $((R*60/100)),$((G*60/100)),$((B*60/100))
tab-active         = $((R*85/100)),$((G*85/100)),$((B*85/100))
notification       = $((R*85/100)),$((G*85/100)),$((B*85/100))
notification-error = 255,0,0
misc               = $((R*75/100)),$((G*75/100)),$((B*75/100))
EOF

# Aplica los cambios en Spicetify
spicetify apply

# Actualiza los colores de dunst
update_dunst_colors() {
    local bg_color=$(printf "#%02x%02x%02x99" $R $G $B)
    local fg_color=$(printf "#%02x%02x%02x" $INV_R $INV_G $INV_B)
    local frame_color=$(printf "#%02x%02x%02x" $((R+INV_R)/2) $((G+INV_G)/2) $((B+INV_B)/2))

    sed -i "s/^background = .*/background = \"$bg_color\"/" ~/.config/dunst/dunstrc
    sed -i "s/^foreground = .*/foreground = \"$fg_color\"/" ~/.config/dunst/dunstrc
    sed -i "s/^frame_color = .*/frame_color = \"$frame_color\"/" ~/.config/dunst/dunstrc
}

# Llama a la función para actualizar los colores de dunst
update_dunst_colors


# Recarga la configuración de Kitty
killall -SIGUSR1 kitty

# Recarga waybar
killall -SIGUSR2 waybar && echo "Señal de recarga enviada a Waybar"

# Toca el archivo CSS para asegurar que Waybar detecte el cambio
touch ~/.config/waybar/style.css

dunstify "Colores actualizados" "Los colores de los programas han sido actualizados con éxito"
