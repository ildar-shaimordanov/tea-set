
-- Modification of the original script taken from:
-- https://code.google.com/p/farmanager/source/browse/trunk/addons/Macros/View.PgDn.lua

--[[

"Умная" прокрутка с помощью PgDn. При прокрутке клавишей PgDn по 
достижении конца файла на экране отображаются все последние строки файла в 
соответствии с текущей высотой окна Far Manager. 

]]

Macro {
	area = "Viewer QView";
	key = "PgDn";
	description = "Viewer: Smart scrolling using PgDn";
	action = function()
		Keys("PgDn");
		if Object.Eof then
			Keys('End')
		end
	end;
}
