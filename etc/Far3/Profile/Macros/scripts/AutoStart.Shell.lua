Macro {
	description = "";
	area = "Shell";
	key = "";
	flags = "RunAfterFARStart";
	action = function()
		-- The idea with turn off/on key bar was borrowed from
		-- http://forum.farmanager.com/viewtopic.php?p=127121#p127121
		local toggleKeyBar = Far.GetConfig"Screen.KeyBar" and "CtrlB"
		Keys(toggleKeyBar)

		panel.GetUserScreen()

		-- save the current locale
		local l = os.setlocale()

		os.setlocale("", "time")
		io.write(string.format("[ %s ]\n\n", os.date()))

		-- restore previous locale
		os.setlocale(l)

		panel.SetUserScreen()

		Keys(toggleKeyBar)
		-- Keys("e c h o : & e c h o : [ Space % D A T E % Space % T I M E % Space ] & e c h o : Enter");
	end;
}
