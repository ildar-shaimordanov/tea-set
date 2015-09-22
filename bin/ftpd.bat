@echo off

setlocal

set "FTP_HOME=%~dp0..\vendors\FTP"
set "FTP_NAME=FileZilla Server.exe"
set "FTP_CONF=FileZilla Server.xml"
set "FTP_CTRL=FileZilla Server Interface.exe"

if /i "%~1" == "start" call :prepare-dirs
if /i "%~1" == "compat-start" call :prepare-dirs

for %%a in ( install uninstall start stop ) do if /i "%~1" == "%%~a" (
	"%FTP_HOME%\%FTP_NAME%" /%%~a
	endlocal
	goto :EOF

)

for %%a in ( start stop ) do if /i "%~1" == "compat-%%~a" (
	start "" "%FTP_HOME%\%FTP_NAME%" /compat /%%~a
	endlocal
	goto :EOF

)

if /i "%~1" == "status" (
	echo:Service
	wmic Service WHERE "Name = '%FTP_NAME%'" get Name,State /value | findstr "."
	echo:
	echo:Process
	tasklist /fi "IMAGENAME EQ %FTP_NAME%" /fo list
	endlocal
	goto :EOF
)

if /i "%~1" == "control" (
	start "" "%FTP_HOME%\%FTP_CTRL%"
	endlocal
	goto :EOF
)


:: More command line arguments
:: https://wiki.filezilla-project.org/Command-line_arguments_%28Server%29
echo:Usage:
echo:	%~n0 INSTALL ^| UNINSTALL
echo:	%~n0 START ^| STOP ^| COMPAT-START ^| COMPAT-STOP
echo:	%~n0 STATUS ^| CONTROL
echo:
echo:INSTALL		install or uninstall the service
echo:UNINSTALL
echo:START		start or stop the server as the service
echo:STOP
echo:COMPAT-START	start or stop the server as the application
echo:COMPAT-STOP
echo:STATUS		check the status of processes and services
echo:CONTROL		launch the controlling client

endlocal
goto :EOF


:prepare-dirs
for /f "tokens=2 delims==>" %%d in ( '
	findstr /i /r /c:"<Permission Dir=\".*\">" "%FTP_HOME%\%FTP_CONF%"
' ) do (
	if exist %%~dd if not exist %%d md %%d
)
goto :EOF

:: EOF
