#!/usr/bin/env zsh

# Fail fast on errors / unset vars / pipeline failures
set -euo pipefail

sleep 2

# Define daytime and nighttime images/themes
typeset -r DAYTIME_WALLPAPER="$HOME/.config/backgrounds/Japan_Wall.JPG"
typeset -r DAYTIME_THEME="generated"

typeset -r NIGHTTIME_WALLPAPER="$HOME/.config/backgrounds/night.jpg"
typeset -r NIGHTTIME_THEME="darktooth"

# Current hour (00–23) as an integer
typeset -i PRESENT_TIME=$(date +%H)

# Determine target assets once
if (( PRESENT_TIME >= 6 && PRESENT_TIME < 17 )); then
  TARGET_THEME="$DAYTIME_THEME"
  WALLPAPER="$DAYTIME_WALLPAPER"
else
  TARGET_THEME="$NIGHTTIME_THEME"
  WALLPAPER="$NIGHTTIME_WALLPAPER"
fi

# Determine whether the theme actually needs to change
typeset CURRENT_THEME=$(flavours current | head -n1 | tr -d '\n')
typeset -i NEEDS_THEME_CHANGE=0
if [[ "$CURRENT_THEME" != "$TARGET_THEME" ]]; then
  NEEDS_THEME_CHANGE=1
fi

# Preload and apply (Hyprland / hyprpaper)
hyprctl hyprpaper preload -- "$WALLPAPER"

# Sleep to allow hyprpaper to cache
sleep 5

# Apply theme only if necessary
if (( NEEDS_THEME_CHANGE )); then
  flavours apply "$TARGET_THEME"

  #No longer need to restart waybar, reloads style change dynamically
#  # Restart Waybar
#  if pgrep -x waybar >/dev/null; then
#    killall waybar
#    # Ensure Waybar has fully exited before relaunching
#    while pgrep -x waybar >/dev/null; do
#      sleep 0.1
#    done
#  fi
# 
#  waybar &

  # Apply the wallpaper to the current display (adjust output name if needed)
  hyprctl hyprpaper wallpaper "HDMI-A-1,$WALLPAPER"

fi


exit 0
