#!/bin/bash

# Obtén el color dominante del fondo de pantalla
WALLPAPER_PATH=$(cat "$HOME/.current_wallpaper")
COLOR=$(~/.config/waybar/scripts/get_dominant_color.sh "$WALLPAPER_PATH")

# Extrae los valores RGB del color hexadecimal
R=$(printf "%d" "0x${COLOR:0:2}")
G=$(printf "%d" "0x${COLOR:2:2}")
B=$(printf "%d" "0x${COLOR:4:2}")

# Calcula colores complementarios
INV_R=$((255 - R))
INV_G=$((255 - G))
INV_B=$((255 - B))

# Función para generar color en formato cmus (nombre de color o valor hexadecimal)
cmus_color() {
    printf "'#%02x%02x%02x'" $1 $2 $3
}

# Genera la configuración de colores para cmus
cat <<EOF > ~/.config/cmus/rc.colors
set color_cmdline_bg=$(cmus_color $((R*20/100)) $((G*20/100)) $((B*20/100)))
set color_cmdline_fg=$(cmus_color $INV_R $INV_G $INV_B)
set color_error='red'
set color_info=$(cmus_color $((R*80/100)) $((G*80/100)) $((B*80/100)))
set color_separator=$(cmus_color $((R*40/100)) $((G*40/100)) $((B*40/100)))
set color_statusline_bg=$(cmus_color $((R*30/100)) $((G*30/100)) $((B*30/100)))
set color_statusline_fg=$(cmus_color $INV_R $INV_G $INV_B)
set color_titleline_bg=$(cmus_color $R $G $B)
set color_titleline_fg=$(cmus_color $INV_R $INV_G $INV_B)
set color_win_bg=$(cmus_color $((R*15/100)) $((G*15/100)) $((B*15/100)))
set color_win_cur=$(cmus_color $R $G $B)
set color_win_cur_sel_bg=$(cmus_color $((R*60/100)) $((G*60/100)) $((B*60/100)))
set color_win_cur_sel_fg=$(cmus_color $INV_R $INV_G $INV_B)
set color_win_dir=$(cmus_color $((R*70/100)) $((G*70/100)) $((B*70/100)))
set color_win_fg=$(cmus_color $((INV_R*90/100)) $((INV_G*90/100)) $((INV_B*90/100)))
set color_win_inactive_cur_sel_bg=$(cmus_color $((R*40/100)) $((G*40/100)) $((B*40/100)))
set color_win_inactive_cur_sel_fg=$(cmus_color $INV_R $INV_G $INV_B)
set color_win_inactive_sel_bg=$(cmus_color $((R*30/100)) $((G*30/100)) $((B*30/100)))
set color_win_inactive_sel_fg=$(cmus_color $INV_R $INV_G $INV_B)
set color_win_sel_bg=$(cmus_color $((R*50/100)) $((G*50/100)) $((B*50/100)))
set color_win_sel_fg=$(cmus_color $INV_R $INV_G $INV_B)
set color_win_title_bg=$(cmus_color $((R*25/100)) $((G*25/100)) $((B*25/100)))
set color_win_title_fg=$(cmus_color $INV_R $INV_G $INV_B)
EOF

# Si cmus está en ejecución, recarga la configuración
if pgrep cmus > /dev/null; then
    cmus-remote -C "source ~/.config/cmus/rc.colors"
fi

echo "Colores de cmus actualizados"
