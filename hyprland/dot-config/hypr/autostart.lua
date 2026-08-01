-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
	hl.exec_cmd("waybar & hyprpaper")
	hl.exec_cmd("openrgb -p default")
	hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")

	-- Enable wallpaper switch script to run in service
	hl.exec_cmd(
		"dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE XDG_CURRENT_DESKTOP"
	)

	-- Switch wallpaper to day or night
	hl.exec_cmd("/home/brutus/.dotfiles/scripts/day_night.zsh")
end)
