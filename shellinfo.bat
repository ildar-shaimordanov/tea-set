:: ========================================================================
::
:: This file is a helper script to show some specific environment 
:: variables such as %PATH% and families %FAR*%, %ConEmu*% and %*HOME%.
::
:: ========================================================================

@echo off

if /i "%~1" == "list" goto :shellinfo_list

if "%~1" == "" (
	echo:Show the actual environment ^(variables and/or aliases^)
	echo:
	echo:Usage:
	echo:%~n0 PATTERN ...
	echo:
	echo:Available patterns:
	call :shellinfo_list

	goto :EOF
)

:shellinfo_loop_1
if "%~1" == "" goto :EOF

for /f %%m in ( '"%~f0" list' ) do if /i "%~1" == "%%m" call :shellinfo.%%m & echo:
shift /1

goto :shellinfo_loop_1

:: ========================================================================

:shellinfo_list
for /f "tokens=2 delims=." %%p in ( 'findstr /i /b ":shellinfo\." "%~f0"' ) do echo:%%~p
goto :EOF

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
