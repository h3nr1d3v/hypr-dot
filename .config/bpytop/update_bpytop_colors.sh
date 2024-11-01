#!/bin/bash
# Save as ~/.config/bpytop/update_bpytop_colors.sh

# Get the dominant color from the wallpaper
WALLPAPER_PATH=$(cat "$HOME/.current_wallpaper")
COLOR=$(~/.config/waybar/scripts/get_dominant_color.sh "$WALLPAPER_PATH")

# Extract RGB values
R=$(printf "%d" "0x${COLOR:0:2}")
G=$(printf "%d" "0x${COLOR:2:2}")
B=$(printf "%d" "0x${COLOR:4:2}")

# Calculate complementary colors
INV_R=$((255 - R))
INV_G=$((255 - G))
INV_B=$((255 - B))

# Function to generate color
gen_color() {
    local r=$((($1 > 255 ? 255 : ($1 < 0 ? 0 : $1))))
    local g=$((($2 > 255 ? 255 : ($2 < 0 ? 0 : $2))))
    local b=$((($3 > 255 ? 255 : ($3 < 0 ? 0 : $3))))
    printf "#%02x%02x%02x" $r $g $b
}

# Generate the custom theme
cat << EOF > ~/.config/bpytop/themes/custom.theme
# Custom colors based on wallpaper
theme[main_bg]="#${COLOR}"
theme[main_fg]="$(gen_color $INV_R $INV_G $INV_B)"
theme[title]="$(gen_color $((INV_R+50)) $((INV_G+50)) $((INV_B+50)))"
theme[hi_fg]="$(gen_color $((R+50)) $((G+50)) $((B+50)))"
theme[selected_bg]="$(gen_color $((INV_R+30)) $((INV_G+30)) $((INV_B+30)))"
theme[selected_fg]="#${COLOR}"
theme[inactive_fg]="$(gen_color $((INV_R-50)) $((INV_G-50)) $((INV_B-50)))"
theme[graph_text]="$(gen_color $((INV_R+100)) $((INV_G+100)) $((INV_B+100)))"
theme[meter_bg]="$(gen_color $((R-30)) $((G-30)) $((B-30)))"
theme[proc_misc]="$(gen_color $((INV_R-30)) $((INV_G-30)) $((INV_B-30)))"
theme[cpu_box]="$(gen_color $((R+20)) $((G+20)) $((B+20)))"
theme[mem_box]="$(gen_color $((R+40)) $((G+40)) $((B+40)))"
theme[net_box]="$(gen_color $((R+60)) $((G+60)) $((B+60)))"
theme[proc_box]="$(gen_color $((R+80)) $((G+80)) $((B+80)))"
theme[div_line]="$(gen_color $((INV_R+10)) $((INV_G+10)) $((INV_B+10)))"
theme[temp_start]="$(gen_color $((R+100)) $G $B)"
theme[temp_mid]="$(gen_color $R $((G+100)) $B)"
theme[temp_end]="$(gen_color $R $G $((B+100)))"
theme[cpu_start]="$(gen_color $((INV_R+50)) $INV_G $INV_B)"
theme[cpu_mid]="$(gen_color $INV_R $((INV_G+50)) $INV_B)"
theme[cpu_end]="$(gen_color $INV_R $INV_G $((INV_B+50)))"
theme[free_start]="$(gen_color $((R+50)) $G $B)"
theme[free_mid]="$(gen_color $R $((G+50)) $B)"
theme[free_end]="$(gen_color $R $G $((B+50)))"
theme[cached_start]="$(gen_color $((INV_R+30)) $INV_G $INV_B)"
theme[cached_mid]="$(gen_color $INV_R $((INV_G+30)) $INV_B)"
theme[cached_end]="$(gen_color $INV_R $INV_G $((INV_B+30)))"
theme[available_start]="$(gen_color $((R+70)) $G $B)"
theme[available_mid]="$(gen_color $R $((G+70)) $B)"
theme[available_end]="$(gen_color $R $G $((B+70)))"
theme[used_start]="$(gen_color $((INV_R+70)) $INV_G $INV_B)"
theme[used_mid]="$(gen_color $INV_R $((INV_G+70)) $INV_B)"
theme[used_end]="$(gen_color $INV_R $INV_G $((INV_B+70)))"
theme[download_start]="$(gen_color $((R+90)) $G $B)"
theme[download_mid]="$(gen_color $R $((G+90)) $B)"
theme[download_end]="$(gen_color $R $G $((B+90)))"
theme[upload_start]="$(gen_color $((INV_R+90)) $INV_G $INV_B)"
theme[upload_mid]="$(gen_color $INV_R $((INV_G+90)) $INV_B)"
theme[upload_end]="$(gen_color $INV_R $INV_G $((INV_B+90)))"
EOF

# Update bpytop configuration to use the custom theme
sed -i 's/^color_theme=.*/color_theme="+custom"/' ~/.config/bpytop/bpytop.conf

# Restart bpytop if it's running
if pgrep bpytop > /dev/null; then
    pkill -USR2 bpytop
fi
