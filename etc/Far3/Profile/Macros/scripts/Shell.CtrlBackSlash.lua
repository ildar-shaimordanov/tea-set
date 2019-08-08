-- https://forum.farmanager.com/viewtopic.php?p=154568#p154568

Macro {
	area = "Shell";
	key = "CtrlBackSlash";
	description = "Shell: Cd \\ and highlght the upper level dir of the previous location";
	action = function()
		local path = APanel.Path~="" and APanel.Path or APanel.Current:find("\\") and APanel.Current
		if path then
			local root, dir = path:match("([^\\]*\\)([^\\]*)")
			Panel.SetPath(0, root, dir)
		else
			Keys("CtrlBackSlash") -- default Far action
		end
	end;
}
