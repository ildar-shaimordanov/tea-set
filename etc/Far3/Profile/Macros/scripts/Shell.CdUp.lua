
-- http://forum.farmanager.com/viewtopic.php?f=60&t=6542

local function FillTable(t, path)
  while true do
    path = path:match("(.*)\\[^\\]+$")
    if path==nil then break end
    t[#t+1] = {path=path.."\\"}
  end
end
 
local function ShowMenu()
  local items = {}
  if APanel.Plugin then
    FillTable(items, APanel.Path)
    if items[1] then items[#items+1] = { separator=true } end
    items[#items+1] = { path=APanel.Path0 }
  end
  FillTable(items, APanel.Path0)
  if items[1] then
    for k,v in ipairs(items) do
      if v.path then
        local extra = v.path:len() - Far.Width + 8
        v.text = extra<=0 and v.path or "..."..v.path:sub(extra+4)
      end
    end
    local item = far.Menu({Title="Go to ..."}, items)
    if item then Panel.SetPath(0, item.path) end
  end
end
 
Macro {
	area = "Shell";
	key = "CtrlBS";
	description = "Shell: Menu with list of parent directories (CD up)";
	condition = function()
		return CmdLine.Empty and APanel.Visible
	end;
	action = ShowMenu;
}

