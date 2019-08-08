-- https://forum.farmanager.com/viewtopic.php?p=154561#p154561

Macro {
	area="Shell";
	key="CtrlBackSlash";
	description = "Shell: Cd \ and highlght the upper level dir of the previous location";
	flags="NoPluginPanels";
	action=function()
		local root, dir = APanel.Path0:match("(...)([^\\]*)")
		Panel.SetPath(0, root, dir)
	end;
}
