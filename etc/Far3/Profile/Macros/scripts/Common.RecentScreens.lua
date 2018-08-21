--todo: сделать лайт-версию (после 4138 известен z-order, что позволяет не хранить порядок)
local Info = package.loaded.regscript or function(...) return ... end
local nfo = Info {_filename or ...,
  name        = "RecentScreens";
  --переключение между окнами как в MS Windows™
  description = "switch windows like MS Windows™";
  version     = "3.10"; --http://semver.org/lang/ru/
  author      = "jd";
  url         = "http://forum.farmanager.com/viewtopic.php?f=60&t=7876";
  id          = "789DF383-23EE-4CF2-B274-7F3D387AEB98";
  minfarversion = {3,0,0,5065,0}; --luamacro 624
  --disabled    = false;
  options     = { --todo
    menuDelayDefault = 200,
    macroKey = "Tab",         -- CtrlTab / CtrlShiftTab
    --macroKey = "`",         -- Ctrl~ / CtrlShift~
    --macroKey = "CapsLock",  -- CtrlCapsLock / CtrlShiftCapsLock
  };
}
if not nfo then return end
local O = nfo.options

local _KEY,_NAME = "JD",nfo.name
local F = far.Flags
------------------------------------------------
--Settings

local S = mf.mload(_KEY,_NAME) or {  -- default settings:
  menuDelay = O.menuDelayDefault, -- delay before RecentScreens list show
                                  -- if negative then no list
  switchInstant = true,           -- if false then switch only after Ctrl release (for menu only)
  RecentOnClose = true,           -- true = goto pre-recent screen when closing current one
                                  -- false = FAR default behavior
                                  -- (goto panels if Pos==Windows, otherwise keep same Pos)
}

local function saveSettings() mf.msave(_KEY,_NAME,S) end

-------------------------------------------------------------
--- some general definitions
local function Warning(msg)
   far.Message(msg,"Warning","","w"); far.Text(); win.Sleep(500) --!!debug
end
local function assert(expr,...)
  if not expr then Warning(...) end
  return expr
end

--local function isPanels(Area) return allPanels:find(Area) end
local function isPanels()
  local wi = far.AdvControl(F.ACTL_GETWINDOWTYPE)
  return wi and wi.Type==F.WTYPE_PANELS
end

local Lock = {Num=0, Caps=1, Scroll=2}
local modeIsOn,keyIsPressed = 1,0xff80
local function LockState(xLock,Action) --set State: 0|1|2=toggle
                                       --get State: nil|-1
  local Lkey = assert(Lock[xLock])
  local State = mf.flock(Lkey,-1)
  local mode, hold = band(State,modeIsOn)==modeIsOn,
                     band(State,keyIsPressed)==keyIsPressed
  if Action==2 or Action~=-1 and (mode==(Action==0)) then
    if hold then mf.flock(Lkey,Action) end --http://forum.farmanager.com/viewtopic.php?p=139236#p139236
    mf.flock(Lkey,Action)
  end
  return mode,hold
end

--local RAlt,LAlt  = F.RIGHT_ALT_PRESSED,F.LEFT_ALT_PRESSED
--local Shift = F.SHIFT_PRESSED
local RCtrl,LCtrl = F.RIGHT_CTRL_PRESSED,F.LEFT_CTRL_PRESSED --State after last mf.waitkey!!
local function ModReleased(Mod) return band(Mouse.LastCtrlState,Mod)==0 end

local function WindowsCount() return far.AdvControl (F.ACTL_GETWINDOWCOUNT) end

local function makeuid(Area,id) return Area..id end

local En = {
  [F.WTYPE_PANELS]="Panels",[F.WTYPE_VIEWER]="View",[F.WTYPE_EDITOR]="Edit",
  [F.WTYPE_DIALOG]="Dialog",
--  [F.WTYPE_DESKTOP]="Desktop",
}
local function getWindow(n) -- n = window's Pos [optional]
  local w = assert(far.AdvControl (F.ACTL_GETWINDOWINFO,n))
  w.uid = En[w.Type] --skip unsupported screen types
          and makeuid(En[w.Type],tostring(w.Id))
  return w
end

--------------------------------------------------------
-- "Recent" Screens bare logic
local Screens = { --array of windows' uid's in MRU order
  uids = {},
  --DelayedUid,
  --noMonitoring
}
function Screens:DisableMonitoring(state) -- check if added
  self.noMonitoring = state
end

-- ~ do not work under conemu
if O.macroKey=="Tab" and win.GetEnv"ConEmuDir" then Screens:DisableMonitoring(true) end

--[[
local function Conemu(param)
  return Plugin.SyncCall("4B675D80-1D4A-4EA9-8436-FDC23F2FC14B",param)
end

if O.macroKey=="Tab" and Conemu("IsConEmu") then Screens:DisableMonitoring(true) end
if O.macroKey=="Tab" and Conemu("GetOption TabSelf")~="0" then return end
--]]

function Screens:Exist(uid) -- check if added
  return self.uids[uid]
end
function Screens:Add(uid) -- add new
  if not uid then return end --don't add screens without uid
  table.insert(self,1,uid)
  self.uids[uid] = true
  if self.DelayedUid then self.DelayedUid = "" end
end
function Screens:Remove(uid)
  for i=1,#self do
    if self[i]==uid then
      table.remove(self,i)
      self.uids[uid] = nil
      return i
    end
  end; --Warning("uid do not exist: "..tostring(uid)) --!!debug
end
function Screens:Top() return self[1] end -- most recent uid
function Screens:Pop(uid) -- move to top
  --if not (uid and self:Exist(uid)) then error("uid not found:"..tostring(uid)) end--!!debug
  if not self.noMonitoring and self:Top()~=uid then
    if self:Remove(uid) then self:Add(uid) else return false end
  end
  return true
end
function Screens:Goto(uid) -- switch screen
  for i=1,WindowsCount() do --get window Pos by uid
    local w = getWindow(i)
    if w.uid == uid then
      if band(w.Flags,F.WIF_CURRENT)==0 then
        far.AdvControl(F.ACTL_SETCURRENTWINDOW,w.Pos)
        far.AdvControl(F.ACTL_COMMIT)
      end
      return
    end
  end
  --
  self:Remove(uid)
  Warning("cannot find window "..tostring(uid)) --!!debug
end
function Screens:delayGotoTop()
  if not self.DelayedUid then
    mf.postmacro(function()
      if self.DelayedUid~="" and band(getWindow().Flags,F.WIF_MODAL)==0 then --not Menu/Dialog
        Screens:Goto(self.DelayedUid)
      end
      self.DelayedUid = false
    end)
  end
  self.DelayedUid = Screens:Top()
end

-- init Screens
for i=1,WindowsCount() do Screens:Add(getWindow(i).uid) end

---------------------------------------------------------------
-- Helper event-handlers
Event{ description="[RecentScreens] editor handler"; group="EditorEvent";
  id="39C42CCD-E4E1-4165-AAAF-FD81D9C54E37";
  action=function(id,Event)
    local uid = makeuid("Edit",id)
    if Event==F.EE_GOTFOCUS then
      if not Screens:Exist(uid) then  --Add editor (on read)
        Screens:Add(uid)
      else                            --Pop editor (on focus)
        Screens:Pop(uid)
      end
    elseif Event==F.EE_CLOSE then     --Remove editor (on close) --bug http://forum.farmanager.com/viewtopic.php?f=54&t=8779&p=125017#p125017
      Screens:Remove(uid)
      if S.RecentOnClose then Screens:delayGotoTop() end
    end
  end;
}
Event{ description="[RecentScreens] viewer handler"; group="ViewerEvent";
  id="267160C4-7C26-4883-A126-D4EB081C254D";
  action=function(id,Event)
    local uid = makeuid("View",id)
    if Event==F.VE_GOTFOCUS then
      if not Screens:Exist(uid) then  --Add viewer (on read)
        Screens:Add(uid)
      else                            --Pop viewer (on focus)
        Screens:Pop(uid)
      end
    elseif Event==F.VE_CLOSE then     --Remove viewer (on close)
      if isPanels() then return end   --Ignore QView,Info
      Screens:Remove(uid)
      if S.RecentOnClose then Screens:delayGotoTop() end
    end
  end;
}
Event{ description="[RecentScreens] dialog handler"; group="DialogEvent";
  id="2FE435A8-52B6-47F6-8823-9F4D064B1DBA";
  action=function(Event,param)
    if Event~=F.DE_DLGPROCEND then return end
    local Msg,hDlg,Param1 = param.Msg,param.hDlg,param.Param1
    if Msg==F.DN_CLOSE then         --Remove dialog (on close)
      local uid = makeuid("Dialog",tostring(hDlg))
      if Screens:Exist(uid) then
        Screens:Remove(uid)
        if S.RecentOnClose then Screens:delayGotoTop() end
      end
    elseif Msg==F.DN_GOTFOCUS and Param1==-1 then
      local uid = makeuid("Dialog",tostring(hDlg))
      if not Screens:Exist(uid) then  --Add dialog
        Screens:Add(uid)
      else                            --Pop dialog
        Screens:Pop(uid)
      end
    end
  end;
}
Event { description="[RecentScreens] Save settings (on exit)";
  id="3B6F9E40-C470-4194-9DD3-4A76206ED8C8";
  group="ExitFAR";
  action=saveSettings;
}

-----------------------------------------------------------
-- RecentScreens menu logic helpers (see showRecentScreens)
local RSid = "92B73618-3C29-401C-BE62-B0406513CB82" -- RecentScreens menu id
local function isRecentScreensMenu() return Menu.Id==RSid end;

Event{ description="[RecentScreens] (auto-switching)"; group="DialogEvent";
  id="77F0B1FE-3937-4C4E-87F5-56CA273EA33F";
  condition=function(Event,Param)
    return (S.switchInstant or S.menuDelay<0)
       and Event==F.DE_DLGPROCINIT and Param.Msg==F.DN_LISTCHANGE --FAR bug: http://bugs.farmanager.com/view.php?id=1301#c12736
       and isRecentScreensMenu()
  end;
  action=function()--(_,Param)
    mf.postmacro(Keys,"Enter")
    --Param.hDlg:send(F.DM_CLOSE) -- this would cause flicker!!
  end;
}

Event{ description="[RecentScreens] (close on release)"; group="DialogEvent";
  id="D4880483-A3A8-4B6F-97E3-20EE86B4A354";
  condition=function(Event,Param)
    return Event==F.DE_DLGPROCINIT and Param.Msg==F.DN_ENTERIDLE
       and isRecentScreensMenu() and ModReleased(LCtrl+RCtrl)
  end;
  action=function()
    mf.postmacro(Keys,"Esc")
  end;
}

------------------------------------------------
-- RecentScreens-menu macros
Macro { description="[RecentScreens] Prev/Next";
  area="Menu"; key="/^[LR]Ctrl(Shift)?(CapsLock|Tab|`)$/";
  id="650C5D50-2750-4814-A12A-E7E749F4E322";
  condition=isRecentScreensMenu;
  action=function() Keys(akey(1,1):find"Shift" and "Up" or "Down") end;
}

Macro { description="[RecentScreens] Prev/Next (additional)";
  area="Menu"; key="/^[LR]Ctrl(Up|Down|PgUp|PgDn|Num9|Num3)$/";
  id="F7ABABFA-A70D-4A26-A725-632040747F0A";
  condition=isRecentScreensMenu;
  action=function() Keys(akey(1,1):match"^R?Ctrl(.+)$") end;
}

Macro { description="[RecentScreens] Scroll long titles";
  area="Menu"; key="CtrlRight CtrlLeft";
  id="BCD83367-88D6-4CAF-BF33-C2FF176D09AB";
  condition=isRecentScreensMenu;
  action=function() Keys("Alt"..akey(1,1):match"Ctrl(.+)") end;
}

Macro { description="[RecentScreens] Goto [0-9A-Z]";
  area="Menu"; key="/^[RL]Ctrl\\w$/";
  id="A1428D9E-C5A0-46A8-8A1B-F5B0A2407FE1";
  condition=isRecentScreensMenu;
  action=function() Keys(akey(1,1):sub(-1)) end;
}

------------------------
-- helper table
local getWindowByUid = {}
function getWindowByUid:Init() -- need init before call showRecentScreens
  for i=1,WindowsCount() do
    local w = getWindow(i)
    if w.uid then self[w.uid] = w end
  end
end
------------------------------
-- another helper
local function new_pos(pos,key)
    local d =
              --key:find("Up$") and 1 or
              key:find("Down$") and -1 or
              --key:find("^R?Ctrl") and 1 or
              key:find("^R?CtrlShift") and -1 or
              1 --FAR bug http://bugs.farmanager.com/view.php?id=2309 -- В Far 3 поломалась функция akey(1,1)
    if d then
      pos = pos+d
      return pos>#Screens and 1 or pos<1 and #Screens or pos
    end
end

-------------------------------------------
-- RecentScreens menu itself
local BreakKeys = { --http://msdn.microsoft.com/library/dd375731
  {BreakKey="ESCAPE",br=true},
  {BreakKey="C+DIVIDE",  action=function() S.switchInstant = not S.switchInstant; end},
  {BreakKey="C+NUMPAD0", action=function() S.RecentOnClose = not S.RecentOnClose; end}, --fixme: to doc
  {BreakKey="C+MULTIPLY",action=function()
     S.menuDelay = S.menuDelay>0 and -1 or
                   S.menuDelay<0 and 0 or
                   S.menuDelay==0 and O.menuDelayDefault
   end},
  {BreakKey="C+ADD",     action=function() S.menuDelay = S.menuDelay<0 and 0 or S.menuDelay+50; end},
  {BreakKey="C+SUBTRACT",action=function() S.menuDelay = S.menuDelay-50<0 and -1 or S.menuDelay-50; end},
  {BreakKey="C+F8",      action=function()
     if far.Message("\nDelete saved settings?\n",nfo.name,";OkCancel") then
       mf.mdelete(_KEY,_NAME)
     end
   end},
  {BreakKey="C+F1",action=function(self)
     far.Message([[
Параметры, управляющие переключением,
можно изменить с помощью горячих клавиш
на цифровой клавиатуре:

[/] Instant - определяет момент переключения
- true  - при каждом нажатии CtrlTab
- false - после отпускания Ctrl

[*] Delay - задержка появления списка экранов
Плавно изменить: [+/-]
<0 - не отображать список
/* список всегда доступен по CtrlF12 */
]],nfo.name.." v"..nfo.ver,nil,"kl")
     self.br = ModReleased(LCtrl+RCtrl)
   end},
}

local Props = {Title="RecentScreens",Id=win.Uuid(RSid),Flags=F.FMENU_WRAPMODE}
local Bottom = ("[F1] Help  |  Options:  [/] Instant: %-5s  [+/-], [*] Delay: %-9s")

local function showRecentScreens(key,pos)
  local Items = {}          -- RecentScreens menu items
  for i=1,#Screens do
    local w = getWindowByUid[Screens[i]];
    w.disable = key=="modal" and i~=1
    local EditorModified = band(w.Flags,F.WIF_MODIFIED) ~= 0
    w.checked = w.Pos==1 and "≡" -- =≡■
    local name = (w.Type==F.WTYPE_PANELS) and APanel.Path.."\\" or w.Name --todo: plugin name? hostfile?
    local TypeName = w.TypeName..(" "):rep(10-w.TypeName:len())
    local hk = w.Pos-1 --bug http://forum.farmanager.com/viewtopic.php?f=54&t=8883&p=125016#p125016
    hk = hk<=9 and hk or hk<=35 and string.char(("A"):byte()+hk-10)
    hk = hk and "&"..hk.."." or ""
    w.text = ("%2s %-10s %1s %s")
             :format(hk,TypeName, EditorModified and "*" or "" ,name)
    Items[i] = w
  end
  pos = key and new_pos(pos or 1,key) or pos or 1
  local item = Items[pos]
  repeat
    if S.switchInstant and item.uid then Screens:Goto(item.uid) end
    Props.Bottom = Bottom:format(tostring(S.switchInstant),
                                 S.menuDelay==-1 and "<no menu>" or S.menuDelay.." ms")
    Props.SelectIndex = pos
    item,pos = far.Menu(Props, Items, BreakKeys)
    if item.action then item:action() end --if BreakKey
  until item.br
  return Screens[pos]
end

----------------------------------------
-- switch without menu
local time
local function timeout(new)
  local uptime = Far.UpTime
  if not new then return uptime-time>S.menuDelay end
  time = uptime + S.menuDelay
end

local function switchRecentScreens(key)
  mmode(1,0) --enable output
  timeout"new"
  local pos,i = 1,0
  repeat -- NB: new loop every 50 ms
    local new = key~="" and new_pos(pos,key)
    if new then
      i = i+1
      pos = new
      if S.switchInstant or S.menuDelay<0 or i>1 then Screens:Goto(Screens[pos]) end
      timeout"new"
    end
    key = mf.waitkey(50)
    if key=="" and timeout() or key=="CtrlF12" then
      --pos = showRecentScreens(false,pos); break
      return showRecentScreens(false,pos)
    end
  until ModReleased(LCtrl+RCtrl)
  return Screens[pos]
end

---------------------------------------------
-- Main macro
local allPanels  = "Shell Info QView Tree Search "
local allScreens = allPanels.."Editor Viewer Other Dialog "
local function nonmodal()
  if Area.Dialog then
    local wi = far.AdvControl(F.ACTL_GETWINDOWINFO)
    return wi and band(wi.Flags,F.WIF_MODAL)~=F.WIF_MODAL
  else
    return true
  end
end
Macro { description="[RecentScreens] switch";
  area=allScreens; key="/^LCtrl(Shift)?("..O.macroKey..")$/";
  id="792800D3-DD8A-4F5D-A4A8-1004E6AFBE7E";
  condition=nonmodal;
  action=function()
    if Area.Search then Keys"Esc" end
    local w = getWindow()
    if Area.Other and w.Type~=F.WTYPE_DESKTOP then Keys"AKey"; return end --http://bugs.farmanager.com/view.php?id=2760
    if w.uid then Screens:Pop(w.uid) end
    getWindowByUid:Init()
    if band(w.Flags,F.WIF_MODAL) ~= 0 then
      showRecentScreens"modal"
    else
      local AKey = akey(1)
      Screens:DisableMonitoring(true)
        local uid = (S.menuDelay==0 or #Screens==1 or AKey:match"F12")
                    and showRecentScreens(AKey)
                     or switchRecentScreens(AKey)
      Screens:DisableMonitoring(false)
      Screens:Pop(uid)
      Screens:Goto(uid)
    end
    if O.macroKey=="CapsLock" then LockState("Caps",0) end
  end;
}

NoMacro { description="[RecentScreens] switch (show list)"; --todo check
  area=allScreens; key="/^LCtrl(Shift)?CapsLock$/";
  id="3DC8C55E-376D-4ED5-8C42-FF3E30F0AD68";
  condition=nonmodal;
  action=function()
    local w = getWindow()
    if not Area.Other and w.Type~=F.WTYPE_DESKTOP then Keys"AKey"; return end --http://bugs.farmanager.com/view.php?id=2760
    --if not w.uid then Keys"AKey"; return end --http://bugs.farmanager.com/view.php?id=2760
    if w.uid then Screens:Pop(w.uid) end
    getWindowByUid:Init()
    if band(w.Flags,F.WIF_MODAL) ~= 0 then
      showRecentScreens"modal"
    else
      Screens:DisableMonitoring(true)
        local uid = showRecentScreens(akey(1))
      Screens:DisableMonitoring(false)
      Screens:Pop(uid)
      Screens:Goto(uid)
    end
    LockState("Caps",0)
  end;
}
