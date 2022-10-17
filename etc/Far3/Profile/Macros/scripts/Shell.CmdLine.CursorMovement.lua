--[[

This macro is simplified and improved version of the macro 
Shell_CmdLine.lua having the same functionality and borrowed here:
https://forum.farmanager.com/viewtopic.php?p=93265#p93265

]]

local function CursorMoveHome(SelectText)
	local SelStart, SelEnd = 0, 0

	if SelectText then
		SelStart, SelEnd = panel.GetCmdLineSelection()
		local Pos = panel.GetCmdLinePos()

		if Pos == SelEnd + 1 then
			SelEnd = SelStart - 1
		elseif Pos ~= SelStart then
			SelEnd = Pos - 1
		end

		SelStart = 1

--		Pos = Pos == SelStart and SelEnd + 1 or Pos == SelEnd + 1 and SelStart or Pos
	end

	panel.SetCmdLineSelection(nil, SelStart, SelEnd)
	panel.SetCmdLinePos(nil, 1)
end

local function CursorMoveEnd(SelectText)
	local SelStart, SelEnd = 0, 0
	local Len = panel.GetCmdLine():len()

	if SelectText then
		SelStart, SelEnd = panel.GetCmdLineSelection()
		local Pos = panel.GetCmdLinePos()

		if Pos == SelStart then
			SelStart = SelEnd + 1
		elseif Pos ~= SelEnd + 1 then
			SelStart = Pos
		end

		SelEnd = Len

--		Pos = Pos == SelStart and SelEnd + 1 or Pos == SelEnd + 1 and SelStart or Pos
	end

	panel.SetCmdLineSelection(nil, SelStart, SelEnd)
	panel.SetCmdLinePos(nil, Len + 1)
end

Macro {
	area = "Shell Info QView Tree";
	key = "Home Num7";
	description = "CmdLine.CursorMovement.Home";
	flags = "NotEmptyCommandLine";
	action = function() CursorMoveHome() end;
}

Macro {
	area = "Shell Info QView Tree";
	key = "ShiftHome ShiftNum7";
	description = "CmdLine.CursorMovement.ShiftHome";
	flags = "NotEmptyCommandLine";
	action = function() CursorMoveHome(1) end;
}

Macro {
	area = "Shell Info QView Tree";
	key = "End Num1";
	description = "CmdLine.CursorMovement.End";
	flags = "NotEmptyCommandLine";
	action = function() CursorMoveEnd() end;
}

Macro {
	area = "Shell Info QView Tree";
	key = "ShiftEnd ShiftNum1";
	description = "CmdLine.CursorMovement.ShiftEnd";
	flags = "NotEmptyCommandLine";
	action = function() CursorMoveEnd(1) end;
}
