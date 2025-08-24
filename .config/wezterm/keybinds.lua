-- keybinds.lua
local WA = require("wezterm").action

return {
	keys = {
		{
			-- Copy Mode
			action = WA.ActivateCopyMode,
			mods = "CTRL|SHIFT",
			key = "Space",
		},
		{
			-- Search Mode
			action = WA.Search({ CaseInSensitiveString = "" }),
			mods = "CTRL|SHIFT",
			key = "?",
		},
		{
			-- Split Left-Right
			action = WA.SplitHorizontal({ domain = "CurrentPaneDomain" }),
			mods = "CTRL|SHIFT",
			key = "|",
		},
		{
			-- Split Top-Bottom
			action = WA.SplitVertical({ domain = "CurrentPaneDomain" }),
			mods = "CTRL|SHIFT",
			key = "_",
		},
		{
			-- Focus Left Split
			action = WA.ActivatePaneDirection("Left"),
			mods = "CTRL|SHIFT",
			key = "h",
		},
		{
			-- Focus Right Split
			action = WA.ActivatePaneDirection("Right"),
			mods = "CTRL|SHIFT",
			key = "l",
		},
		{
			-- Focus Down Split
			action = WA.ActivatePaneDirection("Down"),
			mods = "CTRL|SHIFT",
			key = "j",
		},
		{
			-- Focus Up Split
			action = WA.ActivatePaneDirection("Up"),
			mods = "CTRL|SHIFT",
			key = "k",
		},
		{
			-- Increase Pane Size
			action = WA.AdjustPaneSize({ "Right", 5 }),
			mods = "CTRL|SHIFT|ALT",
			key = "h",
		},
		{
			-- Decrease Pane Size
			action = WA.AdjustPaneSize({ "Left", 5 }),
			mods = "CTRL|SHIFT|ALT",
			key = "l",
		},
		{
			-- Increase Pane Height
			action = WA.AdjustPaneSize({ "Down", 5 }),
			mods = "CTRL|SHIFT|ALT",
			key = "j",
		},
		{
			-- Decrease Pane Height
			action = WA.AdjustPaneSize({ "Up", 5 }),
			mods = "CTRL|SHIFT",
			key = "k",
		},
		{
			-- Full Screen Mode
			action = WA.ToggleFullScreen,
			mods = "",
			key = "F11",
		},
		{
			-- Launcher Menu
			action = WA.ShowLauncher,
			mods = "CTRL|SHIFT",
			key = "Enter",
		},
		--[[ 		{
			action = WA.SpawnCommandInNewTab {
				args = { "btm" }
			},
			mods = "CTRL|SHIFT",
			key = "n",
		}, ]]
	},
}
