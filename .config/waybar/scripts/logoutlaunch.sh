#!/bin/bash

# Verificar que hyprctl está disponible
if ! command -v hyprctl &> /dev/null
then
    echo "hyprctl no encontrado. Asegúrate de que Hyprland está instalado."
    exit 1
fi

# Definir las opciones de cierre de sesión
options="Poweroff\nReboot\nExit"

# Mostrar el menú usando rofi
selected_option=$(echo -e $options | rofi -dmenu -p "Seleccione una opción:" -theme Rofi)

# Ejecutar la acción seleccionada
case $selected_option in
    Poweroff)
        systemctl poweroff
        ;;
    Reboot)
        systemctl reboot
        ;;
    Exit)
        hyprctl dispatch exit
        ;;
    *)
        echo "Opción no válida."
        ;;
esac

