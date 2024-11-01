#!/bin/bash

# Obtén el color dominante del fondo de pantalla actual
WALLPAPER_PATH=$(cat "$HOME/.current_wallpaper")
DOMINANT_COLOR=$(~/.config/waybar/scripts/get_dominant_color.sh "$WALLPAPER_PATH")

# Convierte el color hexadecimal a valores RGB
R=$(printf "%d" "0x${DOMINANT_COLOR:0:2}")
G=$(printf "%d" "0x${DOMINANT_COLOR:2:2}")
B=$(printf "%d" "0x${DOMINANT_COLOR:4:2}")

# Calcula el color complementario
INV_R=$((255 - R))
INV_G=$((255 - G))
INV_B=$((255 - B))

# Genera la configuración de neofetch
cat <<EOF > ~/.config/neofetch/config.conf
#!/usr/bin/env bash

print_info() {
    local col1="\e[38;2;${R};${G};${B}m"
    local col2="\e[38;2;${INV_R};${INV_G};${INV_B}m"
    local reset="\e[0m"

    info "${col1}󰣇 ${reset}" title
    prin "${col2}󰮯 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 󰮯${reset}"
    info "${col1}󰻀 ${reset}" distro
    info "${col2}󰌪 ${reset}" kernel
    info "${col1}󰏖 ${reset}" packages
    info "${col2}󰞷 ${reset}" shell
    info "${col1}󰆍 ${reset}" term
    info "${col2}󱬄 ${reset}" wm
    info "${col1}󰍹 ${reset}" resolution
    info "${col2}󱑆 ${reset}" uptime
    info "${col1}󰘚 ${reset}" cpu
    info "${col2}󰍛 ${reset}" memory
    info "${col1}󰝚 ${reset}" song
    prin "${col2}󰮯 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 󰮯${reset}"
    prin "\n"
    prin "${col1} 󰊠 𝙳𝚎𝚋𝚞𝚐𝚐𝚒𝚗𝚐 𝚕𝚒𝚏𝚎, 𝚘𝚗𝚎 𝚕𝚒𝚗𝚎 𝚘𝚏 𝚌𝚘𝚍𝚎 𝚊𝚝 𝚊 𝚝𝚒𝚖𝚎. 󰊠 ${reset}"
    prin "${col2} 󰩠 Anime-inspired system information 󰩠${reset}"
}

# Configuración general
kernel_shorthand="on"
distro_shorthand="off"
os_arch="off"
uptime_shorthand="on"
memory_percent="on"
package_managers="on"
shell_path="off"
shell_version="on"
cpu_brand="on"
cpu_speed="on"
cpu_cores="logical"
cpu_temp="C"
gpu_brand="on"
gpu_type="all"
refresh_rate="on"
gtk_shorthand="on"
gtk2="on"
gtk3="on"
public_ip_host="http://ident.me"
public_ip_timeout=2
disk_show=('/')
disk_subtitle="mount"
music_player="auto"
song_format="%artist% - %title%"
song_shorthand="off"

# Colores y estilo
colors=(5 4 8 6 8 6)
bold="on"
underline_enabled="on"
underline_char="󰇘"
separator=" "

# Imagen
image_backend="kitty"
image_source="$(~/.config/neofetch/convert_to_png.sh $(cat $HOME/.current_wallpaper))"
image_size="250px"
image_loop="off"
crop_mode="fit"
crop_offset="center"
gap=2

EOF

echo "Configuración de neofetch actualizada con los nuevos colores."
