#!/usr/bin/env zsh

# Fail fast on errors / unset vars / pipeline failures
set -euo pipefail

sleep 2

# Define daytime and nighttime images
typeset -r DAYTIME_WALLPAPER="$HOME/.dotfiles/backgrounds/dot-config/backgrounds/Japan_Wall.JPG"
typeset -r NIGHTTIME_WALLPAPER="$HOME/.dotfiles/backgrounds/dot-config/backgrounds/night.jpg"

# Current hour (00–23) as an integer
typeset -i PRESENT_TIME
PRESENT_TIME=$(date +%H)

# Choose wallpaper based on time of day
typeset WALLPAPER
if [[ PRESENT_TIME -ge 6 && PRESENT_TIME -lt 17 ]]; then
  flavours apply gruvbox-dark-pale
  WALLPAPER="$DAYTIME_WALLPAPER"
else
  flavours apply darktooth
  WALLPAPER="$NIGHTTIME_WALLPAPER"
fi

# Preload and apply (Hyprland / hyprpaper)
hyprctl hyprpaper preload -- "$WALLPAPER"

# Sleep to allow hyprpaper to cache
sleep 5

# Load the wallpapers, then re-run flavours because running it above
# will conflict with Hyprland instantiating Waybar
if [[ PRESENT_TIME -ge 6 && PRESENT_TIME -lt 17 ]]; then
  flavours apply generated
else
  flavours apply darktooth
fi

# Restart Waybar
if pgrep -x waybar >/dev/null; then
  killall waybar
  # Ensure Waybar has fully exited before relaunching
  while pgrep -x waybar >/dev/null; do
    sleep 0.1
  done
fi

waybar &

# Apply the wallpaper to the current display (adjust output name if needed)
hyprctl hyprpaper wallpaper "HDMI-A-1,$WALLPAPER"

exit 0

