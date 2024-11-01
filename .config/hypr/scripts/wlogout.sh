#!/usr/bin/env bash

# Rutas a los archivos de sonido
LOCK_SOUND="/home/h3nr1d3v/Music/sounds/lock.wav"
UNLOCK_SOUND="/home/h3nr1d3v/Music/sounds/unlock.wav"
WRONG_SOUND="/home/h3nr1d3v/Music/sounds/wrong.wav"

# Función para reproducir sonido
play_sound() {
    paplay "$1" &
}

# Función para mostrar el uso del script
show_usage() {
    echo "Uso: $0 [OPCIÓN]"
    echo "Opciones:"
    echo "  -l, --lock      Bloquear la pantalla"
    echo "  -e, --logout    Cerrar sesión"
    echo "  -s, --suspend   Suspender el sistema"
    echo "  -h, --hibernate Hibernar el sistema"
    echo "  -r, --reboot    Reiniciar el sistema"
    echo "  -p, --poweroff  Apagar el sistema"
    echo "  Sin opciones    Mostrar el menú de wlogout"
}

# Función para ejecutar wlogout
run_wlogout() {
    # set file variables
    wLayout="$HOME/.config/wlogout/layout"
    wlTmplt="$HOME/.config/wlogout/style.css"
    wlStyle="$HOME/.config/wlogout/dynamic_style.css"

    if [ ! -f $wLayout ] || [ ! -f $wlTmplt ] ; then
        echo "ERROR: Config files not found..."
        exit 1
    fi

    # Get the current wallpaper path
    WALLPAPER_PATH=$(cat "$HOME/.current_wallpaper")

    # Get the dominant color
    DOMINANT_COLOR=$(~/.config/waybar/scripts/get_dominant_color.sh "$WALLPAPER_PATH")

    # Extract RGB values
    R=$(printf "%d" "0x${DOMINANT_COLOR:0:2}")
    G=$(printf "%d" "0x${DOMINANT_COLOR:2:2}")
    B=$(printf "%d" "0x${DOMINANT_COLOR:4:2}")

    # Calculate inverse colors
    INV_R=$((255 - R))
    INV_G=$((255 - G))
    INV_B=$((255 - B))

    # Get monitor information
    res_inf=$(hyprctl monitors | awk -v RS="" -v ORS="\n\n" '/focused: yes/'| awk -F "@" '/@/ && / at /{print $1} ')
    scl_inf=$(hyprctl monitors | awk -v RS="" -v ORS="\n\n" '/focused: yes/'| awk -F ": " '/scale/ {print $2} ')
    x_mon=$(echo $res_inf | cut -d 'x' -f 1)
    y_mon=$(echo $res_inf | cut -d 'x' -f 2)
    x_mon=$(printf "%.0f" $(echo "$x_mon / $scl_inf" | awk '{print $1}'))
    y_mon=$(printf "%.0f" $(echo "$y_mon / $scl_inf" | awk '{print $1}'))

    # scale config layout and style
    wlColms=3
    x_mgn=$(( x_mon * 30 / 100 ))
    y_mgn=$(( y_mon * 20 / 100 ))
    x_hvr=$(( x_mon * 27 / 100 ))
    y_hvr=$(( y_mon * 17 / 100 ))

    # scale font size
    fntSize=$(( y_mon * 2 / 100 ))

    # eval hypr border radius
    active_rad=15
    button_rad=15

    # Generate dynamic CSS
    cat <<EOF > "$wlStyle"
    @define-color bg_color rgba(${R}, ${G}, ${B}, 0.7);
    @define-color fg_color rgb(${INV_R}, ${INV_G}, ${INV_B});
    @define-color hover_bg_color rgba(${R}, ${G}, ${B}, 0.9);
    @define-color hover_fg_color rgb(${INV_R}, ${INV_G}, ${INV_B});

    window {
        background-image: url("${WALLPAPER_PATH}");
        background-size: cover;
        background-position: center;
        background-repeat: no-repeat;
    }

    button {
        background-color: @bg_color;
        color: @fg_color;
        border: 2px solid @fg_color;
        background-size: 25%;
        background-position: center;
        background-repeat: no-repeat;
        margin: ${y_mgn}px ${x_mgn}px;
        border-radius: ${button_rad}px;
        font-size: ${fntSize}px;
    }

    button:hover {
        background-color: @hover_bg_color;
        color: @hover_fg_color;
        margin: ${y_hvr}px ${x_hvr}px;
    }
EOF

    # Combine template and dynamic styles
    cat "$wlTmplt" "$wlStyle" > "${wlStyle}.tmp"
    mv "${wlStyle}.tmp" "$wlStyle"

    # launch wlogout
    wlogout -b $wlColms -c 0 -r 0 -m 0 --layout $wLayout --css "$wlStyle"

    # Clean up
    rm -f "${wlStyle}.tmp"
}

# Función para ejecutar acciones específicas
execute_action() {
    case $1 in
        lock)
            ~/.config/hypr/scripts/swaylock-wrapper.sh
            ;;
        logout)
            loginctl terminate-user $USER
            ;;
        suspend)
            systemctl suspend
            ;;
        hibernate)
            systemctl hibernate
            ;;
        reboot)
            systemctl reboot
            ;;
        poweroff)
            systemctl poweroff
            ;;
        *)
            echo "Acción no reconocida: $1"
            exit 1
            ;;
    esac
}

# Procesar argumentos de línea de comandos
if [ $# -eq 0 ]; then
    # Si no hay argumentos, ejecutar wlogout
    run_wlogout
else
    # Procesar argumentos
    case $1 in
        -l|--lock)
            execute_action lock
            ;;
        -e|--logout)
            execute_action logout
            ;;
        -s|--suspend)
            execute_action suspend
            ;;
        -h|--hibernate)
            execute_action hibernate
            ;;
        -r|--reboot)
            execute_action reboot
            ;;
        -p|--poweroff)
            execute_action poweroff
            ;;
        *)
            show_usage
            exit 1
            ;;
    esac
fi
