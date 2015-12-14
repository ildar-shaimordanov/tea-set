@echo off

if exist "%~dp0vendors\clink\clink_x%PROCESSOR_ARCHITECTURE:~-2%.exe" "%~dp0vendors\clink\clink_x%PROCESSOR_ARCHITECTURE:~-2%.exe" inject --quiet --profile "%~dp0etc\clink"

if exist "%~dp0shellenv.bat" call "%~dp0shellenv.bat"

:: Integrate Git into prompt
prompt $p$s{git}$_$g$s
