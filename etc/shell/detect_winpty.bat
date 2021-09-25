::: Usage: detect_winpty ENV BIT
:::
:::   ENV - cygwin or msys
:::   BIT - 32 or 64

@echo off

if "%~1" == "" (
	findstr "^:::" "%~f0"
	goto :EOF
)

for /f "tokens=* delims=" %%n in ( '
	dir /ad /o-n /b "%~dp0..\..\vendors\winpty*%~1*%~2"
' ) do for %%d in ( "%~dp0..\..\vendors\%%~n" ) do if exist "%%~d\bin\winpty.exe" (
	set "PATH=%PATH%;%%~d\bin"
	goto :EOF
)
