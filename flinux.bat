@echo off

setlocal

pushd "%~dp0vendors\flinux-0.21-archlinux\archlinux"
..\flinux /bin/bash

endlocal
goto :EOF
