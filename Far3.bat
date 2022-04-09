@echo off

setlocal

set "FAR_NAME=Far3"

if exist "%~dp0libexec\identify.bat" call "%~dp0libexec\identify.bat" app Far3

if defined FAR_NAME if exist "%~dp0libexec\%FAR_NAME%\Far.exe" goto :continue

call :error "Can't identify Far3 by name %FAR_NAME%"
goto :EOF

:: ========================================================================

:continue
set "FAR_HOME=%~dp0libexec\%FAR_NAME%"

:: Path to the common directory for all FAR-related stuffs
set "FAR_CONF=%~dp0etc\Far3"

:: FAR startup options
set "FAR_OPTS=%FAR_HOME%\Plugins;%FAR_CONF%\Profile\Plugins"
if defined ConEmuDir if exist "%ConEmuDir%" set "FAR_OPTS=%FAR_OPTS%;%ConEmuDir%\Plugins\ConEmu"
set "FAR_OPTS=/w /p"%FAR_OPTS%""

if exist "%~dp0shellenv.bat" call "%~dp0shellenv.bat"

if exist "%~dp0shellinfo.bat" call "%~dp0shellinfo.bat" conemu far home path

:: ========================================================================

if not exist "%FAR_HOME%\Far.exe.ini" (
	echo:
	echo:*** "%FAR_HOME%\Far.exe.ini" not found
	if exist "%FAR_CONF%\Far.exe.ini" (
		echo:*** Copying from "%FAR_CONF%\Far.exe.ini"
		copy /b "%FAR_CONF%\Far.exe.ini" "%FAR_HOME%\Far.exe.ini"
	) else (
		echo:*** Creating
		call :far.exe.ini_create >"%FAR_HOME%\Far.exe.ini"
	)
	if errorlevel 1 (
		call :error "Cannot create %FAR_CONF%\Far.exe.ini"
		goto :EOF
	)
)

:: ========================================================================

echo:Starting %FAR_NAME%
echo:[ %DATE% %TIME% ]

"%FAR_HOME%\Far.exe" %FAR_OPTS% %*

echo:Terminating...
goto :EOF

:: ========================================================================

:error
>&2 (
	echo:CRITICAL ERROR: %~1
	pause
)
goto :EOF

:: ========================================================================

:far.exe.ini_create
echo:
echo:[General]
echo:
echo:UseSystemProfiles=0
echo:
echo:UserProfileDir=%%FARHOME%%\..\..\etc\Far3\Profile
echo:UserLocalProfileDir=%%FARHOME%%\..\..\etc\Far3\Profile
echo:
echo:TemplateProfile=%%FARHOME%%\..\..\etc\Far3\Default.farconfig
echo:
echo:GlobalUserMenuDir=%%FARHOME%%\..\..\etc\Far3
echo:
echo:DefaultLanguage=Russian
echo:
echo:ReadOnlyConfig=0
goto :EOF

:: ========================================================================

:: EOF
