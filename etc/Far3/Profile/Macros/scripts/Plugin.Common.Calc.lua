
local guid = '894EAABB-C57F-4549-95FC-4AC6F3102A36';

Macro {
	area = "Shell Viewer Editor";
	key = "Alt=";
	flags = "";
	description = "Common: Calulator";
	action = function()
		Plugin.Call(guid, 1);
		-- Keys("F11 = Enter");
	end
}
