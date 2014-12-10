--http://forum.farmanager.com/viewtopic.php?f=15&t=9197

--http://bugs.farmanager.com/view.php?id=2877
--http://bugs.farmanager.com/view.php?id=2878
--http://bugs.farmanager.com/view.php?id=2879
--http://bugs.farmanager.com/view.php?id=2881

local F = far.Flags
local RAlt,LAlt,RCtrl,LCtrl,Shift = 0x1,0x2,0x4,0x8,0x10

local function Pos2pos(hDlg, ID, Pos)
  local ii = 0
  for i,item in ipairs(far.GetDlgItem(hDlg, ID)[6]) do --[6]  Selected/ListItems: integer/table
     if band(item.Flags,F.LIF_HIDDEN)==0 then
       ii = ii+1; if ii==Pos then return i end
     end
  end
end

Event { group="DialogEvent"; description="Concurrent hotkeys menu filter";
  uid="33E83694-4F10-44A0-8CAD-C7DE90F5621C";
  condition=function(Event,param)
    return param.Msg==F.DN_LISTHOTKEY and Event==F.DE_DLGPROCINIT
    and band(Mouse.LastCtrlState,bor(RAlt,LAlt))==0
  end;
  action=function(Event,param)
    local hDlg,ID,ItemIndex = param.hDlg,param.Param1,param.Param2
    if hDlg:send(F.DM_LISTINFO,ID).ItemsNumber~=Object.ItemCount then return end --macro api item indexes does not count hidden items
    local hk = Object.GetHotkey() --ItemIndex
    if Object.CheckHotkey(hk,ItemIndex+1)~=0 then
      hDlg:send(F.DM_SHOWDIALOG,0)
      local list = far.GetDlgItem(hDlg, ID)[6] --[6]  Selected/ListItems: integer/table 
      for i=#list,1,-1 do
        if Object.GetHotkey(i)~=hk then
          local item = list[i]
          hDlg:send(F.DM_LISTUPDATE, ID,{Index=i,Text=item.Text,Flags=bor(item.Flags,F.LIF_HIDDEN)})
        end
      end
      hDlg:send(F.DM_SHOWDIALOG,1)
      Menu.Filter(4) --подправить высоту списка под количество элементов
      return 0
    end
  end;
}

local InitPos
Event { group="DialogEvent"; description="Ctrl-<hotkey> to run hotkey";
  uid="5EB2CC1A-D563-4362-ACC2-20BE350EDDA4";
  condition=function(Event,param)
    return param.Msg==F.DN_CONTROLINPUT and Event==F.DE_DLGPROCINIT
       and far.GetDlgItem(param.hDlg, param.Param1)[1]==F.DI_LISTBOX
  end;
  action=function(Event,param)
    local hDlg,ID,Input = param.hDlg,param.Param1,param.Param2
    InitPos = hDlg:send(F.DM_LISTINFO,ID).SelectPos --helper for some other handler
    ---
    if Input.EventType==F.KEY_EVENT and Input.UnicodeChar~="" and band(Input.ControlKeyState,bor(RCtrl,LCtrl))~=0 then
      if Object.CheckHotkey(Input.UnicodeChar)~=0 then
        local hk,char = Object.GetHotkey():lower(),Input.UnicodeChar:lower()
        if hk~=char and hk~=far.XLat(char) then
          local Pos = Object.CheckHotkey(char)
          if Pos==0 then return end
          hDlg:send(F.DM_LISTSETCURPOS,ID,{SelectPos=Pos2pos(hDlg,ID,Pos)})
        end
        return param.hDlg:send"DM_CLOSE"
      end
    end
  end;
}

Event { group="DialogEvent"; description="Goto next menu item with specified hotkey";
  uid="D91B58E5-4C32-4384-B205-D7895A4EC037";
  condition=function(Event,param)
    return param.Msg==F.DN_LISTHOTKEY and Event==F.DE_DLGPROCINIT
  end;
  action=function(Event,param)
    local hDlg,ID,ItemIndex = param.hDlg,param.Param1,param.Param2
    local hk = Object.GetHotkey()
    if Object.CheckHotkey(hk,ItemIndex+1)==0 and band(Mouse.LastCtrlState,bor(RAlt,LAlt))==0 then return end
    local Pos = Object.CheckHotkey(hk,InitPos+1)
    if Pos==0 then Pos = Object.CheckHotkey(hk) end
    mf.postmacro(far.SendDlgMessage,hDlg,F.DM_LISTSETCURPOS,ID,{SelectPos=Pos2pos(hDlg, ID, Pos)})
    return 0
  end;
}

local hDlg,ID
Macro { description="Reset filters";
  area="Dialog Menu MainMenu UserMenu Disks"; key="Esc F10";
  uid="3DE219F0-7B83-453B-A1FA-E780640F7093";
  condition=function()
    hDlg = far.AdvControl"ACTL_GETWINDOWINFO".Id
    ID = Area.Dialog and Dlg.CurPos or 1
    if Area.Dialog and Dlg.ItemType~=F.DI_LISTBOX then return end
    return hDlg:send(F.DM_LISTINFO,ID).ItemsNumber~=Object.ItemCount
  end;
  action=function()
    if Menu.Filter(0)==1 then Menu.Filter(0,0); return end
    hDlg:send(F.DM_ENABLEREDRAW,0)
    for i,item in ipairs(far.GetDlgItem(hDlg,ID)[6]) do--[6]  Selected/ListItems: integer/table 
      if band(item.Flags,F.LIF_HIDDEN)~=0 then
        hDlg:send(F.DM_LISTUPDATE,ID,{Index=i,Text=item.Text,Flags=band(item.Flags,bnot(F.LIF_HIDDEN))})
      end
    end
    Menu.Filter(4) --подправить высоту списка под количество элементов
    hDlg:send(F.DM_ENABLEREDRAW,1)
  end;
}