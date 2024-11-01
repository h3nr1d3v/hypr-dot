# Scripts Documentation

This document provides an overview of the custom scripts used in the Hyprland configuration. These scripts are located in two main directories: `.config/hypr/scripts/` and `.config/waybar/scripts/`.

## Hyprland Scripts (.config/hypr/scripts/)

### batterynotify.sh
- **Purpose**: Monitors battery level and sends notifications.
- **Functionality**:
  - Checks if the system is a laptop.
  - Sends a notification when battery is low (≤20%) or fully charged (≥80%).
  - Runs in a loop, checking battery status every 5 minutes.

### brightnesscontrol.sh
- **Purpose**: Controls screen brightness.
- **Functionality**:
  - Increases or decreases screen brightness.
  - Displays a notification with the current brightness level.
  - Supports both light and dark themes.

### clipboard-history.sh
- **Purpose**: Manages clipboard history.
- **Functionality**:
  - Monitors clipboard changes using `clipnotify`.
  - Adds new clipboard content to a history file.
  - Limits history to the last 100 items.

### clipboard-manager.sh
- **Purpose**: Advanced clipboard management.
- **Functionality**:
  - Adds items to clipboard store.
  - Displays clipboard history using rofi.
  - Allows copying and deleting items from history.

### dontkillsteam.sh
- **Purpose**: Prevents accidental closing of Steam.
- **Functionality**:
  - Checks if the active window is Steam.
  - If Steam, it hides the window instead of closing it.
  - Otherwise, it closes the active window.

### resetxdgportal.sh
- **Purpose**: Resets XDG desktop portal.
- **Functionality**:
  - Kills all XDG desktop portal processes.
  - Restarts the Hyprland XDG desktop portal.

### Rofi-launcher.sh
- **Purpose**: Launches Rofi application launcher.
- **Functionality**:
  - Executes Rofi with a custom theme.

### screenshot.sh
- **Purpose**: Takes screenshots.
- **Functionality**:
  - Supports full-screen and area selection screenshots.
  - Saves screenshots to a specified directory.
  - Sends a notification when a screenshot is taken.

### songdetail.sh
- **Purpose**: Retrieves current song information.
- **Functionality**:
  - Uses `playerctl` to get current song title and artist.

### swaylock-wrapper.sh
- **Purpose**: Wrapper for Swaylock screen locker.
- **Functionality**:
  - Plays a lock sound.
  - Executes Swaylock with a custom image.

### volumecontrol.sh
- **Purpose**: Controls system volume.
- **Functionality**:
  - Increases or decreases volume.
  - Toggles mute.
  - Displays notifications with volume level.

### vscode.sh
- **Purpose**: Dynamically updates VS Code colors based on wallpaper.
- **Functionality**:
  - Extracts dominant color from wallpaper.
  - Generates a custom CSS file for VS Code.
  - Updates VS Code's color scheme.

### wlogout.sh
- **Purpose**: Manages system logout and power options.
- **Functionality**:
  - Provides options for logout, reboot, shutdown, etc.
  - Uses custom theming based on wallpaper colors.


## Waybar Scripts (.config/waybar/scripts/)

### brightnesscontrol.sh
- **Purpose**: Controls screen brightness (similar to Hyprland version).
- **Functionality**:
  - Increases or decreases screen brightness.
  - Displays notifications.

### get_dominant_color.sh
- **Purpose**: Extracts dominant color from wallpaper.
- **Functionality**:
  - Uses ImageMagick to analyze wallpaper.
  - Returns the dominant color in hex format.

### logoutlaunch.sh
- **Purpose**: Launches logout menu.
- **Functionality**:
  - Displays a Rofi menu with logout options.
  - Executes selected action (sleep, reboot, logout, shutdown).

### mediaplayer.py
- **Purpose**: Displays media player information.
- **Functionality**:
  - Retrieves current song information.
  - Supports multiple media players.

### notifications.py
- **Purpose**: Manages system notifications.
- **Functionality**:
  - Retrieves notification history.
  - Formats notifications for display in Waybar.

### reload.sh
- **Purpose**: Reloads Waybar and related components.
- **Functionality**:
  - Restarts Waybar.
  - Reloads Hyprland configuration.
  - Restarts Hyprpaper.

### swwwallpaper.sh
- **Purpose**: Manages wallpaper switching.
- **Functionality**:
  - Switches to next or previous wallpaper.
  - Updates color schemes based on new wallpaper.
  - Reloads configurations for various applications.

### update_firefox_colors.sh
- **Purpose**: Updates Firefox theme colors.
- **Functionality**:
  - Generates CSS based on wallpaper colors.
  - Updates Firefox's userChrome.css.

### update_waybar_colors.sh
- **Purpose**: Updates Waybar and system color schemes.
- **Functionality**:
  - Extracts colors from wallpaper.
  - Updates configurations for multiple applications (Waybar, Rofi, Alacritty, etc.).
  - Reloads affected applications.

### volumecontrol.sh
- **Purpose**: Controls system volume (similar to Hyprland version).
- **Functionality**:
  - Adjusts volume and toggles mute.
  - Displays notifications.

### wbarconfgen.sh
- **Purpose**: Manages Waybar configurations.
- **Functionality**:
  - Switches between different Waybar layouts.
  - Updates current Waybar configuration.

These scripts form an integral part of the Hyprland configuration, providing various utilities and enhancements to the user experience. They handle everything from system controls to theming and application management.