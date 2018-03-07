-- https://forum.farmanager.com/viewtopic.php?f=15&t=11109

-- Enable or disable the macros
local enabled = true

---------------------------------------------------------------------------

-- *.tar
local function is_tar(f)
	return f:match("(%.tar)$")
end

-- *.tgz or *.gz
-- *.tbz or *.bz
-- *.tbz2 or *.bz2
local function is_zip(f)
	return f:match("(%.t?gz)$") or f:match("(%.t?bz2?)$")
end

-- *.tgz or *.tar.gz
-- *.tbz or *.tar.bz
-- *.tbz2 or *.tar.bz2
local function is_tarball(f)
	return f:match("(%.tgz)$") or f:match("(%.tar%.gz)$") 
	or f:match("(%.tbz2?)$") or f:match("(%.tar%.bz2?)$")
end

---------------------------------------------------------------------------

Macro {
	area = "Shell";
	key = "Enter CtrlPgDn";
	description = "Deep Tarball: Enter the Tarball";
	condition = function()
		return enabled and is_tarball(APanel.Current)
	end;
	action = function()
		Keys("AKey Down AKey")
	end;
}

Macro {
	area = "Shell";
	key = "Enter CtrlPgUp";
	description = "Deep Tarball: Exit the Tarball";
	condition = function()
		return enabled and ( APanel.Current == ".." or is_tar(APanel.HostFile) )
	end;
	action = function()
		Keys("AKey")
		if APanel.Plugin and is_zip(APanel.HostFile) then Keys("Up AKey") end
	end;
}

---------------------------------------------------------------------------

-- EOF
