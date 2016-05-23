Macro {
	description = "";
	area = "Shell";
	key = "";
	flags = "RunAfterFARStart";
	action = function()
		-- http://forum.farmanager.com/viewtopic.php?p=138007#p138007
		panel.GetUserScreen()
		win.system("echo:Started Far3")
		win.system("echo:[ %DATE% %TIME% ]")
		panel.SetUserScreen()
	end;
}
