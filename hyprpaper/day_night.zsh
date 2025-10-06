#!/usr/bin/env zsh

# Fail fast on errors / unset vars / pipeline failures
set -euo pipefail

# Wait for 5 seconds to start the script.
sleep 5

# Define daytime and nighttime images
typeset -r DAYTIME_WALLPAPER="$HOME/.dotfiles/backgrounds/dot-config/backgrounds/brutus.jpg"
typeset -r NIGHTTIME_WALLPAPER="$HOME/.dotfiles/backgrounds/dot-config/backgrounds/night.jpg"

# Current hour (00–23) as an integer
typeset -i PRESENT_TIME
PRESENT_TIME=$(date +%H)

# Choose wallpaper based on time of day
typeset WALLPAPER
if [[ PRESENT_TIME -ge 6 && PRESENT_TIME -lt 18 ]]; then
  WALLPAPER="$DAYTIME_WALLPAPER"
else
  WALLPAPER="$NIGHTTIME_WALLPAPER"
fi

# Preload and apply (Hyprland / hyprpaper)
hyprctl hyprpaper preload -- "$WALLPAPER"

# Give hyprpaper a moment to cache
sleep 5

# Apply the wallpaper to the current display (adjust output name if needed)
hyprctl hyprpaper wallpaper "HDMI-A-1,$WALLPAPER"

# Small buffer, then exit
sleep 1
exit 0

