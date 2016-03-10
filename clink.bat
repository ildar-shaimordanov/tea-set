@echo off

set "CLINK_NAME=clink"

if exist "%~dp0vendors\clink.bat" call "%~dp0vendors\clink.bat"

if not defined CLINK_NAME goto :continue
if not exist "%~dp0vendors\%CLINK_NAME%\clink.bat" goto :continue

:: ========================================================================

:: Inject clink
call "%~dp0vendors\%CLINK_NAME%\clink.bat" inject --quiet --profile "%~dp0etc\clink"

:: Integrate Git into prompt
prompt $p$s{git}$_$g$s

:: ========================================================================

:continue
if exist "%~dp0shellenv.bat" call "%~dp0shellenv.bat"

:: ========================================================================

:: EOF
