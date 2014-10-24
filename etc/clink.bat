@echo off

"%~dp0..\vendors\clink\clink_x%PROCESSOR_ARCHITECTURE:~-2%.exe" inject --quiet --profile "%~dp0clink"

if exist "%~dp0cmd.env.bat" call "%~dp0cmd.env.bat"
