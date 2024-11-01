#!/bin/bash

# Get the current wallpaper path
WALLPAPER_PATH=$(cat "$HOME/.current_wallpaper")

# Get the dominant color from the wallpaper
COLOR=$(~/.config/waybar/scripts/get_dominant_color.sh "$WALLPAPER_PATH")

# Extract RGB values
R=$(printf "%d" "0x${COLOR:0:2}")
G=$(printf "%d" "0x${COLOR:2:2}")
B=$(printf "%d" "0x${COLOR:4:2}")

# Calculate inverse colors
INV_R=$((255 - R))
INV_G=$((255 - G))
INV_B=$((255 - B))

# Function to generate hex color
hex_color() {
    printf "#%02x%02x%02x" $1 $2 $3
}

# Update Firefox userChrome.css
FIREFOX_PROFILE_DIR="$HOME/.mozilla/firefox/*.default-release"
FIREFOX_CHROME_DIR="$FIREFOX_PROFILE_DIR/chrome"
FIREFOX_USERCHROME="$FIREFOX_CHROME_DIR/userChrome.css"

mkdir -p "$FIREFOX_CHROME_DIR"

cat <<EOF > "$FIREFOX_CHROME_DIR/colors.css"
:root {
  --uc-base-colour: $(hex_color $R $G $B);
  --uc-highlight-colour: $(hex_color $((R*90/100)) $((G*90/100)) $((B*90/100)));
  --uc-inverted-colour: $(hex_color $INV_R $INV_G $INV_B);
  --uc-muted-colour: $(hex_color $((INV_R*70/100)) $((INV_G*70/100)) $((INV_B*70/100)));
  --uc-accent-colour: $(hex_color $((R+INV_R)/2) $((G+INV_G)/2) $((B+INV_B)/2));
}
EOF

# Update the main userChrome.css file
cat <<EOF > "$FIREFOX_USERCHROME"
@import 'colors.css';

/* Your existing Firefox CSS rules go here */
@import 'includes/cascade-config.css';
@import 'includes/cascade-layout.css';
@import 'includes/cascade-responsive.css';
@import 'includes/cascade-floating-panel.css';
@import 'includes/cascade-nav-bar.css';
@import 'includes/cascade-tabs.css';
@import 'integration/side-view/cascade-side-view.css';
@import 'integration/tabcenter-reborn/cascade-tcr.css';
@import 'integration/tabcenter-reborn/tabcenter-reborn.css';

/* Add any additional custom styles here */
EOF

# Restart Firefox to apply changes
pkill -f firefox && firefox &

echo "Firefox colors updated successfully"
