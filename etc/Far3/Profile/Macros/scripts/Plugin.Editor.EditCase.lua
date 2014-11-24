
-- http://forum.farmanager.com/viewtopic.php?f=60&t=9174

local map = {
	['L'] = 0, -- CtrlAltL: Lower  0 - lower case   
	['T'] = 1, -- CtrlAltT: Title  1 - Title Case   
	['U'] = 2, -- CtrlAltU: Upper  2 - UPPER CASE   
	['G'] = 3, -- CtrlAltG: Toggle 3 - tOGGLE cASE  
	['C'] = 4, -- CtrlAltC: Cyclic 4 - Cyclic change
};

Macro {
	area = "Editor";
	key = "/F4|[LR]Ctrl[LR]Alt[LTUGC]/";
	description = "Editor: Edit Case";
	action = function()
		local K = akey(1);
		if K == 'F4' then
			Plugin.Call('0E92FC81-4888-4297-A85D-31C79E0E0CEE');
			return;
		end;

		local V = K:sub(8);

		Plugin.Call( '0E92FC81-4888-4297-A85D-31C79E0E0CEE', map[V] );
	end
}
