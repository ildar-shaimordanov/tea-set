:: ========================================================================
::
:: This file is a helper script to show some specific environment 
:: variables such as %PATH% and families %FAR*%, %ConEmu*% and %*HOME%.
::
:: ========================================================================

@echo off

setlocal

set "banner_list=set path doskey alias home conemu far"

if "%~1" == "" (
	echo:Show the actual environment ^(variables and/or aliases^)
	echo:
	echo:Usage:
	echo:%~n0 PATTERN ...
	echo:
	echo:Available patterns:
	echo:%banner_list%

	goto :EOF
)

:banner_loop_1
if "%~1" == "" goto :EOF

for %%m in ( %banner_list% ) do if /i "%~1" == "%%m" call :show_%%m && echo:
shift

goto :banner_loop_1

:: ========================================================================

:show_set
set
goto :EOF

:show_path
for %%a in ( "%PATH:;=" "%" ) do echo:%%~a
goto :EOF

:show_doskey
:show_alias
doskey /macros
goto :EOF

:show_home
set | findstr /i /b "[^=]*HOME="
goto :EOF

:show_conemu
set | findstr /i /b "ConEmu"
goto :EOF

:show_far
set | findstr /i /b "FAR"
goto :EOF

:: ========================================================================

:: EOF
