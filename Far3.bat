@echo off

if /i "%~1" == "/N" (
	set "FAR_NAME=%~2"
	shift
	shift
)

if not defined FAR_NAME set "FAR_NAME=Far3"

set "FAR_HOME=%~dp0vendors\%FAR_NAME%"

if not exist "%FAR_HOME%" (
	call :error "%FAR_HOME% not found"
	goto :EOF
)

if not exist "%FAR_HOME%\Far.exe" (
	call :error "%FAR_HOME%\Far.exe not found"
	goto :EOF
)

:: Path to the common directory for all FAR-related stuffs
:: It can be redeclared in "cmd.env.bat"
set "FAR_CONF=%~dp0etc\Far3"

:: FAR startup options
:: It can be redeclared in "cmd.env.bat"
set "FAR_OPTS=/w"

if exist "%~dp0cmd.env.bat" call "%~dp0cmd.env.bat"

if defined SHOW_BANNER_FAR if exist "%~dp0cmd.banner.bat" call "%~dp0cmd.banner.bat" %SHOW_BANNER_FAR%

if not exist "%FAR_HOME%\Far.exe.ini" (
	echo:
	echo:*** Copying Far Manager global configuration
	copy /b "%FAR_CONF%\Far.exe.ini" "%FAR_HOME%\Far.exe.ini" || (
		call :error "Cannot copy %FAR_CONF%\Far.exe.ini to %FAR_HOME%"
		goto :EOF
	)
)

call :conemu_plugin_check

echo:Starting %FAR_NAME%

"%FAR_HOME%\Far.exe" %FAR_OPTS% %1 %2 %3 %4 %5 %6 %7 %8 %9

echo:Terminating...
goto :EOF

:: ========================================================================

:usage
echo:Usage: %~n0 /N FAR_NAME
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

set "far_PluginDir=%FAR_CONF%\Profile\Plugins"
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
