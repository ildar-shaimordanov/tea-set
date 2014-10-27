--http://forum.farmanager.com/viewtopic.php?f=15&t=8802
--v2
local useEdtFind = true --false
local options = "WholeWords:0 RegExp:0 CaseSensitive:0 HighLight:1"
local ExtraQuick --= true
local useBM = false

local F = far.Flags
local SearchMode, str
local last, appendable = ""
local OriginalPos,OriginalSel

local srhInit,srhFin,srhStart,srhFwd,srhBwd
local function SetSelection(sel)
  editor.Select(nil,sel and {
    BlockType=F.BTYPE_STREAM,
    BlockStartPos=sel.StartPos,
    BlockWidth=sel.EndPos-sel.StartPos+1,
    BlockStartLine=sel.StartLine,
    BlockHeight=sel.EndLine-sel.StartLine+1,
  })
end

local function MessagePopup(msg,title,flags,delay)
  local s = far.SaveScreen()
  far.Message(msg,title or "","",flags)
  win.Sleep(delay or 500); far.RestoreScreen(s)
  far.Text()
end

local function EdtFind(arg)
  return Plugin.SyncCall("E4ABD267-C2F9-4158-818F-B0E040A2AB9F",arg)
end

local function search(f,str,options,dir)
  local pos = editor.GetString().SelStart
  editor.SetPosition(nil,0,pos)
  if str=="" then
    editor.SetPosition(nil,0,pos)
    editor.Select(nil, F.BTYPE_NONE)
    EdtFind"Highlight:0"
    far.Text()
    return
  end
  local sel = editor.GetSelection()
  Keys(dir)
  local found = f(str,options)
  if not found then
    mf.beep()
    win.Sleep(200)
    editor.SetPosition(nil,0,pos)
    SetSelection(sel) --restore selection
  elseif false then
    -------------------------------
    local si = editor.GetString()
    local word = si.StringText:match("%w+",si.SelEnd)
    local ei = editor.GetInfo()
    local LeftPos = si.SelEnd+word:len()-ei.WindowSizeX
    if LeftPos>ei.LeftPos then
      ei.LeftPos = LeftPos
      editor.SetPosition(nil,ei)
    end
  end
  editor.Redraw()
  far.Text()
  appendable = found
end

if useEdtFind and EdtFind() then
  srhInit = function() EdtFind"Highlight:0" end
  srhFin = function() end
  srhStart = function(str,extra)
    return EdtFind((extra or '')..options..' Error:0 Loop:0 Find:"'..str..'"')
  end
  srhFwd = function(str) return srhStart(str) end
  srhBwd = function(str) return srhStart(str,"Reverse:1 ") end
  srhToggleOption = function(opt)
    options = options:gsub(("(%s:)(%%d)"):format(opt),function(opt,value)
      local new = opt..(1-value)
      MessagePopup(new,"IncSearch.lua",nil,300)
      return new
    end,1)
    search(srhStart,str)
  end
else -------------------------
  local SearchSelFound,getValue = 17,-1
  local SelFoundInitState
  srhInit = function()
    SelFoundInitState = Editor.Set(SearchSelFound,getValue) --save init state of [x] Select found
    Editor.Set(SearchSelFound,1)
  end
  srhFin = function()
    Editor.Set(SearchSelFound,SelFoundInitState) --restore init state of [x] Select found
    if SelFoundInitState==0 then editor.Select(nil,{BlockStartPos=0}) end
  end
  srhStart = function(str,options)
    Far.DisableHistory(-1)
    Keys"F7 CtrlY"; print(str); if options then options() end; Keys"Enter"
    if not Area.Editor then far.Text(); Keys"Esc" else return true end
  end
  local function searchNext(key)
    Keys(key)
    if not Area.Editor then far.Text(); Keys"Esc" else return true end
  end
  srhFwd = function() return searchNext"ShiftF7" end
  srhBwd = function() return searchNext"AltF7" end
  local optpos = {
    ["CaseSensitive"] = 5;
    ["WholeWords"] = 6;
    ["RegExp"] = 7;
  }
  srhToggleOption = function(opt)
    if not optpos[opt] then return end
    local value
    search(srhStart,str,function()
      Dlg.SetFocus(optpos[opt])
      Keys"Space"
      value = Dlg.GetValue()
    end)
    MessagePopup(opt..":"..value,"IncSearch.lua",nil,300)
  end
end

local xform = {
  Tab     ="	";
  Space   =" ";
  Divide  ="/";
  Multiply="*";
  Subtract="-";
  Add     ="+";
  Decimal =".";
  --
  RCtrl   ="Shift";      --skip
  --      ="BS";         --backspace/restore
  --      ="CtrlBS";     --clear/restore
  CtrlV   ="ShiftIns";   --insert
  --      ="Esc";        --quit and restore pos
  RAlt    ="Alt";        --quit
--  CtrlI   ="Alt";        --quit
  F3      ="ShiftF7";    --next
  Enter   ="ShiftF7";
  ShiftF3 ="AltF7";      --prev
  ShiftEnter ="AltF7";
}

local function setStatus(str)
  editor.SetTitle(nil,str and " ↓"..str:gsub(" ","∙") or nil)
end
 
local function enterSearchMode()
  srhInit()
  if useBM then BM.Add() end
  OriginalPos,OriginalSel = editor.GetInfo(),editor.GetSelection()
  str = ""; SearchMode = true; appendable = true
  local s1 = editor.GetString(nil,0,0)
  if s1.SelStart>0 then
    local sel = OriginalSel
    if sel.StartLine==sel.EndLine then
      str = s1.StringText:sub(s1.SelStart,s1.SelEnd)
      editor.SetPosition (nil,0,s1.SelStart)
      search(srhStart,str)
    else
      editor.Select(nil,{BlockStartPos=0})
    end
  end
  setStatus(str)
end

local function quitSearchMode(restorePos)
  SearchMode = false
  if str~="" then last = str end
  setStatus()
  srhFin()
  if restorePos then
    editor.SetPosition(nil,OriginalPos)
    SetSelection(OriginalSel)
  end
end
----------------------------------------------

local function append(text)
  str = appendable and str..text or str
  setStatus(str)
  search(srhStart,str,nil,ExtraQuick and appendable and text~="" and "Right")
end

local actions = {
  --skip
  Shift=function() Keys"Shift" end;
  --backspace/restore
  BS=function()
    str = str:len()>0 and str:sub(1,-2) or last
    appendable = true
    return "" --return value in order to append it to search string
  end;
  --clear/restore
  CtrlBS=function()
    str = str:len()>0 and "" or last
    appendable = true
    return ""
  end;
  --insert
  ShiftIns=function()
    return far.PasteFromClipboard():match"[^\r\n]+"
  end;
  --quit and restore pos
  Esc=function() quitSearchMode(not useBM) end;
  --quit
  Alt=function() quitSearchMode() end;
  --next
  ShiftF7=function()
    if str~="" then
      search(srhFwd,str,nil,"Right")
    end
  end;
  --prev
  AltF7=function()
    if str~="" then
      search(srhBwd,str,nil,"Left")
    end
  end;
  AltC=function() srhToggleOption"CaseSensitive" end;
  AltW=function() srhToggleOption"WholeWords" end;
  AltG=function() srhToggleOption"RegExp" end;
  AltH=function() srhToggleOption"HighLight" end;
  AltQ=function()
    ExtraQuick = not ExtraQuick
    local txt = "ExtraQuick:"..(ExtraQuick and 1 or 0)
    MessagePopup(txt,"IncSearch.lua",nil,300)
  end;
}

Macro {
  area="Editor"; key="RAlt"; description="incremental search mode";
  uid="9CDB70B8-2774-491C-9F7C-46B4B0BC14CE";
  action=function()
    enterSearchMode()
    repeat
      local key = mf.waitkey()
      key = xform[key] or key
      if actions[key] then
        local text = actions[key](key)
        if text then append(text) end
      elseif key:len()>1 then
        quitSearchMode()
        if eval(key,2)==-2 then Keys(key) end
      else
        append(key)
      end
    until not SearchMode
  end;
}