-- http://forum.farmanager.com/viewtopic.php?p=127121#p127121

-- This script scrolls the console (where program output goes)
-- when the user presses Enter while the panels are hidden and
-- the command line is empty.

-- Whether the command prompt should be displayed in the inserted lines
local leave_prompt = false

Macro {
  description="Line feed via Enter in Userscreen";
  area="Shell Tree Info QView";
  key="Enter";
  uid="3A6A0C4A-BBC8-4751-922D-09B59084DC5A";
  condition=function()
    return not APanel.Visible and CmdLine.Empty
  end;
  action=function()
    local toggleKeyBar = Far.GetConfig"Screen.KeyBar" and "CtrlB"
    Keys(toggleKeyBar)
    if not leave_prompt then panel.GetUserScreen() end
    io.write("\n")
    panel.SetUserScreen()
    Keys(toggleKeyBar)
  end;
}
