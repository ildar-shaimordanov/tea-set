:: http://www.flos-freeware.ch/doc/notepad2-Replacement.html

@echo off

setlocal

set "np_registry=HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\notepad.exe"

if /i "%~1" == "/install"   call :np_add
if /i "%~1" == "/uninstall" call :np_delete

call :np_show

endlocal
goto :EOF


:np_setup
set "np_fullpath="
for %%f in (
	"%~dp0..\..\..\vendors\notepad2-mod\Notepad2.exe"
	"%~dp0..\..\..\vendors\notepad2\Notepad2.exe"
) do if exist "%%~ff" (
	set "np_fullpath=%%~ff"
	goto :EOF
)
echo:Notepad2 not found>&2
exit /b 1


:np_add
call :np_setup || goto :EOF

reg add "%np_registry%" /v "Debugger" /t REG_SZ /d "\"%np_fullpath%\" /z" /f
goto :EOF


:np_delete
reg delete "%np_registry%" /f
goto :EOF


:np_show
reg query "%np_registry%"
goto :EOF

