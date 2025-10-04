-- select_subtitle.lua
-- This script uses `yad` to select an external subtitle file in MPV.

local mp = require("mp")
local utils = require("mp.utils")

local function select_subtitle_file()
	local yad_command = [[
        yad --file --title="Select Subtitle File" --class="dialog" --file-filter="Subtitle files | *.srt *.ass *.sub *.txt" --file-filter="All files | *"
    ]]

	local result = utils.subprocess({ args = { "bash", "-c", yad_command }, cancellable = false })
	if result.status == 0 and result.stdout then
		-- Trim the newline character from yad's output
		local subtitle_file = result.stdout:match("^(.-)%s*$")
		if subtitle_file then
			mp.osd_message("Loading subtitle: " .. subtitle_file)
			mp.commandv("sub-add", subtitle_file)
		else
			mp.osd_message("No subtitle file selected")
		end
	else
		mp.osd_message("Subtitle selection cancelled")
	end
end

mp.register_script_message("select-subtitle", select_subtitle_file)
