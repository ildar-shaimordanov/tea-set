@echo off

setlocal

:: Proceed to the specified folder
if not "%~1" == "" pushd "%~1" || goto :EOF

:: Run in the specified directory
set "CHERE_INVOKING=%CD%"

:: Set the home dir
set "HOME=%~dp0home"

if exist "%~dp0vendors\%~n0\bin\mintty.exe" goto start.mintty
if exist "%~dp0vendors\%~n0\bin\bash.exe"   goto start.bash

:start.failed
echo:Cannot find the shell binary -- aborting.
pause
goto :EOF

:start.mintty
start "%~n0 starting" "%~dp0vendors\%~n0\bin\mintty.exe" -c "%HOME%\.minttyrc" -i "%~dp0etc\images\%~n0-Terminal.ico" -
::start "%~n0 starting" "%~dp0vendors\%~n0\bin\mintty.exe" -c "%HOME%\.minttyrc" -i "%~dp0etc\images\%~n0-Terminal.ico" -h start "%~dp0vendors\%~n0\bin\bash.exe" -l -i
goto :EOF

:start.bash
start "%~n0 starting" "%~dp0vendors\%~n0\bin\bash.exe" -l -i
goto :EOF

