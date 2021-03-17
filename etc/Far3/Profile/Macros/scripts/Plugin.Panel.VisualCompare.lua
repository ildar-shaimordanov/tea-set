-- https://forum.farmanager.com/viewtopic.php?p=165567#p165567
-----------------------------------------------------------------------------------------
-- Panel.VisualCompare, v1.5, (c) 2014, LanKing.
--
-- 2021/03/17
-- Обновление от siberia-man: дальнейшее развитие скрипта:
-- Возможность указать свой любимый "сравниватель"
-- Вывел основную логику обработки в отдельную функцию
-- Косметические изменения в коде
--
-- 2015/01/26
-- Подправлено fml2: добавлена возможность сравнивать с помощью BeyondCompare
--
-- 2014/12/20
-- Сравнение файлов с помощью плагина Visual Compare с поддержкой Branch панелей

-- Плагин является продвинутой версией плагина от AleXH, переписанного LanKing
-- Пофикшены некоторые баги, добавлены дополнительные условия и дополнения по интерфейсу
-- В разработке также использовались наработки SimSU (локализация)


-- Варианты работы:
-- 1. На активной панели выделено 2 файла или 2 директории - сравнить их
-- 2. На обоих панелях выделено по 1 файлу - сравнить их
-- 3. Иные случаи: Курсор на обеих панелях на файлах: Если пути не одинаковые, сравнить их;
-- 4. Если в предидущем пункте пути одинаковые -- запустить меню плагина;

-- Также если попытаться сравнить файл и папку, что невозможно: будет выведено сообщение
-- об ошибке с предложением стандартного диалога Visual Compare

-----------------------------------------------------------------------------------------

-- External application parameters
--local ExtComp = "BCompare"
--local ExtCompOpts = ""

--local ExtComp = "ExamDiff"
--local ExtCompOpts = "/t"

local ExtComp = "WinMergeU"
local ExtCompOpts = ""

---------------------------------------------------------------------------

-- Hotkeys to launch VisualCompare and external tool

local hotkeys = {
	VisComp = "Ctrl/";
	ExtComp = "CtrlShift/";
}

---------------------------------------------------------------------------

---- Локализация
_G.far.lang = far.lang or win.GetEnv("farlang")

-- Встроенные языки / Buildin laguages
local function Messages()
	if far.lang == "Russian" then
		return {
			Description = "Сравнение 2 выделенных файлов/каталогов (VisualCompare)";
			DescriptionAlt = "Сравнение 2 выделенных файлов/каталогов ("..ExtComp..")";
			MsgSameFiles = "Visual Compare: Обнаружены одинаковые объекты.";
			MsgStandartDlg = 'Запустить стандартный диалог сравнения?';
			MsgDifferent = "Visual Compare: Невозможно сравнить файл и папку";
		}
	else
		return{
			Description = "Compare files/dirs with VisualCompare";
			DescriptionAlt = "Compare files/dirs with "..ExtComp.."";
			MsgSameFiles = "Visual Compare: Objects are equal.";
			MsgStandartDlg = 'Start standart compare dialog?';
			MsgDifferent = "Visual Compare: Can't compare file and folder";
		}
	end;
end;

local M = Messages();

---------------------------------------------------------------------------

local VisComp = "AF4DAB38-C00A-4653-900E-7A8230308010"

---------------------------------------------------------------------------

local function getNamesToCompare()
	-- Can't compare file and folder message
	local function badattr(f1, f2)
		if msgbox(M.MsgDifferent, "\n"..f1.."\n"..f2.."\n\n"..M.MsgStandartDlg.."\n\n", 0x00040000) == 1 then Plugin.Menu(VisComp) end;
		return false;
	end;

	local AP, PP, AC, PC, fn, attrChecked = APanel.Path0, PPanel.Path0, APanel.Current, PPanel.Current ,"", false

	-- 2 files on active panel
	if APanel.SelCount == 2 then
		PP, AC, PC = AP, panel.GetSelectedPanelItem(nil, 1, 1), panel.GetSelectedPanelItem(nil, 1, 2)

		if mf.index(AC.FileAttributes, 'd') ~= mf.index(PC.FileAttributes, 'd') then return badattr(AC.FileName, PC.FileName, true); end;
		AC, PC, attrChecked = AC.FileName, PC.FileName, true

	-- selected one file on active and one on passive
	elseif APanel.SelCount == 1 and PPanel.SelCount == 1 then
		AC, PC = panel.GetSelectedPanelItem(nil, 1, 1), panel.GetSelectedPanelItem(nil, 0, 1)

		if mf.index(AC.FileAttributes, 'd') ~= mf.index(PC.FileAttributes, 'd') then return badattr(AC.FileName, PC.FileName, true); end;
		AC, PC, attrChecked = AC.FileName, PC.FileName, true
	end

	if AC:match("^[A-Z]:") then AP = AC elseif AP == "" then AP = "\\" elseif AC ~= ".." then AP = AP.."\\"..AC end
	if PC:match("^[A-Z]:") then PP = PC elseif PP == "" then PP = "\\" elseif PC ~= ".." then PP = PP.."\\"..PC end -- тут может быть условие для ..

	if (not attrChecked and not APanel.Folder == PPanel.Folder) then return badattr(AP, PP); end;

	if AP == PP then
		if msgbox(M.MsgSameFiles, "\n"..AP.."\n\n"..M.MsgStandartDlg.."\n\n", 0x00040000) == 1 then Plugin.Menu(VisComp) end;
	else
		if (APanel.SelCount ~= 2 and not APanel.Left) then fn = PP..'" "'..AP else fn = AP..'" "'..PP end
		return '"'..fn..'"';
	end
end;

---------------------------------------------------------------------------

local function callCompare(mode)
	local fn = getNamesToCompare()
	if fn == false then return false; end;

	if mode == 0 then
		Plugin.Command(VisComp, fn)
	else
		win.system(ExtComp..' '..ExtCompOpts..' '..fn)
	end
end

---------------------------------------------------------------------------

Macro {
	description = M.Description;
	area = "Shell Tree";
	key = hotkeys.VisComp;
	action = function()
		callCompare(0)
	end
}

Macro {
	description = M.DescriptionAlt;
	area = "Shell Tree";
	key = hotkeys.ExtComp;
	action = function()
		callCompare(1)
	end
}

---------------------------------------------------------------------------

-- EOF
