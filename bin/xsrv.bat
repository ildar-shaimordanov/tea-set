@echo off

for /d %%d in (
	"%~dp0..\vendors\xsrv"
	"%~dp0..\vendors\VcXsrv*"
	"%~dp0..\vendors\Xming*"
) do if exist "%%~d" for %%n in (
	vcxsrv Xming
) do if exist "%%~d\%%~n.exe" (
	start "" "%%~d\%%~n.exe" :0 -multiwindow -clipboard
	goto :EOF
)
