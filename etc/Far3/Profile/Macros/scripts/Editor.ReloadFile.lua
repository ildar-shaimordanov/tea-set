--[[

Editor: Reload a file
http://forum.farmanager.com/viewtopic.php?f=57&t=10599

This macro allows to reload a file from the disk.
Any changes made in the editor may be lost.

]]

---------------------------------------------------------------------------

local EDITOR_MODIFIED = 0x00000008

local MSG_WARNING  = 0x00000001
local MSG_OKCANCEL = 0x00020000
local MSG_YESNO    = 0x00040000

---------------------------------------------------------------------------

local msg_title = "Warning"
local msg_text = "FIle modified, everything will be lost"

---------------------------------------------------------------------------

Macro {
	area = "Editor";
	key = "CtrlF4";
	flags = "";
	description = "Editor: Reload a file";
	action = function()
		local state = bit.band(Editor.State, EDITOR_MODIFIED)
		if state ~= 0 then
			local answer = msgbox(msg_title, msg_text, MSG_WARNING + MSG_OKCANCEL)
			if answer ~= 1 then return end
		end

		local history = Far.DisableHistory()
		Far.DisableHistory(-1)

		-- Avoid saving the file
		Keys("F6 " .. ( state ~= 0 and "Right Enter" or "" ) .. " F6")

		Far.DisableHistory(history)
	end;
}

---------------------------------------------------------------------------

-- EOF
