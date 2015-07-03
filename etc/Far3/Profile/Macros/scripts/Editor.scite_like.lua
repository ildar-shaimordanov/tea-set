-- http://forum.farmanager.com/viewtopic.php?f=15&t=9191

-- Started 2014-12-01 by Shmuel Zeigerman

-- Imitate the feature of typing/erasing on multiple lines at once (like the SciTE editor does).
-- * Select a vertical block 1 character wide.
-- * Position the cursor on any line covered with the block, on the block position or rightward from it.
-- * Type or delete (Del, BS) the text.

local F=far.Flags
Event {
  group="EditorInput";
  action=function(Rec)
    if Rec.EventType==F.KEY_EVENT and Rec.KeyDown and Rec.ControlKeyState%0x10==0 then
      local EI=editor.GetInfo()
      if EI and EI.BlockType==F.BTYPE_COLUMN then
        local cur = editor.GetString()
        if cur and cur.SelStart>0 and cur.SelEnd<=cur.SelStart and EI.CurPos>=cur.SelStart then
          local char = Rec.UnicodeChar:match("[ \t%w%p%^$+=~`<>|]")
          local key = not char and far.InputRecordToName(Rec)
          if char or key=="Del" or key=="BS" then
            local lnum = EI.BlockStartLine
            editor.UndoRedo(nil,F.EUR_BEGIN)
            while true do
              local line = editor.GetString(nil,lnum)
              if not line or line.SelStart <= 0 then break end
              local pos = editor.TabToReal(nil,lnum,EI.CurTabPos)
              local s = line.StringText
              if char then
                if pos > line.StringLength+1 then
                  s = s..(" "):rep(pos-line.StringLength-1)
                end
                editor.SetString(nil, lnum, s:sub(1,pos-1)..char..s:sub(pos+EI.Overtype))
                editor.SetPosition(nil,EI.CurLine,EI.CurPos+1)
              elseif key=="Del" then
                editor.SetString(nil, lnum, s:sub(1,pos-1)..s:sub(pos+1))
              elseif key=="BS" and pos>1 then
                editor.SetString(nil, lnum, s:sub(1,pos-2)..s:sub(pos))
                editor.SetPosition(nil,EI.CurLine,EI.CurPos-1)
              end
              lnum = lnum + 1
            end
            editor.UndoRedo(nil,F.EUR_END)
            editor.Redraw()
            return true
          end
        end
      end
    end
  end;
}
