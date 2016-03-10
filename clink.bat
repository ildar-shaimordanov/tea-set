@echo off

set "CLINK_NAME=clink"

if exist "%~dp0vendors\clink.bat" call "%~dp0vendors\clink.bat"

if defined CLINK_NAME if exist "%~dp0vendors\%CLINK_NAME%\clink.bat" (
	call "%~dp0vendors\%CLINK_NAME%\clink.bat" inject --quiet --profile "%~dp0etc\clink"
)

if exist "%~dp0shellenv.bat" call "%~dp0shellenv.bat"

:: Integrate Git into prompt
prompt $p$s{git}$_$g$s
