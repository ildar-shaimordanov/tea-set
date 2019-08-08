-- https://forum.farmanager.com/viewtopic.php?p=154581#p154581

Macro {
	area = "Shell";
	key = "CtrlBackSlash";
	description = "Shell: Cd \\ and highlght the upper level dir of the previous location";
	action = function()
		local path = APanel.Path
		local root, dir
		if APanel.Plugin then -- plugin panel
			path = APanel.Current:find("\\") and APanel.Current or path
			root, dir = path:match("([^\\]*\\)([^\\]*)")
		elseif APanel.Path:find("^\\\\") then -- network share
			root, dir = path:match("^(\\\\[^\\]*\\%w%$\\)([^\\]*)")
		else -- local directory
			root, dir = path:match("([^\\]*\\)([^\\]*)")
		end
		if root then
			Panel.SetPath(0, root, dir)
		else
			Keys("CtrlBackSlash") -- default Far action
		end
	end;
}
