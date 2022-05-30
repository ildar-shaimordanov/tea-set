@echo off

setlocal

for %%f in ( "%~dp0..\..\GUI\notepad\Notepad3.exe" ) do set "np_path=%%~ff"

set "np_root=HKEY_CURRENT_USER\Software\Classes"
:: set "np_root=HKEY_CLASSES_ROOT"

set "np_txtid=%np_root%\.txt\OpenWithProgids"

set "np_appid=000000Notepad3"

for %%p in ( install uninstall show ) do if /i "%~1" == "%%~p" goto :np_%%~p

echo:Usage: %~n0 install^|uninstall^|show
goto :EOF

:np_install
:: reg add "%np_txtid%" /v "%np_appid%" /t "REG_SZ" /d " " /f
reg add "%np_txtid%" /v "%np_appid%" /t "REG_NONE" /d "" /f
reg add "%np_root%\%np_appid%\shell\new\command" /ve /t REG_SZ /d "\"%np_path%\" /q \"%%1\"" /f
reg add "%np_root%\%np_appid%\shell\open\command" /ve /t REG_SZ /d "\"%np_path%\" \"%%1\"" /f
goto :EOF

:np_uninstall
reg delete "%np_txtid%" /v "%np_appid%" /f
reg delete "%np_root%\%np_appid%" /f
goto :EOF

:np_show
reg query "%np_txtid%" /s
reg query "%np_root%\%np_appid%" /s
goto :EOF
