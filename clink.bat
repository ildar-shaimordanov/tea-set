@echo off

if exist "%~dp0vendors\clink\clink_x%PROCESSOR_ARCHITECTURE:~-2%.exe" "%~dp0vendors\clink\clink_x%PROCESSOR_ARCHITECTURE:~-2%.exe" inject --quiet --profile "%~dp0etc\clink"

if exist "%~dp0cmd.env.bat" call "%~dp0cmd.env.bat"

:: Integrate Git into prompt
call "%ConEmuBaseDir%\IsConEmu.cmd" >nul && prompt $p$s{git}$_$g$s
