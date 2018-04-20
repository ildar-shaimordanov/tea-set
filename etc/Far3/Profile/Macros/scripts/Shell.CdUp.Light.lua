
-- https://forum.farmanager.com/viewtopic.php?p=149194#p149194

---------------------------------------------------------------------------

local FARPANEL_BRODER_WIDTH_LEFT = 1
local FARPANEL_BRODER_WIDTH_RIGHT = 1

local FARMENU_BORDER_WIDTH_LEFT = 5
local FARMENU_BORDER_WIDTH_RIGHT = 6

---------------------------------------------------------------------------

local OMIT = "..."
local oLen = string.len(OMIT)

function string.shrink(s, width)
	local sLen = string.len(s)
	return sLen <= width and s or OMIT .. string.sub(s, sLen - width + oLen + 1)
end

---------------------------------------------------------------------------

local function FillTable(t, path, width)
	local pLen = string.len(path)
	local pos = 0

	repeat
		pos = string.find(path, "\\", pos + 1, true)

		local s = string.sub(path, 1, pos and pos or pLen)
		if s == "" then s = "\\" end

		local sLen = string.len(s)
		table.insert(t, {
			path = s;
			text = string.shrink(s, width);
		})
	until not pos or pos >= pLen
end

---------------------------------------------------------------------------

local function ShowMenu()
	local items = {}

	-- max width for the menu items
	local width = APanel.Width - FARMENU_BORDER_WIDTH_LEFT - FARMENU_BORDER_WIDTH_RIGHT

	FillTable(items, APanel.Path0, width)

	if APanel.Plugin then
		table.insert(items, { separator = true })
		FillTable(items, APanel.Path, width)
	end

	local item = far.Menu({
		Title = "Go to...";
		SelectIndex = #items;
		-- Fit the menu into the width of the active panel taking into account the border widths
		X = ( APanel.Left and 0 or PPanel.Width ) + FARPANEL_BRODER_WIDTH_LEFT + FARPANEL_BRODER_WIDTH_RIGHT;
	}, items)

	if item then Panel.SetPath(0, item.path) end
end

---------------------------------------------------------------------------

if Macro == nil then
	ShowMenu()
	return
end

Macro {
	description = "Shell: Cd Up (Light)";
	area = "Shell";
	key = "AltPgUp";
	--condition = function() return APanel.Visible end;
	action = ShowMenu;
}

---------------------------------------------------------------------------

-- EOF
