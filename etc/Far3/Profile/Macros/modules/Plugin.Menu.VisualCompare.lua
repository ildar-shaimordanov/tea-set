--[[

DESCRIPTION
-----------

Wrapper over the plugin Visual Compare. The script expects two items of 
the same names are located on both panels and compares them by calling the 
plugin by its GUID. Usage of the script guarantees that the plugin's 
panels will be placed in the same order as the original FAR panels. 

INSTALLATION
------------

1. Put the script to the lua modules location:

%FARPROFILE%\Macros\modules

2. Create the following item in the Main Menu (launched by pressing F2): 

:  Visual Compare
    lua:@"%FARPROFILE%\Macros\modules\Plugin.Menu.VisualCompare.lua"

REQUIREMENTS
------------

The script was developed and tested within the following environment (it's 
assumed the later versions are compatible): 

Far Manager v3.0 build 4040
http://www.farmanager.com/download.php

Visual Compare plugin 1.16 and higher by Maxim Rusov
http://plugring.farmanager.com/plugin.php?pid=856

]]

-- http://forum.farmanager.com/viewtopic.php?f=15&t=9109

local guid = "AF4DAB38-C00A-4653-900E-7A8230308010";

if not Plugin.Exist(guid) then return end;

-- the item on the active panel
local curr = APanel.Current;

-- the same item on the passive panel (panelType=1)
if Panel.FExist(1, curr) == 0 then return end;

-- avoid pointing to the upper level directory
if curr == '..' then curr = '' end;

local lp = APanel.Left and APanel or PPanel;
local rp = APanel.Left and PPanel or APanel;

local lfile = lp.Path .. "\\" .. curr;
local rfile = rp.Path .. "\\" .. curr;

Plugin.Command(guid, '"' .. lfile .. '" "' .. rfile .. '"');

-- EOF
