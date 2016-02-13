@echo off

call "%~dp0vendors\clink\clink.bat" inject --quiet --profile "%~dp0etc\clink"

if exist "%~dp0shellenv.bat" call "%~dp0shellenv.bat"

:: Integrate Git into prompt
prompt $p$s{git}$_$g$s
