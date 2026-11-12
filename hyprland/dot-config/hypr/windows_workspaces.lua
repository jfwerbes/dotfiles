-- ---- Windows and workspaces ----

-- Ignore maximize requests from all apps
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Blur behind rofi's translucent background
hl.layer_rule({
	name = "blur-rofi",
	match = { namespace = "^rofi$" },
	blur = true,
	ignore_alpha = 0,
})

-- Float hyprland-run in the bottom-left corner
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})
