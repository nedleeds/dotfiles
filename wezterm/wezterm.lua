local wezterm = require("wezterm")
local functions = require("functions")
local background_config = require("background")
local window_config = require("window")

-- 설정 병합
local config = functions.merge_tables({
	font = wezterm.font("JetBrainsMono Nerd Font"),
	font_size = 14.5,
	color_scheme = "Github Dark (Gogh)",
}, background_config, window_config)

return config
