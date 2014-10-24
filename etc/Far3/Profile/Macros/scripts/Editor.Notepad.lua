
-- Modification of the original script taken from:
-- https://code.google.com/p/farmanager/source/browse/trunk/addons/Macros/Edit.Notepad.lua

--[[
Macro {
	area = "Editor";
	key = "CtrlN";
	flags = "";
	description = "Editor: Open New File";
	action = function()
		Keys("ShiftF4 Del Enter")
	end
}

Macro {
	area = "Editor";
	key = "CtrlO";
	flags = "";
	description = "Editor: Open...";
	action = function()
		Keys("ShiftF4")
	end
}
]]

Macro {
	area = "Editor";
	key = "CtrlS";
	flags = "";
	description = "Editor: Save a File";
	action = function()
		Keys("F2")
	end
}

Macro {
	area = "Editor";
	key = "CtrlW";
	flags = "";
	description = "Editor: Save a File and Exit";
	action = function()
		Keys("ShiftF10")
	end
}

--[[
Macro {
	area = "Editor";
	key = "CtrlG";
	flags = "";
	description = "Editor: Go To...";
	action = function()
		Keys("AltF8")
	end
}
]]

--[[
Macro {
	area = "Editor";
	key = "CtrlF";
	flags = "";
	description = "Editor: Find...";
	action = function()
		Keys("F7")
	end
}

Macro {
	area = "Editor";
	key = "F3";
	flags = "";
	description = "Editor: Find Next";
	action = function()
		Keys("ShiftF7")
	end
}
]]

--[[
Macro {
	area = "Editor";
	key = "CtrlH";
	flags = "";
	description = "Editor: Replace...";
	action = function()
		Keys("CtrlF7")
	end
}
]]

