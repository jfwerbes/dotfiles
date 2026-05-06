#!/usr/bin/env zsh

# Fail fast on errors / unset vars / pipeline failures
set -euo pipefail

sleep 0.5  # give Hyprland IPC time to be ready when triggered at login

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
typeset CURRENT_THEME=$(flavours current)
typeset -i NEEDS_THEME_CHANGE=0
if [[ "$CURRENT_THEME" != "$TARGET_THEME" ]]; then
  NEEDS_THEME_CHANGE=1
fi

# Preload and apply (Hyprland / hyprpaper)
# hyprctl hyprpaper preload -- "$WALLPAPER"

# Apply theme only if necessary
if (( NEEDS_THEME_CHANGE )); then
  flavours apply "$TARGET_THEME"
fi

# Apply the wallpaper to the first active monitor
MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
hyprctl hyprpaper wallpaper "$MONITOR,$WALLPAPER"

exit 0
