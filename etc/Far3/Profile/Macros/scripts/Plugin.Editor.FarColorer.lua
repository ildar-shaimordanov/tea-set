
local guid = 'D2F36B62-A470-418D-83A3-ED7A3710E5B5';

Macro {
	area = "Editor";
	key = "AltL";
	flags = "";
	description = "Editor: List of types";
	action = function()
		Plugin.Call(guid, 1);
		-- Keys("F11 c 1")
	end
}

Macro {
	area = "Editor";
	key = "Alt[";
	flags = "";
	description = "Editor: Find pair brackets";
	action = function()
		Plugin.Call(guid, 2);
		-- Keys("F11 c 2")
	end
}

Macro {
	area = "Editor";
	key = "Alt]";
	flags = "";
	description = "Editor: Select a block with brackets";
	action = function()
		Plugin.Call(guid, 3);
		-- Keys("F11 c 3")
	end
}

Macro {
	area = "Editor";
	key = "AltP";
	flags = "";
	description = "Editor: Select a block within brackets";
	action = function()
		Plugin.Call(guid, 4);
		-- Keys("F11 c 4")
	end
}

Macro {
	area = "Editor";
	key = "Alt;";
	flags = "";
	description = "Editor: List of functions";
	action = function()
		Plugin.Call(guid, 5);
		-- Keys("F11 c 5")
	end
}

Macro {
	area = "Editor";
	key = "Alt'";
	flags = "";
	description = "Editor: List of errors";
	action = function()
		Plugin.Call(guid, 6);
		-- Keys("F11 c 6")
	end
}

