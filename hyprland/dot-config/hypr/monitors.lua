------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

-- Custom waybar rules to prevent flickering
--layerrule = blur on, match:class waybar
--layerrule = ignore_alpha 0, match:class waybar
--
--layerrule = blur on, match:class dunst
--layerrule = ignore_alpha 0, match:class dunst
--
--layerrule = blur off, match:class hyprshot
