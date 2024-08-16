local wezterm = require("wezterm")

return {
	window_frame = {
		font = wezterm.font({ family = "Roboto", weight = "Bold" }),
		font_size = 12.0,
	},

	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	hide_tab_bar_if_only_one_tab = true,
}
