-- Started 2014-12-01 by Shmuel Zeigerman
-- http://forum.farmanager.com/viewtopic.php?f=15&t=9191
-- http://forum.farmanager.com/viewtopic.php?p=126100#p126100

-- Imitate the feature of typing/erasing on multiple lines at once (like the SciTE editor does).
-- * Select a vertical block 1 character wide.
-- * Position the cursor on any line covered with the block, on the block position or rightward from it.
-- * Type or delete (Del, BS) the text.

local F=far.Flags
local Map = {Space=" ", Tab="\t", BackSlash="\\"}

Event {
  group="EditorInput";
  action=function(Rec)
    if Rec.EventType==F.KEY_EVENT and Rec.KeyDown and Rec.ControlKeyState%0x10==0 then
      local EI=editor.GetInfo()
      if EI and EI.BlockType==F.BTYPE_COLUMN then
        local cur = editor.GetString()
        if cur and cur.SelStart>0 and cur.SelEnd<=cur.SelStart and EI.CurPos>=cur.SelStart then
          local key = far.InputRecordToName(Rec)
          local char = key and (Map[key] or key:match("^.$"))
          if key=="Del" or key=="BS" or key=="Left" or key=="Right" or char then
            local lnum = EI.BlockStartLine
            local newpos, clean = nil, true
            while true do
              local line = editor.GetString(nil,lnum)
              if not line or line.SelStart <= 0 then break end
              local pos = editor.TabToReal(nil,lnum,EI.CurTabPos)
              local s = line.StringText
              if key == "Del" then
                if pos <= line.StringLength then
                  if clean then editor.UndoRedo(nil,F.EUR_BEGIN); clean=false end
                  editor.SetString(nil, lnum, s:sub(1,pos-1)..s:sub(pos+1))
                end
              elseif key == "Right" then
                newpos = EI.CurPos + 1
              elseif key == "Left" then
                if pos == 1 then return true end
                newpos = EI.CurPos - 1
              elseif key == "BS" then
                if pos == 1 then return true end
                if pos <= line.StringLength+1 then
                  if clean then editor.UndoRedo(nil,F.EUR_BEGIN); clean=false end
                  editor.SetString(nil, lnum, s:sub(1,pos-2)..s:sub(pos))
                end
                newpos = EI.CurPos - 1
              elseif char then
                if pos > line.StringLength+1 then
                  s = s..(" "):rep(pos-line.StringLength-1)
                end
                if clean then editor.UndoRedo(nil,F.EUR_BEGIN); clean=false end
                editor.SetString(nil, lnum, s:sub(1,pos-1)..char..s:sub(pos+EI.Overtype))
                newpos = EI.CurPos + 1
              end
              lnum = lnum + 1
            end
            if not clean then editor.UndoRedo(nil,F.EUR_END) end
            if newpos then editor.SetPosition(nil, EI.CurLine, newpos) end
            editor.Select(nil, "BTYPE_COLUMN", EI.BlockStartLine, newpos or cur.SelStart, 1, lnum-EI.BlockStartLine)
            editor.Redraw()
            return true
          end
        end
      end
    end
  end;
}
