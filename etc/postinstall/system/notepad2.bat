@echo off

setlocal

set "v_key=HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\notepad.exe"

set "v_app="
for /f "tokens=*" %%f in ( "%~dp0..\..\..\vendors\notepad2\Notepad2.exe" ) do set "v_app=%%~ff"

if not defined v_app (
	echo:Notepad2 not found at "%~dp0..\..\..\vendors\notepad2\Notepad2.exe"
	goto :EOF
)

if /i "%~1" == "/install"   reg add    "%v_key%" /v "Debugger" /t REG_SZ /d "\"%v_app%\" /z" /f
if /i "%~1" == "/uninstall" reg delete "%v_key%" /f

reg query "%v_key%"

endlocal
goto :EOF

