@echo off

set "CLINK_NAME=clink"

if exist "%~dp0libexec\identify.bat" call "%~dp0libexec\identify.bat" app clink

if exist "%~dp0shellenv.bat" call "%~dp0shellenv.bat"
set "HOME=%~dp0home"

if not defined CLINK_NAME goto :EOF
if not exist "%~dp0libexec\%CLINK_NAME%\clink.bat" goto :EOF

:: ========================================================================

:: Inject clink
call "%~dp0libexec\%CLINK_NAME%\clink.bat" inject --quiet --profile "%~dp0etc\clink"

:: ========================================================================

:: EOF
