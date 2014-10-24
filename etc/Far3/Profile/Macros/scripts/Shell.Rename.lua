
local NoFolders = true;

Macro {
	area = "Shell";
--	key = "ShiftF6";
	key = "/ShiftF[56]/";
	flags = "";
	description = "Shell: Highlight the filename of the file to be renamed";
	action = function()
		if APanel.Current == ".." then
			return;
		end;

		Keys("AKey Home ShiftEnd");

		if APanel.Folder and NoFolders then
			return;
		end;

		local text = Dlg.GetValue();
		if regex.match(text, ".+\\..+") then
			Keys("CtrlShiftLeft ShiftLeft");
		end;
	end;
}

