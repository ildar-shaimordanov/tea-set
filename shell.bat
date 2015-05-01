@echo off

if "%~1" == "" (
	>&2 echo:Shell name required
	goto :shell.failed
)

setlocal

:: Proceed to the specified folder
if not "%~2" == "" pushd "%~2" || goto :EOF

:: Run in the specified directory
set "CHERE_INVOKING=%CD%"

:: Set the home dir
set "HOME=%~dp0home"

:: Check if ConEmu is available
if exist "%~dp0\vendors\ConEmu\ConEmu.exe" if exist "%~dp0etc\ConEmu\ConEmu.%~1.xml" (
	start "%~1 starting" "%~dp0vendors\ConEmu\ConEmu.exe" /LoadCfgFile "%~dp0etc\ConEmu\ConEmu.%~1.xml" /Icon "%~dp0etc\images\%~1-Terminal.ico" %*
	goto :EOF
)

:: Check if mintty is available
for %%s in ( "bin" "usr\bin" "usr\local\bin" ) do if exist "%~dp0vendors\%~1\%%~s\mintty.exe" (
	start "%~1 starting" "%~dp0vendors\%~1\%%~s\mintty.exe" -c "%HOME%\.minttyrc" -i "%~dp0etc\images\%~1-Terminal.ico" -
	goto :EOF
)

:: Try naked bash, ksh or sh
for %%s in ( bash ksh sh ) do if exist "%~dp0\vendors\%~1\bin\%%~s.exe" (
	start "%~1 starting" "%~dp0vendors\%~1\bin\%%~s.exe" -l -i
	goto :EOF
)

>&2 echo:Cannot find the shell binary -- aborting.

:shell.failed
>&2 pause
exit /b 1

