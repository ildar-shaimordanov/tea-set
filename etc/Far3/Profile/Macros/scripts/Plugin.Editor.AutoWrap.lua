
local guid = 'DEEC52C3-AC76-4AD3-A6EF-CAFC33BD4C05';

Macro {
	area = "Editor";
	key = "AltBackSlash";
	flags = "";
	description = "Editor: Toggle AutoWrap";
	action = function()
		Plugin.Call(guid);
		-- Keys("F11 BackSlash");
	end
}

