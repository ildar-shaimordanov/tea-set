
-- http://forum.farmanager.com/viewtopic.php?f=60&t=8013

--[[ 
Macro { description="Shell: Don't steal important keys!";
  area="ShellAutoCompletion DialogAutoCompletion"; key="Up Down Home End Num7 Num1";
  action=function() Keys("Esc AKey") end;
}

Macro { description="Shell: Use Ctrl- to navigate in list";
  area="ShellAutoCompletion DialogAutoCompletion"; key="/^[LR]Ctrl(Up|Down|Home|Num7)$/";
  action=function() Keys(akey(1):match("Ctrl(.+)")) end;
}

Macro { description="Shell: CtrlEnd acts like in panels/dialog";
  area="ShellAutoCompletion DialogAutoCompletion"; key="/^[LR]Ctrl(End|Num1)$/";
  action=function() Keys("Down") end;
}

Macro { description="Shell: Esc to close list and discard all changes"; --you can use F10 or CtrlTab to close and keep text
  area="ShellAutoCompletion DialogAutoCompletion"; key="Esc";
  action=function()
    if Menu.Filter(2)~=0 then Menu.Filter(0,0) end --turn filter off
    Keys("Home Esc")
  end;
}
]]

