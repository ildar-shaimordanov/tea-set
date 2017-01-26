Macro {
	description = "Display date/time of Far invocation";
	area = "Shell";
	key = "";
	flags = "RunAfterFARStart";
	action = function()
		-- http://forum.farmanager.com/viewtopic.php?p=138007#p138007
		-- Скрыть "вводимую" команду при старте FAR
		-- Hide an "entered" command at starting of FAR
		panel.GetUserScreen()
		win.system("echo:Started Far3")
		win.system("echo:[ %DATE% %TIME% ]")
		panel.SetUserScreen()
	end;
}
