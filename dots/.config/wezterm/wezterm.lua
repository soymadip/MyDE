-- Pull in the wezterm API & hold wezterm config
local wezterm = require("wezterm")
local config = wezterm.config_builder()

local keybinds = require("keybinds")

--
----------------------- CONFIGS --------------------------

local conf = {
	------------- window Apperance -----------------
	max_fps = 144,
	window_decorations = "TITLE | RESIZE",
	color_scheme = "Catppuccin Macchiato (Gogh)",

	window_close_confirmation = "AlwaysPrompt",
	skip_close_confirmation_for_processes_named = {
		"zsh",
		"sleep",
	},

	enable_scroll_bar = false, -- doesn't have option to show only if needed.
	scrollback_lines = 10000,

	window_padding = {
		left = 5,
		right = 5,
		top = 5,
		bottom = 5,
	},
	window_background_opacity = 0.80,

	---------------- font settings ---------------
	font = wezterm.font("JetBrainsMono Nerd Font"),
	font_size = 11,

	-------------  Tab bar --------------------
	enable_tab_bar = true,
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = true,
}

--[[

--------------------- END ------------------------------------






------ return the whole config ---------]]

for _, tbl in ipairs({ conf, keybinds }) do
	for key, value in pairs(tbl) do
		config[key] = value
	end
end

return config
