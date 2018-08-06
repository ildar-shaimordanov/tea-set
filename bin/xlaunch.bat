@echo off

for /d %%d in (
	"%~dp0..\vendors\xsrv"
	"%~dp0..\vendors\VcXsrv*"
	"%~dp0..\vendors\Xming*"
) do if exist "%%~d" for %%n in (
	XLaunch
) do if exist "%%~d\%%~n.exe" (
	start "" "%%~d\XLaunch.exe" -run "%~dp0..\etc\misc\xsrv\xsrv-multiwindow.xlaunch"
	goto :EOF
)
