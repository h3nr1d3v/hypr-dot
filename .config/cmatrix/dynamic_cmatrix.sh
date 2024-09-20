#!/bin/bash

# Lee el color dominante del fondo de pantalla
WALLPAPER_PATH=$(cat "$HOME/.current_wallpaper")
COLOR=$(~/.config/waybar/scripts/get_dominant_color.sh "$WALLPAPER_PATH")

# Extrae los valores RGB
R=$(printf "%d" "0x${COLOR:0:2}")
G=$(printf "%d" "0x${COLOR:2:2}")
B=$(printf "%d" "0x${COLOR:4:2}")

# Función para determinar el color más cercano
closest_color() {
    local r=$1
    local g=$2
    local b=$3
    
    local colors=("green" "red" "blue" "white" "yellow" "cyan" "magenta")
    local min_distance=1000000
    local closest=""
    
    for color in "${colors[@]}"; do
        case $color in
            "green")   cr=0;   cg=255; cb=0 ;;
            "red")     cr=255; cg=0;   cb=0 ;;
            "blue")    cr=0;   cg=0;   cb=255 ;;
            "white")   cr=255; cg=255; cb=255 ;;
            "yellow")  cr=255; cg=255; cb=0 ;;
            "cyan")    cr=0;   cg=255; cb=255 ;;
            "magenta") cr=255; cg=0;   cb=255 ;;
        esac
        
        local distance=$(( (r-cr)*(r-cr) + (g-cg)*(g-cg) + (b-cb)*(b-cb) ))
        if (( distance < min_distance )); then
            min_distance=$distance
            closest=$color
        fi
    done
    
    echo $closest
}

# Calcula colores para cmatrix
COLOR1=$(closest_color $R $G $B)
COLOR2=$(closest_color $((255-R)) $((255-G)) $((255-B)))
COLOR3=$(closest_color $((R/2)) $((G/2)) $((B/2)))
COLOR4=$(closest_color $((R+128)) $((G+128)) $((B+128)))

# Asegúrate de que al menos dos colores sean diferentes
if [ "$COLOR1" = "$COLOR2" ] && [ "$COLOR1" = "$COLOR3" ] && [ "$COLOR1" = "$COLOR4" ]; then
    case $COLOR1 in
        "green")   COLOR2="red" ;;
        "red")     COLOR2="blue" ;;
        "blue")    COLOR2="green" ;;
        "white")   COLOR2="green" ;;
        "yellow")  COLOR2="blue" ;;
        "cyan")    COLOR2="red" ;;
        "magenta") COLOR2="green" ;;
    esac
fi

# Ejecuta cmatrix con los colores calculados
exec cmatrix -C "$COLOR1,$COLOR2,$COLOR3,$COLOR4" "$@"
