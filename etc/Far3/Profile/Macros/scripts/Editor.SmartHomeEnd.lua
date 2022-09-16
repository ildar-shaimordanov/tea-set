
-- http://forum.farmanager.com/viewtopic.php?f=15&t=8421
-- https://github.com/Firebie/FarScripts/blob/master/Editor/Editor.SmartHomeEnd.lua

-- version 1.4

local function EditorSelect(editorId, blockType, startLine, startPos, linesCount, posCount)
   editor.Select(
    editorId, 
    blockType, 
    startLine, 
    startPos, 
    linesCount, 
    posCount)
end

local function EditorClearSelection(editorId)
  editor.Select(editorId, 0)
end

local function SelectBlock(info, sel, curPos, blockType, persistentBlocks)
  
  local curLine = info.CurLine

  if sel and not persistentBlocks then
     
    -- we either had cursor at the block begin or at the block end
    if curLine == sel.StartLine and info.CurPos == sel.StartPos then
      
      -- so, cursor was the block begin, 
      -- so, we lock block end
      if curLine == sel.EndLine and curPos == sel.EndPos then
        EditorClearSelection(info.EditorId)
      elseif curLine < sel.EndLine or (curLine == sel.EndLine and (curPos - 1) < sel.EndPos) then
        -- mark from curPos to block end
        EditorSelect(info.EditorId, blockType, curLine, curPos, sel.EndPos - curPos + 1, sel.EndLine - curLine + 1)
      else
        -- mark from block end to curPos
        EditorSelect(info.EditorId, blockType, sel.EndLine, sel.EndPos + 1, curPos - sel.EndPos - 1, curLine - sel.EndLine + 1)
      end
    else
      -- so, cursor was the block end
      -- so, we lock block begin
      if curLine == sel.StartLine and curPos == sel.StartPos then
        EditorClearSelection(info.EditorId)
      elseif curLine < sel.StartLine or (curLine == sel.StartLine and curPos < sel.StartPos) then
        -- mark from curPos to block begin
        EditorSelect(info.EditorId, blockType, curLine, curPos, sel.StartPos - curPos, sel.StartLine - curLine + 1)
      else
        -- mark from block begin to curPos
        EditorSelect(info.EditorId, blockType, sel.StartLine, sel.StartPos, curPos - sel.StartPos, curLine - sel.StartLine + 1)
      end
    end
  else
    -- no selection block
    
    if curPos == info.CurPos then
      EditorClearSelection(info.EditorId)
    elseif curPos < info.CurPos then
      EditorSelect(info.EditorId, blockType, curLine, curPos, info.CurPos - curPos, 1)
    else
      EditorSelect(info.EditorId, blockType, curLine, info.CurPos, curPos - info.CurPos, 1)
    end
  end
    
end;

local function SmartHome(select, blockType)
  
  blockType = blockType or far.Flags.BTYPE_STREAM
  
  local info = editor.GetInfo()
  local sel  = editor.GetSelection()
  local persistentBlocks = band(info.Options, far.Flags.EOPT_PERSISTENTBLOCKS) ~= 0;
    
  if info then
    local str = editor.GetString(-1, info.CurLine)
    local s = str.StringText
    local len = s:len()
    local pos = 1

    for i = 1, len do
      local c = s:sub(i, i)
      if not c:match("%s") then

        pos = i
        if pos == info.CurPos then
          pos = 1
        end
          
        break
      end
    end

    editor.SetPosition(info.EditorId, info.CurLine, pos)
    if (select) then
      SelectBlock(info, sel, pos, blockType, persistentBlocks)
    elseif band(info.Options, far.Flags.EOPT_PERSISTENTBLOCKS) == 0 then
      editor.Select(info.EditorId, 0)
    end

  end
end

local function SmartEnd(select, blockType)
  
  blockType = blockType or far.Flags.BTYPE_STREAM

  local info = editor.GetInfo()
  local sel  = editor.GetSelection()
  local persistentBlocks = band(info.Options, far.Flags.EOPT_PERSISTENTBLOCKS) ~= 0;

  if info then
    local str = editor.GetString(-1, info.CurLine)
    local s = str.StringText
    local len = s:len()
    local pos = len + 1

    for i = len, 1, -1 do
      local c = s:sub(i, i)
      if not c:match("%s") then 

        pos = i + 1
        if pos == info.CurPos then
          pos = len + 1
        end

        break
      end
    end

    editor.SetPosition(info.EditorId, info.CurLine, pos)
  
    if (select) then
      SelectBlock(info, sel, pos, blockType, persistentBlocks)
    elseif band(info.Options, far.Flags.EOPT_PERSISTENTBLOCKS) == 0 then
      editor.Select(info.EditorId, 0)
    end

  end
end


Macro {
	area = "Editor";
	key = "/Home|Num7/";
	flags = "";
	description = "Editor: Smart Move: Home";
	action = function()
		SmartHome(false)
	end;
}

--[[

Macro {
	area = "Editor";
	key = "/End|Num1/";
	flags = "";
	description = "Editor: Smart Move: End";
	action = function()
		SmartEnd(false)
	end;
}
]]

Macro {
	area = "Editor";
	key = "/Shift(Home|Num7)/";
	flags = "";
	description = "Editor: Smart Select: ShiftHome";
	action = function()
		SmartHome(true)
	end;
}

--[[

Macro {
	area = "Editor";
	key = "/Shift(End|Num1)/";
	flags = "";
	description = "Editor: Smart Select: ShiftEnd";
	action = function()
		SmartEnd(true)
	end;
}

]]

--[[

Macro {
	area = "Editor";
	key = "/AltShift(Home|Num7)/";
	flags = "";
	description = "Editor: Smart AltShiftHome";
	action = function()
		SmartHome(true, far.Flags.BTYPE_COLUMN)
	end;
}

]]

--[[

Macro {
	area = "Editor";
	key = "/AltShift(End|Num1)/";
	flags = "";
	description = "Editor: Smart AltShiftEnd";
	action = function()
		SmartEnd(true, far.Flags.BTYPE_COLUMN)
	end;
}

]]
