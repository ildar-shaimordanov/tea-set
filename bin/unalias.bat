@echo off

if "%~1" == "/?" goto :help
if "%~1" == "-?" goto :help
if "%~1" == "-h" goto :help

doskey %1=
goto :EOF

:help
echo:Removes the associated name from the list of defined macros.
echo:For more details, see DOSKEY /?
echo:
echo:Usage: unalias name
