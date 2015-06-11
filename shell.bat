@echo off

if "%~1" == "" (
	>&2 echo:Shell name required
	goto :shell.failed
)

setlocal

:: Proceed to the specified folder
if not "%~2" == "" pushd "%~2" || goto :EOF

:: Set the shell specific parameters if it is necessary
if exist "%~dp0etc\%~n0\%~1.bat" call "%~dp0etc\%~n0\%~1.bat"

:: Set the home dir
set "HOME=%~dp0home"

:: Check if ConEmu is available
if exist "%~dp0\vendors\ConEmu\ConEmu.exe" if exist "%~dp0etc\ConEmu\%~1.xml" (
	start "%~1 starting" "%~dp0vendors\ConEmu\ConEmu.exe" /LoadCfgFile "%~dp0etc\ConEmu\%~1.xml" /Icon "%~dp0etc\images\%~1.ico"
	goto :EOF
)

if exist "%~dp0\vendors\ConEmu\ConEmu.exe" if exist "%~dp0etc\ConEmu\ConEmu.xml" (
	start "%~1 starting" "%~dp0vendors\ConEmu\ConEmu.exe" /LoadCfgFile "%~dp0etc\ConEmu\ConEmu.xml" /Icon "%~dp0etc\images\ConEmu.ico" /cmd {%~1}
	goto :EOF
)

:: Check if mintty is available
for %%s in ( "bin" "usr\bin" "usr\local\bin" ) do if exist "%~dp0vendors\%~1\%%~s\mintty.exe" (
	start "%~1 starting" "%~dp0vendors\%~1\%%~s\mintty.exe" -c "%HOME%\.minttyrc" -i "%~dp0etc\images\%~1.ico" -
	goto :EOF
)

:: Try naked bash, ksh or sh
for %%s in ( bash ksh sh ) do if exist "%~dp0\vendors\%~1\bin\%%~s.exe" (
	start "%~1 starting" "%~dp0vendors\%~1\bin\%%~s.exe" -l -i
	goto :EOF
)

>&2 echo:Cannot find the specified shell "%~1".

:shell.failed
>&2 pause
exit /b 1

