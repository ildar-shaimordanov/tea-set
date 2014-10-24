local break_sequence_on_mod_release = true

--http://forum.farmanager.com/viewtopic.php?f=15&t=8764

local RAlt, LAlt  = 0x1,0x2
local RCtrl,LCtrl = 0x4,0x8
--[[
local Shift = 0x10
local NumLock,ScrollLock,CapsLock = 0x20,0x40,0x80
local ENHANCED_KEY = 0x100
--]]
local Mods = {
  RAlt =RAlt,  LAlt =LAlt,  Alt =bor(RAlt, LAlt),
  RCtrl=RCtrl, LCtrl=LCtrl, Ctrl=bor(RCtrl,LCtrl),
}

local function isReleased(Mod) return band(Mouse.LastCtrlState,Mod)==0 end -- State after last mf.waitkey!!
local function guessMod(mod,AKey)
  mod = mod or AKey:match"Ctrl" or AKey:match"Alt" or error"unable to guess modifier key"
  return assert(Mods[mod],"wrong modifier specified")
end

local function exec(f,...)
  if type(f)=="function" then
    return f(...)
  else
    Keys(f)
  end
end

local F,C = far.Flags,far.Colors
local Color2 = far.AdvControl(F.ACTL_GETCOLOR,C.COL_MENUHIGHLIGHT)
local Color1 = far.AdvControl(F.ACTL_GETCOLOR,C.COL_MENUTITLE)
local function setStatus(text,Color)
  if text and type(text)=="string" then
    far.Text(1,0,Color," "..text.." ")
    far.Text()
  end
end

local getMod = regex.new"^((?:[LR]?Ctrl)?(?:[LR]?Alt)?(?:Shift)?).+$"

local Delay = 300
local SeqDelay = 1000
return function(Macro)
  return function(t)
    local   action,  condition,  hold,  doubletap,  sequence,  delay,  mod =
          t.action,t.condition,t.hold,t.doubletap,t.sequence,t.delay,t.mod
    if not (hold or doubletap or sequence) then return Macro(t) end
    local busy
    local function KeysEx(key)
      if key and key~="" then
        busy = true
        if eval(key,2)==-2 then Keys(key) end
        busy = false
      end
    end
    t.priority=t.priority or 60;
    t.condition=function(...)
      return not busy and (not condition or condition(...))
    end;
    t.action=function(...)
      local AKey = akey(1)
      local mod = guessMod(mod,AKey)
      if sequence then setStatus(sequence.status,Color1) end
      local key = ""
      local timeout
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      local start = Far.UpTime
      delay = not (hold or doubletap) and SeqDelay or delay or Delay
      while not (timeout or key~="" or isReleased(mod)) do
        key = mf.waitkey(10)
        timeout = Far.UpTime-start>delay
      end
      if hold and timeout then
        return exec(hold,"hold")
      elseif doubletap and key==AKey then
        return exec(doubletap,"doubletap")
      end
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      local h
      if sequence then
        setStatus(sequence.status,Color2)
        local getKey = regex.new("^"..getMod:match(AKey).."(.+)$")
        local seq = sequence
        while not (isReleased(mod) and break_sequence_on_mod_release) do
          if timeout then
            if seq.help and not h then
              h = far.SaveScreen()
              far.Message(seq.help,seq.status,"","l")
            end
          end
          if key~="" then
            local key2 = getKey:match(key) or key:len()==1 and key:upper() or key
            local action = seq[key2]
            if action then
              if h then far.RestoreScreen(h); h = nil end
              if type(action)=="table" then
                seq = action
                setStatus(seq.status,Color2)
                timeout = true --todo??
              else
                return exec(action,key2)
              end
            else
              break
            end
          end
          key = mf.waitkey(10)
          timeout = timeout or Far.UpTime-start>delay
        end
      end
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
      if h then far.RestoreScreen(h) end
      if timeout then elseif action then exec(action,...) else KeysEx(AKey) end
      KeysEx(key)
    end
    return Macro(t)
  end
end