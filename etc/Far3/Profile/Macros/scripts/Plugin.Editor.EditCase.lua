
-- http://forum.farmanager.com/viewtopic.php?p=125855#p125855

local shortcuts = {
	["CtrlAltL"] = "Lower",
	["CtrlAltT"] = "Title",
	["CtrlAltU"] = "Upper",
	["CtrlAltG"] = "Toggle",
	["CtrlAltC"] = "Cyclic",
}

local desc = "Editor: Change Case";

local guid = "0E92FC81-4888-4297-A85D-31C79E0E0CEE";

Macro {
	description = desc .. ": Menu";
	area = "Editor";
	key = "F4";
	action = function()
		Plugin.Call(guid);
	end
}

for key, cmd in pairs(shortcuts) do
	Macro {
		description = desc .. ": " .. cmd;
		area = "Editor";
		key = key;
		action = function()
			Plugin.Call(guid, cmd);
		end
	}
end

