@echo off

set "CLINK_NAME=clink"

if exist "%~dp0vendors\identify.bat" call "%~dp0vendors\identify.bat" app clink

if exist "%~dp0shellenv.bat" call "%~dp0shellenv.bat"
set "HOME=%~dp0home"

if not defined CLINK_NAME goto :EOF
if not exist "%~dp0vendors\%CLINK_NAME%\clink.bat" goto :EOF

:: ========================================================================

:: Inject clink
call "%~dp0vendors\%CLINK_NAME%\clink.bat" inject --quiet --profile "%~dp0etc\clink"

:: Integrate Git into prompt
prompt $p$s{git}$_$g$s

:: ========================================================================

:: EOF
