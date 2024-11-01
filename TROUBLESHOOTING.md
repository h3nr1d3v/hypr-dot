# Troubleshooting Guide

This document provides solutions to common issues you might encounter while using this Hyprland configuration.

## Table of Contents

- [Troubleshooting Guide](#troubleshooting-guide)
  - [Table of Contents](#table-of-contents)
  - [Hyprland Won't Start](#hyprland-wont-start)
  - [Screen Tearing](#screen-tearing)
  - [Audio Issues](#audio-issues)
  - [Bluetooth Problems](#bluetooth-problems)
  - [Wi-Fi Connectivity](#wi-fi-connectivity)
  - [Keybindings Not Working](#keybindings-not-working)
  - [Application-Specific Issues](#application-specific-issues)
    - [Firefox](#firefox)
    - [Discord](#discord)
  - [Performance Problems](#performance-problems)
  - [Waybar Issues](#waybar-issues)
  - [Theming and Appearance](#theming-and-appearance)

## Hyprland Won't Start

If Hyprland fails to start, try the following:

1. Check Hyprland logs:
   ```bash
   cat ~/.local/share/hyprland/hyprland.log
    ```

Look for any error messages that might indicate the problem.

1. Ensure all dependencies are installed:

```shellscript
yay -S hyprland waybar rofi dunst kitty python3 brightnessctl playerctl
```


3. Verify your configuration files:

```shellscript
hyprctl reload
```

If there are any syntax errors, they will be displayed.


4. Try starting Hyprland with a minimal configuration:

```shellscript
mv ~/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf.bak
echo "monitor=,preferred,auto,1" > ~/.config/hypr/hyprland.conf
```

If Hyprland starts, gradually add back your configuration, testing after each addition.




## Screen Tearing

If you experience screen tearing:

1. Enable VRR (Variable Refresh Rate) in your Hyprland configuration:

```shellscript
echo "general {
    vrr = 1
}" >> ~/.config/hypr/hyprland.conf
```


2. If using NVIDIA, ensure you have the proper drivers and configuration:

```shellscript
yay -S nvidia-dkms
```

Add the following to your Hyprland configuration:

```shellscript
echo "env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = WLR_NO_HARDWARE_CURSORS,1" >> ~/.config/hypr/hyprland.conf
```




## Audio Issues

If you're experiencing audio problems:

1. Ensure PulseAudio is running:

```shellscript
pulseaudio --check
```

If it's not running, start it with:

```shellscript
pulseaudio --start
```


2. Check if your audio device is recognized:

```shellscript
pactl list short sinks
```


3. If using Bluetooth audio, make sure the Bluetooth service is running:

```shellscript
sudo systemctl status bluetooth
```

If it's not running, start it with:

```shellscript
sudo systemctl start bluetooth
```


4. Try restarting PulseAudio:

```shellscript
pulseaudio -k && pulseaudio --start
```




## Bluetooth Problems

If you're having issues with Bluetooth:

1. Ensure the Bluetooth service is running:

```shellscript
sudo systemctl status bluetooth
```

If it's not running, start it with:

```shellscript
sudo systemctl start bluetooth
```


2. Check if your Bluetooth adapter is recognized:

```shellscript
bluetoothctl list
```


3. If the adapter is not found, try reloading the Bluetooth module:

```shellscript
sudo modprobe btusb
```


4. For persistent Bluetooth issues, try resetting the Bluetooth system:

```shellscript
sudo systemctl stop bluetooth
sudo rm /var/lib/bluetooth/*
sudo systemctl start bluetooth
```




## Wi-Fi Connectivity

If you're having Wi-Fi issues:

1. Check if your Wi-Fi adapter is recognized:

```shellscript
ip link
```


2. Ensure the necessary services are running:

```shellscript
sudo systemctl status iwd
sudo systemctl status dhcpcd
```

If they're not running, start them:

```shellscript
sudo systemctl start iwd
sudo systemctl start dhcpcd
```


3. Connect to a network using `iwctl`:

```shellscript
iwctl
[iwd]# device list
[iwd]# station <device> scan
[iwd]# station <device> get-networks
[iwd]# station <device> connect <SSID>
```


4. If you're still having issues, try restarting the network services:

```shellscript
sudo systemctl restart iwd
sudo systemctl restart dhcpcd
```




## Keybindings Not Working

If your keybindings aren't functioning as expected:

1. Check your keybindings configuration:

```shellscript
cat ~/.config/hypr/keybinds.conf
```


2. Ensure there are no conflicts between different keybindings.
3. Try reloading your Hyprland configuration:

```shellscript
hyprctl reload
```


4. If a specific keybinding isn't working, try binding it to a different key to isolate the issue.


## Application-Specific Issues

### Firefox

If Firefox is not rendering correctly:

1. Enable Wayland support in Firefox:

1. Open `about:config` in Firefox
2. Set `gfx.webrender.all` to `true`
3. Set `widget.use-xdg-desktop-portal` to `true`



2. Restart Firefox and check if the issue is resolved.


### Discord

If Discord is not functioning properly:

1. Try using the Wayland version of Discord:

```shellscript
yay -S discord_arch_electron
```


2. If screen sharing doesn't work, install `xdg-desktop-portal-hyprland`:

```shellscript
yay -S xdg-desktop-portal-hyprland
```




## Performance Problems

If you're experiencing performance issues:

1. Check your system resources:

```shellscript
htop
```


2. Disable animations if they're causing slowdowns:

```shellscript
echo "animations {
    enabled = false
}" >> ~/.config/hypr/animations.conf
```


3. Reduce blur and shadows:

```shellscript
echo "decoration {
    blur {
        enabled = false
    }
    drop_shadow = false
}" >> ~/.config/hypr/hyprland.conf
```


4. If using NVIDIA, ensure you're using the proper drivers and settings as mentioned in the Screen Tearing section.


## Waybar Issues

If Waybar isn't appearing or is malfunctioning:

1. Check Waybar's configuration:

```shellscript
cat ~/.config/waybar/config
```


2. Ensure Waybar is running:

```shellscript
pgrep waybar || waybar &
```


3. Check Waybar's logs for any error messages:

```shellscript
waybar -l debug
```


4. If Waybar is frozen, try restarting it:

```shellscript
killall waybar && waybar &
```




## Theming and Appearance

If you're having issues with themes or appearance:

1. Ensure all theme-related packages are installed:

```shellscript
yay -S nwg-look kvantum qt5ct
```


2. Check your GTK theme settings:

```shellscript
cat ~/.config/gtk-3.0/settings.ini
```


3. Verify Qt theme settings:

```shellscript
cat ~/.config/qt5ct/qt5ct.conf
```


4. If icons are missing, update your icon cache:

```shellscript
gtk-update-icon-cache
```


5. For font issues, ensure all necessary fonts are installed and update the font cache:

```shellscript
fc-cache -fv
```




If you continue to experience issues after trying these solutions, please open an issue on the GitHub repository with a detailed description of your problem and any relevant log outputs.
