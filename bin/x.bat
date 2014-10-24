@echo off

if "%~1" == "" (
	echo:Usage:
	echo:    %~n0 progname [arguments]
	echo:    %~n0 /set instance
	echo:    %~n0 /list
	exit /b 1
)

if /i "%~1" == "/list" (
	for /f "tokens=1,* delims=-" %%p in ( 'dir /b /ad "%~dp0..\vendors\x-*"' ) do echo:%%q
	exit /b 0
)

if /i "%~1" == "/set" (
	if not exist "%~dp0..\vendors\x-%~2" (
		echo:Unable to set UNIX_HOME>&2
		exit /b 1
	)
	for %%f in ( "%~dp0..\vendors\x-%~2" ) do set "UNIX_HOME=%%~ff"
	exit /b 0
)

if not defined UNIX_HOME (
	echo:UNIX_HOME not defined>&2
	exit /b 1
)

%UNIX_HOME%\bin\%*
goto :EOF

