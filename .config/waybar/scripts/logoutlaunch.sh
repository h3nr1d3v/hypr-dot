#!/bin/bash

# Verificar que hyprctl está disponible
if ! command -v hyprctl &> /dev/null
then
    echo "hyprctl no encontrado. Asegúrate de que Hyprland está instalado."
    exit 1
fi

# Definir las opciones de cierre de sesión con iconos de Nerd Font
options=" スリープ\n 再起動\n ログアウト\n シャットダウン"

# Mostrar el menú usando rofi con tema personalizado
selected_option=$(echo -e "$options" | rofi -dmenu -p "選択してください:" -theme ~/.config/rofi/power_menu.rasi)

# Ejecutar la acción seleccionada
case "$selected_option" in
    " スリープ")
        systemctl suspend
        ;;
    " 再起動")
        systemctl reboot
        ;;
    " ログアウト")
        hyprctl dispatch exit
        ;;
    " シャットダウン")
        systemctl poweroff
        ;;
    *)
        echo "無効なオプション"
        ;;
esac
