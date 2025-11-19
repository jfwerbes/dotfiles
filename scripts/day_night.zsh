#!/usr/bin/env zsh

# Fail fast on errors / unset vars / pipeline failures
set -euo pipefail

sleep 2

# Define daytime and nighttime images
typeset -r DAYTIME_WALLPAPER="$HOME/.dotfiles/backgrounds/dot-config/backgrounds/Japan_Wall.JPG"
typeset -r NIGHTTIME_WALLPAPER="$HOME/.dotfiles/backgrounds/dot-config/backgrounds/night.jpg"

# Theme schemes
typeset -r DAYTIME_SCHEME="generated"
typeset -r NIGHTTIME_SCHEME="darktooth"

# Current hour (00–23) as an integer
typeset -i PRESENT_TIME=$(date +%H)

# Determine target assets once
if (( PRESENT_TIME >= 6 && PRESENT_TIME < 17 )); then
  TARGET_SCHEME="$DAYTIME_SCHEME"
  WALLPAPER="$DAYTIME_WALLPAPER"
else
  TARGET_SCHEME="$NIGHTTIME_SCHEME"
  WALLPAPER="$NIGHTTIME_WALLPAPER"
fi

# Determine whether the theme actually needs to change
typeset CURRENT_SCHEME=$(flavours current | head -n1 | tr -d '\n')
typeset -i NEEDS_SCHEME_CHANGE=0
if [[ "$CURRENT_SCHEME" != "$TARGET_SCHEME" ]]; then
  NEEDS_SCHEME_CHANGE=1
fi

# Preload and apply (Hyprland / hyprpaper)
hyprctl hyprpaper preload -- "$WALLPAPER"

# Sleep to allow hyprpaper to cache
sleep 5

# Apply theme only if necessary
if (( NEEDS_SCHEME_CHANGE )); then
  flavours apply "$TARGET_SCHEME"

  # Restart Waybar
  if pgrep -x waybar >/dev/null; then
    killall waybar
    # Ensure Waybar has fully exited before relaunching
    while pgrep -x waybar >/dev/null; do
      sleep 0.1
    done
  fi
 
  waybar &
fi

# Apply the wallpaper to the current display (adjust output name if needed)
hyprctl hyprpaper wallpaper "HDMI-A-1,$WALLPAPER"

exit 0
