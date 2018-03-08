-- https://forum.farmanager.com/viewtopic.php?f=15&t=11109

-- Enable or disable the macros
local enabled = false

---------------------------------------------------------------------------

-- *.tar
local tar_ext = {
	"%.tar",
}

-- *.tgz or *.gz
-- *.tbz or *.bz
-- *.tbz2 or *.bz2
-- *.txz or *.xz
local zip_ext = {
	"%.t?gz",
	"%.t?bz2?",
	"%.t?xz",
}

-- *.tgz or *.tar.gz
-- *.tbz or *.tar.bz
-- *.tbz2 or *.tar.bz2
-- *.txz or *.tar.xz
local tarball_ext = {
	"%.tgz",   "%.tar%.gz",
	"%.tbz2?", "%.tar%.bz2?",
	"%.txz",   "%.tar%.xz",
}

local function is_file(f, ext)
	for i = 1, #ext do
		if f:match("("..ext[i]..")$") then return true end
	end
	return false
end

local function is_tar(f)
	return is_file(f, tar_ext)
end

local function is_zip(f)
	return is_file(f, zip_ext)
end

local function is_tarball(f)
	return is_file(f, tarball_ext)
end

---------------------------------------------------------------------------

Macro {
	area = "Shell";
	key = "Enter CtrlPgDn";
	description = "Deep Tarball: Enter the archive";
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
	description = "Deep Tarball: Exit the archive";
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
