-- catppuccin macchiato palate
macchiato = {
	rosewater = "#f5e0dc",
	flamingo = "#f2cdcd",
	pink = "#f5c2e7",
	mauve = "#cba6f7",
	red = "#f38ba8",
	maroon = "#eba0ac",
	peach = "#fab387",
	yellow = "#f9e2af",
	green = "#a6e3a1",
	teal = "#94e2d5",
	sky = "#89dceb",
	sapphire = "#74c7ec",
	blue = "#89b4fa",
	lavender = "#b4befe",
	text = "#cdd6f4",
	subtext1 = "#bac2de",
	subtext0 = "#a6adc8",
	overlay2 = "#9399b2",
	overlay1 = "#7f849c",
	overlay0 = "#6c7086",
	surface2 = "#585b70",
	surface1 = "#45475a",
	surface0 = "#313244",
	base = "#1e1e2e",
	mantle = "#181825",
	crust = "#11111b",
}

-- Full Border
require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})

-- Show simlinks in status Bar
function Status:name()
	local h = self._tab.current.hovered
	if not h then
		return ui.Line({})
	end

	local linked = ""
	if h.link_to ~= nil then
		linked = " -> " .. tostring(h.link_to)
	end
	return ui.Line(" " .. h.name .. linked)
end

--[[ -- Show username and hostname in header
Header:children_add(function()
	if ya.target_family() ~= "unix" then
		return ui.Line({})
	end
	return ui.Span("PWD:"):fg("red")
e nd, 500, Header.LEFT) ]]

--

-- yatline
require("yatline"):setup({
	-- theme
	section_separator = {
		open = "",
		close = "",
	},
	part_separator = {
		open = "",
		close = "",
	},
	inverse_separator = {
		open = "",
		close = "",
	},

	style_a = {
		fg = macchiato.mantle,
		bg_mode = {
			normal = macchiato.maroon,
			select = macchiato.mauve,
			un_set = macchiato.red,
		},
	},
	style_b = { bg = macchiato.surface0, fg = macchiato.text },
	style_c = { bg = macchiato.mantle, fg = macchiato.text },

	permissions_t_fg = macchiato.green,
	permissions_r_fg = macchiato.yellow,
	permissions_w_fg = macchiato.red,
	permissions_x_fg = macchiato.sky,
	permissions_s_fg = macchiato.lavender,

	selected = { icon = "󰻭", fg = macchiato.yellow },
	copied = { icon = "", fg = macchiato.green },
	cut = { icon = "", fg = macchiato.red },

	total = { icon = "", fg = macchiato.yellow },
	succ = { icon = "", fg = macchiato.green },
	fail = { icon = "", fg = macchiato.red },
	found = { icon = "", fg = macchiato.blue },
	processed = { icon = "", fg = macchiato.green },

	-- yatline-githead
	prefix_color = macchiato.subtext0,
	branch_color = macchiato.sapphire,
	commit_color = macchiato.mauve,
	behind_color = macchiato.flamingo,
	ahead_color = macchiato.lavender,
	stashes_color = macchiato.pink,
	state_color = macchiato.maroon,
	staged_color = macchiato.yellow,
	unstaged_color = macchiato.peach,
	untracked_color = macchiato.teal,

	-- Configuration
	--- component_positions = { "status", "header", "tab" },
	tab_use_inverse = false,
	tab_width = 12,

	show_background = false,

	display_header_line = true,
	display_status_line = true,

	-- Header and Status Line config
	header_line = {
		left = {
			section_a = {
				{ type = "string", custom = false, name = "tab_path" },
			},
			section_b = {},
			section_c = {},
		},
		right = {
			section_a = {
				{ type = "line", custom = false, name = "tabs", params = { "right" } },
				-- { type = "string", custom = false, name = "date", params = { "%A, %d %B %Y" } },
			},
			section_c = {
				-- { type = "string", custom = false, name = "date", params = { "%X" } },
			},
			section_b = {},
		},
	},

	status_line = {
		left = {
			section_a = {
				{ type = "string", custom = false, name = "tab_mode" },
			},
			section_b = {},
			section_c = {
				{ type = "coloreds", custom = false, name = "count" },
				{ type = "string", custom = false, name = "hovered_size" },
			},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "cursor_position" },
			},
			section_b = {
				-- { type = "string", custom = false, name = "cursor_percentage" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_file_extension", params = { true } },
				{ type = "coloreds", custom = false, name = "permissions" },
			},
		},
	},
})
