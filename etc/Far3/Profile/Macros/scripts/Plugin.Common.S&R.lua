
--[[
Macro {
	area = "Shell Viewer Editor";
	key = "CtrlF";
	flags = "";
	description = "Common: CTRL+F to Find by S & R";
	action = function()
		if Area.Shell  then Keys('F11 & 2') end
		if Area.Viewer then Keys('F11 & 1') end
		if Area.Editor then Keys('F11 & 1') end
	end
}

Macro {
	area = "Shell Editor";
	key = "CtrlH";
	flags = "";
	description = "Common: CTRL+H to Replace by S & R";
	action = function()
		if Area.Shell  then Keys('F11 & 3') end
		if Area.Editor then Keys("F11 & 2") end
	end
}

Macro {
	area = "Viewer Editor";
	key = "F3";
	flags = "";
	description = "Common: F3 to continue Find/Replace by S & R";
	action = function()
		if Area.Viewer then Keys('F11 & 2') end
		if Area.Editor then Keys('F11 & 3') end
	end
}
]]
