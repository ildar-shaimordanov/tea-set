@echo off

if /i "%~1" == "/N" (
	set "FAR_NAME=%~2"
	shift /1
	shift /1
)

if not defined FAR_NAME if exist "%~dp0vendors\%~nx0" call "%~dp0vendors\Far3.bat"

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
:: It can be redeclared in "shellenv.bat"
set "FAR_CONF=%~dp0etc\Far3"

:: FAR startup options
:: It can be redeclared in "shellenv.bat"
set "FAR_OPTS=/w /p"%FAR_HOME%\Plugins;%FAR_CONF%\Profile\Plugins;%ConEmuDir%\Plugins\ConEmu""

if exist "%~dp0shellenv.bat" call "%~dp0shellenv.bat"

if defined SHOW_BANNER_FAR if exist "%~dp0shellinfo.bat" call "%~dp0shellinfo.bat" %SHOW_BANNER_FAR%

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

echo:Starting %FAR_NAME%
echo:[ %DATE% %TIME% ]

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
