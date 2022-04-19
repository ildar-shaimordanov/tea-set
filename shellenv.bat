:: ========================================================================
::
:: This file is a helper script to simplify setting up of the %PATH% and 
:: other needful environment variables.
::
:: ========================================================================

@echo off

:: ========================================================================
::
:: Escape double execution
::
:: ========================================================================

if defined CMD_ENV_LOADED goto :shellenv.integration

set "CMD_ENV_LOADED=1"

:: ========================================================================
::
:: Set up useful aliases
::
:: ========================================================================

doskey alias=if "$1" == "" ( doskey /macros ) else ( doskey $* )
doskey unalias=doskey $1=
doskey shellenv="%~f0"
doskey shellinfo="%~dp0shellinfo.bat" $*

:: ========================================================================
::
:: Tea-Set
::
:: ========================================================================

for /f "tokens=*" %%p in ( "%~dp0." ) do set "TEA_HOME=%%~fp"
set "TEA_HOME=C:\PROGS"
call :shellenv.select.path "%TEA_HOME%"

:: ========================================================================
::
:: Java
::
:: ========================================================================

if exist "%~dp0javaenv.bat" call "%~dp0javaenv.bat"

:: ========================================================================
::
:: Autoloading the rest of tools (for example from %TEA_HOME%\opt)
::
:: ========================================================================

call :shellenv.from.file

:: ========================================================================
::
:: Integration with ConEmu
::
:: ========================================================================

:shellenv.integration

:: reg query "HKCU\Console" /v VirtualTerminalLevel 2>nul | find "0x1" && echo:[99999;1H
if defined ConEmuANSI if /i "%ConEmuANSI%" == "ON" echo:[99999;1H

:: Make ConEmu's environment variables available for child processes
:: if defined ConEmuBaseDir if exist "%ConEmuBaseDir%\IsConEmu.cmd" (
:: 	call "%ConEmuBaseDir%\IsConEmu.cmd" >nul && "%ConEmuBaseDir%\ConEmuC.exe" /export
:: )

:: Colorize the command line prompt 
:: if defined ConEmuBaseDir if exist "%ConEmuBaseDir%\ColorPrompt.cmd" (
:: 	call "%ConEmuBaseDir%\ColorPrompt.cmd"
:: )

:: ========================================================================

goto :EOF

:: ========================================================================

:shellenv.from.file
if not exist "%~dpn0.cfg" goto :EOF

setlocal enabledelayedexpansion

:: This is TAB separated file
for /f "usebackq eol=; tokens=1,2,3,4 delims=	" %%1 in ( "%~dpn0.cfg" ) do (
	if /i "%%~1" == "ROOT" (
		for /f "tokens=*" %%p in ( 'echo:%%~2' ) do set "auto_root=%%~fp"
	) else if /i "%%~1" == "HOME" (
		call :shellenv.set.home "%%~2" "%%~3"
	) else if /i "%%~1" == "DIRS" (
		call :shellenv.set.dirs "!auto_root!\%%~2" "%%~3" "%%~4"
	) else if /i "%%~1" == "DIR" (
		call :shellenv.select.path "!auto_root!\%%~2" "%%~3"
	)
)

endlocal & set "PATH=%PATH%"
goto :EOF

:: ========================================================================

:: This routine sets home name variable (looks like XXX_HOME) to the 
:: directory's path and adds paths to %PATH%. 
::
:: Do nothing, if the home variable is already defined. 
::
:: The routine looks for binaries located in the subdirectories (listed 
:: below) under the home directory and adds them to %PATH% in the case 
:: binaries are found there. 
::
:: Subdirectories are looked for binaries and all of then added to %PATH%: 
:: "bin", "sbin", "usr\bin", ".".
::
:: By default, all the paths are appended to %PATH%. In the case when 
:: paths should to be prepended, use "/P" option.
::
:: %~1 - homedir
:: %~2 - the subdirectories list
:: %~3 - "prepend" for prepending or nothing

:: home prepend
:shellenv.set.home
call :shellenv.set.dirs "%~1" "bin;sbin;usr\bin" "%~2"
goto :EOF

:: ========================================================================

:: root\dir subdirs prepend
:shellenv.set.dirs
if "%~1" == "" goto :EOF
if "%~2" == "" goto :EOF

setlocal enabledelayedexpansion

set "auto_unchecked=%~2"
set "auto_unchecked=%~1\!auto_unchecked:;=;%~1\!"

set "auto_path="
for %%p in ( "%auto_unchecked:;=" "%" ) do (
	call :shellenv.check.path "%%~p" && set "auto_path=!auto_path!;%%~p"
)

if defined auto_path set "auto_path=!auto_path:~1!"

call :shellenv.concat.path "%~3"

endlocal & set "PATH=%PATH%"
goto :EOF

:: ========================================================================

:: The routine looks for binaries located in the subdirectories (listed 
:: below) and adds the first found subdirectory to %PATH%. 
::
:: Subdirectories are looked for binaries and all of then added to %PATH%: 
:: "bin", "usr\bin", "cmd", ".".
::
:: By default, all the paths are appended to %PATH%. In the case when 
:: paths should to be prepended, use "/P" option.
::
:: %~1 - the directory's path
:: %~2 - "prepend" for prepending or nothing

:shellenv.select.path
if "%~1" == "" goto :EOF

for %%p in (
	"%~1\bin"
	"%~1\usr\bin"
	"%~1\cmd"
	"%~1"
) do (
	call :shellenv.check.path "%%~fp" && (
		set "auto_path=%%~fp"
		call :shellenv.concat.path "%~2"
		goto :EOF
	)
)

goto :EOF

:: ========================================================================

:shellenv.check.path
:: Skip if path not exists
if not exist "%~1" exit /b 1

:: Skip if the path is specified in %PATH%
for %%p in ( "%PATH:;=" "%" ) do if /i "%~1" == "%%~p" exit /b 1

:: Skip if no executables in the path
dir /b /a-d "%~1\*.exe" "%~1\*.bat" "%~1\*.cmd" >nul 2>nul
goto :EOF

:: ========================================================================

:shellenv.concat.path
if not defined auto_path goto :EOF

if /i "%~1" == "prepend" (
	set "PATH=%auto_path%;%PATH%"
) else (
	set "PATH=%PATH%;%auto_path%"
)
goto :EOF

:: ========================================================================

:: EOF
