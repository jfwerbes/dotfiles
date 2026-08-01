-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function ()
  hl.exec_cmd("waybar & hyprpaper")
  hl.exec_cmd("openrgb -p default")
  hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")

-- Enable wallpaper switch script to run in service
  hl.ehxec_cmd("dbus-update-activation-environment")

-- Switch wallpaper to day or night
  hl.exec_cmd("/home/brutus/.dotfiles/scripts/day_night.zsh
")
end)


