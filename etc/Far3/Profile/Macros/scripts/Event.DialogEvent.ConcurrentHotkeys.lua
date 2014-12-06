
-- http://forum.farmanager.com/viewtopic.php?f=15&t=9197

local F = far.Flags
Event { group="DialogEvent"; description="Concurrent hotkeys menu handler";
  condition=function(Event,param)
    return param.Msg==F.DN_LISTHOTKEY and Event==F.DE_DLGPROCINIT
    and band(Mouse.LastCtrlState,0x1+0x2)==0
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
      Menu.Filter(4) --подправить высоту списка под количество элементов
      hDlg:send(F.DM_SHOWDIALOG,1)
      return 1
    end
  end;
}

local InitPos
Event { group="DialogEvent";
  condition=function(Event,param)
    return param.Msg==F.DN_CONTROLINPUT and Event==F.DE_DLGPROCINIT
  end;
  action=function(Event,param)
    InitPos = Object.CurPos
  end;
}
Event { group="DialogEvent";
  condition=function(Event,param)
    return param.Msg==F.DN_LISTHOTKEY and Event==F.DE_DLGPROCINIT
  end;
  action=function(Event,param)
    local hDlg,ID,ItemIndex = param.hDlg,param.Param1,param.Param2
    local x = {}
    local y = {}
    local ii = 0
    for i,item in ipairs(far.GetDlgItem(hDlg, ID)[6]) do --[6]  Selected/ListItems: integer/table
       if band(item.Flags,F.LIF_HIDDEN)==0 then
         ii = ii+1; x[i],y[ii] = ii,i
       end
    end
    local hk = Object.GetHotkey(x[ItemIndex])
--    if Object.CheckHotkey(hk,x[ItemIndex]+1)==0 then return end
    local Pos = Object.CheckHotkey(hk,InitPos+1)
    if Pos~=0 then
      hDlg:send(F.DM_LISTSETCURPOS,ID,{SelectPos=y[Pos]})
    end
    return true
  end;
}