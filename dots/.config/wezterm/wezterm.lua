-- wezterm.lua
-- Pull in the wezterm API & hold wezterm config
local wezterm = require("wezterm")
local config = wezterm.config_builder()

local keybinds = require("keybinds")

-------------------- Theme Overrides --------------------------

local colors = {
	accent = "#C98690",
	bg = "#1E2030",
}

local theme = wezterm.color.get_builtin_schemes()["Catppuccin Macchiato"]

theme.tab_bar.active_tab.bg_color = colors.accent

theme.cursor_bg = colors.accent
theme.cursor_fg = colors.accent
theme.cursor_border = colors.accent

theme.selection_fg = colors.bg
theme.selection_bg = colors.accent

--
----------------------- CONFIGS --------------------------

local conf = {
	------------- window Appearance -----------------
	max_fps = 144,
	window_decorations = "TITLE | RESIZE",

	color_scheme = "Catppuccin Macchiato Mocha",

	window_close_confirmation = "AlwaysPrompt",
	skip_close_confirmation_for_processes_named = {
		"zsh",
		"sleep",
	},

	enable_scroll_bar = true,
	scrollback_lines = 10000,

	window_padding = {
		left = 5,
		right = 5,
		top = 5,
		bottom = 5,
	},

	color_schemes = { ["Catppuccin Macchiato Mocha"] = theme },

	------------- Font Settings --------------------
	font_size = 11,

	-- Regular Font
	font = wezterm.font("JetBrainsMono Nerd Font"),

	-- Specific variants for BOLD and ITALIC
	font_rules = {
		{
			intensity = "Bold",
			font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" }),
		},
		{
			intensity = "Half",
			font = wezterm.font("JetBrainsMono Nerd Font", { style = "Italic" }),
		},
		{
			intensity = "Bold",
			italic = true,
			font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold", style = "Italic" }),
		},
	},

	------------- Tab bar --------------------
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
