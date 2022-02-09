
--local guid = 'D2F36B62-A470-418D-83A3-ED7A3710E5B5';
--local guid_main_menu = "45453CAC-499D-4B37-82B8-0A77F7BD087C";
local ColorerGUID = "D2F36B62-A470-418D-83A3-ED7A3710E5B5";

Macro {
	area = "Editor";
	key = "AltL";
	flags = "";
	description = "Editor: List of types";
	condition = function()
		return Plugin.Exist(ColorerGUID)
	end;
	action = function()
		Plugin.Call(ColorerGUID, "Types", "Menu")
--		Plugin.Call(guid, 1);
--		-- universal workaround for Far3 > 4242 and between 4499 and 4545
--		-- Issue somewhere in FarColorer 1.2.1.8, 1.2.2 or 1.2.4
--		if Menu.Id == guid_main_menu then Keys("Enter"); end;
--		-- Keys("F11 c 1");
	end
}

Macro {
	area = "Editor";
	key = "Alt[";
	flags = "";
	description = "Editor: Find pair brackets";
	condition = function()
		return Plugin.Exist(ColorerGUID)
	end;
	action = function()
		Plugin.Call(ColorerGUID, "Brackets", "Match")
--		Plugin.Call(guid, 2);
--		-- Keys("F11 c 2")
	end
}

Macro {
	area = "Editor";
	key = "Alt]";
	flags = "";
	description = "Editor: Select a block with brackets";
	condition = function()
		return Plugin.Exist(ColorerGUID)
	end;
	action = function()
		Plugin.Call(ColorerGUID, "Brackets", "SelectAll")
--		Plugin.Call(guid, 3);
--		-- Keys("F11 c 3")
	end
}

Macro {
	area = "Editor";
	key = "AltP";
	flags = "";
	description = "Editor: Select a block within brackets";
	condition = function()
		return Plugin.Exist(ColorerGUID)
	end;
	action = function()
		Plugin.Call(ColorerGUID, "Brackets", "SelectIn")
--		Plugin.Call(guid, 4);
--		-- Keys("F11 c 4")
	end
}

Macro {
	area = "Editor";
	key = "Alt;";
	flags = "";
	description = "Editor: List of functions";
	condition = function()
		return Plugin.Exist(ColorerGUID)
	end;
	action = function()
		Plugin.Call(ColorerGUID, "Functions", "Show")
--		Plugin.Call(guid, 5);
--		-- Keys("F11 c 5")
	end
}

Macro {
	area = "Editor";
	key = "Alt'";
	flags = "";
	description = "Editor: List of errors";
	condition = function()
		return Plugin.Exist(ColorerGUID)
	end;
	action = function()
		Plugin.Call(ColorerGUID, "Errors", "Show")
--		Plugin.Call(guid, 6);
--		-- Keys("F11 c 6")
	end
}

