local Info = Info or package.loaded.regscript or function(...) return ... end --luacheck: ignore 113/Info
local nfo = Info { _filename or ...,
  name        = "Ctrl+O ultimate";
  description = "View UserScreen from any area";
  version     = "0.3"; --http://semver.org/lang/ru/
  author      = "jd";
  url         = "https://forum.farmanager.com/viewtopic.php?f=15&t=10983";
  id          = "0698713F-35CF-4B47-98E4-C281E700C7DF";
  minfarversion = {3,0,0,5067,0}; --desktop
  helpstr = [[
Хотя в редакторе/вьювере "из коробки" заявлена возможность по Ctrl+O посмотреть
пользовательский экран, реализована она неполноценно, например невозможно использовать
граббер, не работают макросы http://bugs.farmanager.com/view.php?id=3523

Предлагаемый набор макросов даёт возможность полноценного просмотра пользовательского экрана
из любой области.
По желанию отдельные области можно исключить, перечислив их в параметре "exclude".

Если активное окно немодально, то по нажатию Ctrl+O происходит переключение в окно Desktop.
Если модально, то для просмотра используются функции GetUserScreen/SetUserScreen.
Обратно можно вернуться нажав Ctrl+O, Esc или Ctrl+Tab.
  ]];
  help        = function(nfo) far.Message(nfo.helpstr,nfo.name,nil,"l") end;
  options     = {
    exclude = "Grabber ShellAutoCompletion DialogAutoCompletion";
  };
  --disabled    = true;
}
if not nfo or nfo.disabled then return end
local O = nfo.options

local Exclude = {}
if O.exclude and type(O.exclude=="string") then
  for area in O.exclude:gmatch"%S+" do Exclude[area] = true end
end

local F = far.Flags
local actl,          GetWindowInfo,       SetCurrentWindow
    = far.AdvControl,F.ACTL_GETWINDOWINFO,F.ACTL_SETCURRENTWINDOW

local function isModal(wi)
  return band(wi.Flags,F.WIF_MODAL)~=0
end

-- 0003523: Полноценный просмотр пользовательского экрана в редакторе/вьювере
-- http://bugs.farmanager.com/view.php?id=3523

Macro { description="CtrlO: view UserScreen from any area";
  area="Common"; key="CtrlO"; priority=40;
  id="51E14530-08AA-4134-9488-4AD5EF8B6EDE";
  condition=function()
    return not Exclude[Area.Current]
       and actl(GetWindowInfo).Type~=F.WTYPE_PANELS
  end;
  action=function()
    local wi = actl(GetWindowInfo)
    if isModal(wi) then
      panel.GetUserScreen(nil,1)
    else
      for i=1,wi.Pos-1 do
        if actl(GetWindowInfo,i).Type==F.WTYPE_DESKTOP then
          actl(SetCurrentWindow,i)
          return
        end
      end
    end
  end;
}

-- 0003496: Desktop: реализовать выход по Esc/Ctrl-O
-- http://bugs.farmanager.com/view.php?id=3496

Macro { description="CtrlO/Esc - quit Desktop";
  area="Desktop"; key="Esc CtrlTab CtrlO"; priority=45;
  id="6AB9F806-45E5-46E2-8146-8136CC2F275D";
  action=function()
    local wi = actl(GetWindowInfo)
    if isModal(wi) then
      panel.SetUserScreen(nil,1)
    else
      actl(SetCurrentWindow,wi.Pos-1)
    end
  end;
}
