0</*! ::
@echo off

if "%~1" == "" (
	>&2 echo:Shell name required
	goto :shell.failed
)

setlocal

:: Proceed to the specified folder
if not "%~2" == "" pushd "%~2" || goto :EOF

:: Set the home dir
set "HOME=%~dp0home"

:: Set the environment specific for this shell/terminal
if exist "%~dp0etc\%~n0\%~1.bat" call "%~dp0etc\%~n0\%~1.bat"

:: ========================================================================

set "SHELL_NAME=%~1"
set "SHELL_ARGS="

if exist "%~dp0vendors\%~1.bat" call "%~dp0vendors\%~1.bat"

:: ========================================================================

:: Check if there is git-bash
if defined SHELL_NAME if exist "%~dp0vendors\%SHELL_NAME%\git-bash.exe" (
	call :shell.git-bash.prepare "%~1"
	call :shell.start "%~1" "git-bash.exe"
	goto :EOF
)

:: ========================================================================

:: Check if there is mintty
if defined SHELL_NAME for %%s in (
	bin
	usr\bin
	usr\local\bin
) do if exist "%~dp0vendors\%SHELL_NAME%\%%s\mintty.exe" (
	call :shell.mintty.prepare "%~1" %%s
	call :shell.start "%~1" "%%s\mintty.exe"
	goto :EOF
)

:: ========================================================================

:: Check if ConEmu is available
set "SHELL_NAME=ConEmu"
set "SHELL_ARGS="

if exist "%~dp0vendors\ConEmu.bat" call "%~dp0vendors\ConEmu.bat"

if defined SHELL_NAME if exist "%~dp0vendors\%SHELL_NAME%\ConEmu.exe" (
	call :shell.conemu.prepare "%~1" && (
		call :shell.start "%~1" "ConEmu.exe"
		goto :EOF
	)
)

:: ========================================================================

:: Check if ConsoleZ is available
set "SHELL_NAME=ConsoleZ"
set "SHELL_ARGS="

if exist "%~dp0vendors\ConsoleZ.bat" call "%~dp0vendors\ConsoleZ.bat"

if defined SHELL_NAME if exist "%~dp0vendors\%SHELL_NAME%\Console.exe" (
	call :shell.consolez.prepare "%~1" && (
		call :shell.start "%~1" "Console.exe"
		goto :EOF
	)
)

:: ========================================================================

set "SHELL_NAME=%~1"
set "SHELL_ARGS=-l -i"

:: Try bare bash, ksh or sh
for %%s in ( 
	bash
	ksh
	sh
) do if exist "%~dp0vendors\%SHELL_NAME%\bin\%%~s.exe" (
	call :shell.start "%~1" "bin\%%~s.exe"
	goto :EOF
)

:: ========================================================================

>&2 echo:Cannot find the specified shell "%~1".

:shell.failed
>&2 pause
exit /b 1

:: ========================================================================

:shell.start
start "Starting %~1 (%SHELL_NAME%)" "%~dp0vendors\%SHELL_NAME%\%~2" %SHELL_ARGS%
goto :EOF

:: ========================================================================

:shell.git-bash.prepare
goto :EOF

:: ========================================================================

:shell.bare.prepare
set "SHELL_ARGS=--login -i"
goto :EOF

:: ========================================================================

:shell.mintty.prepare
if not exist "%HOME%\.minttyrc" if exist "%~dp0etc\mintty\default.settings" (
	copy /b "%~dp0etc\mintty\default.settings" "%HOME%\.minttyrc"
)

set "SHELL_ARGS=-c "%HOME%\.minttyrc""

if exist "%~dp0etc\images\%~1.ico" (
	set "SHELL_ARGS=%SHELL_ARGS% -i "%~dp0etc\images\%~1.ico""
)

set "SHELL_ARGS=%SHELL_ARGS% /%~2/bash --login -i"
goto :EOF

:: ========================================================================

:shell.consolez.prepare
if not exist "%~dp0etc\ConsoleZ\%~1.xml" exit /b 1
set "SHELL_ARGS=-c "%~dp0etc\ConsoleZ\%~1.xml" -t "%~1""
goto :EOF

:: ========================================================================

:shell.conemu.prepare
call :shell.conemu.prepare.args FILE "%~1" && goto :EOF
call :shell.conemu.prepare.args CONF "%~1" && goto :EOF
call :shell.conemu.prepare.args TASK "%~1" && goto :EOF
goto :EOF

:shell.conemu.prepare.args
if "%~1" == "FILE" (
	set "SHELL_ARGS=%~dp0etc\ConEmu\%~2.xml"
) else (
	set "SHELL_ARGS=%~dp0etc\ConEmu\ConEmu.xml"
)

if not exist "%SHELL_ARGS%" (
	endlocal
	exit /b 1
)

cscript //nologo //e:javascript "%~f0" "%SHELL_ARGS%" %* || (
	endlocal
	exit /b 1
)

set "SHELL_ARGS=/LoadCfgFile "%SHELL_ARGS%""
if exist "%~dp0etc\images\%~2.ico" (
	set "SHELL_ARGS=%SHELL_ARGS% /Icon "%~dp0etc\images\%~2.ico""
) else if exist "%~dp0etc\images\ConEmu.ico" (
	set "SHELL_ARGS=%SHELL_ARGS% /Icon "%~dp0etc\images\ConEmu.ico""
)

if "%~1" == "CONF" (
	set "SHELL_ARGS=%SHELL_ARGS% /Config "%~2""
) else if "%~1" == "TASK" (
	set "SHELL_ARGS=%SHELL_ARGS% /Cmd "{%~2}""
)

goto :EOF

:: ========================================================================

*/0;

var alert = alert || function(msg)
{
	WScript.Echo(msg);
};

var exit = exit || function(exitCode)
{
	WScript.Quit(exitCode);
};

if ( WScript.Arguments.length != 3 ) {
	alert('Usage: ' + WScript.ScriptName + ' filename options');
	exit(1);
}

var filename = WScript.Arguments.item(0);

var ctrl = WScript.Arguments.item(1);
var name = WScript.Arguments.item(2);

var xpathstr = '/key[@name="Software"]/key[@name="ConEmu"]' 
	+ '/key[lower-case(@name)=lower-case("' + ( ctrl == 'CONF' ? name : '.Vanilla' ) + '")]' 
	+ '/key[@name="Tasks"]/key';

if ( ctrl == 'TASK' ) {
	xpathstr += '/value[@name="Name"][lower-case(@data)=lower-case("{' + name + '}")]';
}

// Comparison in XPath is case sensitive. Using of "lower-case" XPath 
// function could be good solution to escape differencies between "abc",
// "ABC" and so on. Unfortunately, "lower-case" is a part of XPath 2.0 and 
// is not supportable by MS JScript. To resolve this issue we introduce 
// the partial workaround replacement with the function "translate", 
// available in XPath 1.0. 
// See for details: http://stackoverflow.com/a/1625859/3627676
xpathstr = xpathstr.replace(
	/lower-case\(([^()]+)\)/g, 
	'translate($1, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz")'
);

var e;
try {
	var xmldoc = new ActiveXObject('Microsoft.XMLDOM');
	xmldoc.setProperty('SelectionLanguage', 'XPath');
	xmldoc.load(filename);

	var xml = xmldoc.selectNodes(xpathstr);
} catch(e) {
	// If a file or XML are bad, exit with error immediately
	exit(1);
}

exit( xml.length != 0 ? 0 : 1 );
