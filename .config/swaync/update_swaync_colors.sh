#!/bin/bash

# Get the current wallpaper path
WALLPAPER_PATH=$(cat "$HOME/.current_wallpaper")

# Get the dominant color
COLOR=$(~/.config/waybar/scripts/get_dominant_color.sh "$WALLPAPER_PATH")

# Extract RGB values
R=$(printf "%d" "0x${COLOR:0:2}")
G=$(printf "%d" "0x${COLOR:2:2}")
B=$(printf "%d" "0x${COLOR:4:2}")

# Calculate inverse colors
INV_R=$((255 - R))
INV_G=$((255 - G))
INV_B=$((255 - B))

# Calculate brightness
BRIGHTNESS=$(( (R*299 + G*587 + B*114) / 1000 ))

# Adjust text color based on brightness
if [ $BRIGHTNESS -gt 128 ]; then
    TEXT_R=$((R*30/100))
    TEXT_G=$((G*30/100))
    TEXT_B=$((B*30/100))
else
    TEXT_R=$((R*170/100))
    TEXT_G=$((G*170/100))
    TEXT_B=$((B*170/100))
fi

# Clamp RGB values
clamp() {
    echo $(( $1 > 255 ? 255 : $1 < 0 ? 0 : $1 ))
}

TEXT_R=$(clamp $TEXT_R)
TEXT_G=$(clamp $TEXT_G)
TEXT_B=$(clamp $TEXT_B)

# Calculate accent color
ACCENT_R=$(( (R +   64) % 256 ))
ACCENT_G=$(( (G + 128) % 256 ))
ACCENT_B=$(( (B + 192) % 256 ))

# Update swaync style.css
sed -i '/^\/\* BEGIN DYNAMIC COLORS \*\//,/^\/\* END DYNAMIC COLORS \*\//c\
/* BEGIN DYNAMIC COLORS */\
@define-color cc-bg rgba('"$R"', '"$G"', '"$B"', 0.7);\
@define-color noti-border-color rgba('"$(( (R+INV_R)/2 ))"', '"$(( (G+INV_G)/2 ))"', '"$(( (B+INV_B)/2 ))"', 1);\
@define-color noti-bg rgba('"$R"', '"$G"', '"$B"', 0.3);\
@define-color noti-bg-hover rgba('"$(( (R+INV_R)/2 ))"', '"$(( (G+INV_G)/2 ))"', '"$(( (B+INV_B)/2 ))"', 0.4);\
@define-color noti-bg-darker rgba('"$((R*90/100))"', '"$((G*90/100))"', '"$((B*90/100))"', 0.5);\
@define-color noti-fg rgb('"$TEXT_R"', '"$TEXT_G"', '"$TEXT_B"');\
@define-color noti-bg-focus rgba('"$ACCENT_R"', '"$ACCENT_G"', '"$ACCENT_B"', 0.6);\
@define-color noti-close-bg rgba('"$R"', '"$G"', '"$B"', 0.5);\
@define-color noti-close-bg-hover rgba('"$(( (R+INV_R)/2 ))"', '"$(( (G+INV_G)/2 ))"', '"$(( (B+INV_B)/2 ))"', 0.6);\
@define-color text-color rgb('"$TEXT_R"', '"$TEXT_G"', '"$TEXT_B"');\
@define-color text-color-disabled rgba('"$TEXT_R"', '"$TEXT_G"', '"$TEXT_B"', 0.5);\
@define-color bg-selected rgb('"$ACCENT_R"', '"$ACCENT_G"', '"$ACCENT_B"');\
/* END DYNAMIC COLORS */' ~/.config/swaync/style.css

# Restart swaync to apply changes
killall swaync
swaync &
