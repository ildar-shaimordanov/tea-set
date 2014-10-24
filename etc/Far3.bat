@echo off

if /i "%~1" == "/N" (
	set "FARNAME=%~2"
	shift
	shift
)

if not defined FARNAME set "FARNAME=Far3"

set "FARHOME=%~dp0..\vendors\%FARNAME%"

if not exist "%FARHOME%" (
	call :error "%FARHOME% not found"
	goto :EOF
)

if not exist "%FARHOME%\Far.exe" (
	call :error "%FARHOME%\Far.exe not found"
	goto :EOF
)

:: Path to the common directory for all FAR-related stuffs
:: It can be redeclared in "cmd.env.bat"
set "FARCONF=%~dp0Far3"

:: FAR startup options
:: It can be redeclared in "cmd.env.bat"
set "FAROPTS=/w"

if exist "%~dp0cmd.env.bat" call "%~dp0cmd.env.bat"

if defined SHOW_BANNER_FAR if exist "%~dp0cmd.banner.bat" (
	for %%b in ( %SHOW_BANNER_FAR% ) do call "%~dp0cmd.banner.bat" %%b
)

if not exist "%FARHOME%\Far.exe.ini" (
	echo:
	echo:*** Copying Far Manager global configuration
	copy /b "%FARCONF%\Far.exe.ini" "%FARHOME%\Far.exe.ini" || (
		call :error "Cannot copy %FARCONF%\Far.exe.ini to %FARHOME%"
		goto :EOF
	)
)

call :conemu_plugin_check

echo:Starting %FARNAME%

"%FARHOME%\Far.exe" %FAROPTS% %1 %2 %3 %4 %5 %6 %7 %8 %9

echo:Terminating...
goto :EOF

:: ========================================================================

:usage
echo:Usage: %~n0 /N FARNAME
goto :EOF

:: ========================================================================

:error
echo:
echo:*** CRITICAL ERROR ***
echo:%~1
echo:
call :usage
pause
goto :EOF

:: ========================================================================

:conemu_plugin_check
if not defined ConEmuDir goto :EOF
if not defined ConEmuBuild goto :EOF

setlocal

set "far_PluginDir=%FARCONF%\Profile\Plugins"
set "far_ConEmuDir=%far_PluginDir%\ConEmu"
set "far_ConEmuFile=%far_ConEmuDir%\ConEmu.dll"
set "far_ConEmuBuild="

set "far_cmd_del=rd /s /q "%far_ConEmuDir%""
set "far_cmd_copy=robocopy "%ConEmuDir%\plugins\ConEmu" "%far_ConEmuDir%" /S /E >nul"

if not exist "%far_ConEmuFile%" (
	echo:
	echo:*** WARNING ***
	echo:No ConEmu plugin found
	echo:
	call :conemu_plugin_copy
	goto :EOF
)

for %%f in ( powershell.exe robocopy.exe ) do if "%%~$PATH:f" == "" (
	echo:
	echo:*** ERROR ***
	echo:%%f not found in PATH. Unable to continue checking.
	echo:
	echo:Copy the folder manually by yourself
	echo:From : "%ConEmuDir%\plugins\ConEmu"
	echo:To   : "%far_ConEmuDir%"
	echo:
	goto :EOF
)

:: How to read ProductVersion by PowerShell
:: http://stackoverflow.com/a/13118517/3627676
for /f "tokens=*" %%b in ( '
	powershell -NoLogo -NoProfile -Command "(Get-Item '%far_ConEmuFile%').VersionInfo.ProductVersion"
' ) do (
	set "far_ConEmuBuild=%%b"
)

if "%ConEmuBuild%" == "%far_ConEmuBuild%" goto :EOF

echo:
echo:*** WARNING ***
echo:The existing plugin does not match the actual version of ConEmu
echo:
echo:ConEmu found    : %far_ConEmuBuild%
echo:ConEmu required : %ConEmuBuild%
echo:
echo:Using of another version of ConEmu can cause errors
echo:It is extremely recommended to update the plugin for Far Manager
echo:

:: How to check if file is locked
:: http://stackoverflow.com/a/24994480/3627676
powershell -NoLogo -NoProfile -Command "try { [IO.File]::OpenWrite('%far_ConEmuFile%').Close(); } catch { exit 1; }" && call :conemu_plugin_del && call :conemu_plugin_copy && goto :EOF

echo:
echo:Perhaps, the plugin is locked by another application (Far Manager or 
echo:something else). Stop it or unlock the plugin and restart this file 
echo:again. Also you can perform the following commands by yourself:
echo:
echo:%far_cmd_del%
echo:%far_cmd_copy%
echo:

goto :EOF

:: ========================================================================

:conemu_plugin_del
echo:*** Removing incompatible version
%far_cmd_del%
goto :EOF

:: ========================================================================

:conemu_plugin_copy
:: For Robocopy exit codes see the link:
:: http://ss64.com/nt/robocopy-exit.html
echo:*** Copying the actual version
%far_cmd_copy%
if errorlevel 8 goto :EOF
exit /b 0

:: ========================================================================

:: EOF
