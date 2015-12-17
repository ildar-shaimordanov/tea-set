:: ========================================================================
::
:: This file is a helper script to show some specific environment 
:: variables such as %PATH% and families %FAR*%, %ConEmu*% and %*HOME%.
::
:: ========================================================================

@echo off

setlocal

set "shellinfo.list=set path doskey alias home conemu far"

if "%~1" == "" (
	echo:Show the actual environment ^(variables and/or aliases^)
	echo:
	echo:Usage:
	echo:%~n0 PATTERN ...
	echo:
	echo:Available patterns:
	echo:%shellinfo.list%

	goto :EOF
)

:shellinfo.loop_1
if "%~1" == "" goto :EOF

for %%m in ( %shellinfo.list% ) do if /i "%~1" == "%%m" call :shellinfo.%%m & echo:
shift /1

goto :shellinfo.loop_1

:: ========================================================================

:shellinfo.set
set
goto :EOF

:shellinfo.path
for %%a in ( "%PATH:;=" "%" ) do echo:%%~a
goto :EOF

:shellinfo.doskey
:shellinfo.alias
doskey /macros
goto :EOF

:shellinfo.home
set | findstr /i /b "[^=]*HOME="
goto :EOF

:shellinfo.conemu
set | findstr /i /b "ConEmu"
goto :EOF

:shellinfo.far
set | findstr /i /b "FAR"
goto :EOF

:: ========================================================================

:: EOF
