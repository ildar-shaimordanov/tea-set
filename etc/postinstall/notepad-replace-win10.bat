:: http://www.flos-freeware.ch/doc/notepad2-Replacement.html
:: https://github.com/rizonesoft/Notepad3/issues/3742

@echo off

setlocal

set "np_registry=HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\notepad.exe"

for %%n in ( install uninstall show ) do if /i "%~1" == "%%~n" goto :np_%%~n

echo:Usage: %~n0 install ^| uninstall ^| show>&2

endlocal
goto :EOF


:np_setup
set "np_fullpath="
for %%f in (
	"%~dp0..\..\opt\notepad3\Notepad3.exe"
	"%~dp0..\..\opt\notepad\Notepad3.exe"
	"%~dp0..\..\GUI\notepad3\Notepad3.exe"
	"%~dp0..\..\GUI\notepad\Notepad3.exe"
	"%~dp0..\..\libexec\notepad3\Notepad3.exe"
	"%~dp0..\..\libexec\notepad\Notepad3.exe"
) do if exist "%%~ff" (
	set "np_fullpath=%%~ff"
	goto :EOF
)
echo:Notepad replacement not found>&2
exit /b 1


:np_install
call :np_setup || goto :EOF

reg add "%np_registry%" /v "Debugger" /t REG_SZ /d "\"%np_fullpath%\" /z" /f
goto :EOF


:np_uninstall
reg delete "%np_registry%" /v "Debugger" /f
goto :EOF


:np_show
reg query "%np_registry%" /s
goto :EOF

