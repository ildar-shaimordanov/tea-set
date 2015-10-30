0</*! ::
@echo off

if "%~1" == "" (
	>&2 echo:Shell name required
	goto :shell.failed
)

setlocal

:: Proceed to the specified folder
if not "%~2" == "" pushd "%~2" || goto :EOF

:: Set the shell specific parameters if it is necessary
set "SHELL_RUNNER="

if exist "%~dp0etc\%~n0\%~1.bat" call "%~dp0etc\%~n0\%~1.bat"

:: Set the home dir
set "HOME=%~dp0home"

:: Check if specific runner exists
if defined SHELL_RUNNER if exist "%~dp0vendors\%~1\%SHELL_RUNNER%" (
	start "%~1 starting" "%~dp0vendors\%~1\%SHELL_RUNNER%"
	goto :EOF
)

:: Check if ConEmu is available
if exist "%~dp0vendors\ConEmu\ConEmu.exe" (
	call :conemu FILE "%~1" && goto :EOF
	call :conemu CONF "%~1" && goto :EOF
	call :conemu TASK "%~1" && goto :EOF
)

:: Check if mintty is available
for %%s in ( "bin" "usr\bin" "usr\local\bin" ) do (
	call :mintty "%~1" "%%~s" && goto :EOF
)

:: Try naked bash, ksh or sh
for %%s in ( bash ksh sh ) do if exist "%~dp0vendors\%~1\bin\%%~s.exe" (
	start "%~1 starting" "%~dp0vendors\%~1\bin\%%~s.exe" -l -i
	goto :EOF
)

>&2 echo:Cannot find the specified shell "%~1".


:shell.failed
>&2 pause
exit /b 1


:mintty
setlocal

set "mintty_bin=%~dp0vendors\%~1\%~2\mintty.exe"

if not exist "%mintty_bin%" (
	endlocal
	exit /b 1
)

if not exist "%HOME%\.minttyrc" if exist "%~dp0etc\mintty\default.settings" (
	copy /b "%~dp0etc\mintty\default.settings" "%HOME%\.minttyrc"
)

set "mintty_args=-c "%HOME%\.minttyrc""

if exist "%~dp0etc\images\%~1.ico" (
	set "mintty_args=%mintty_args% -i "%~dp0etc\images\%~1.ico""
)

endlocal && start "%~1 starting" "%mintty_bin%" %mintty_args% /%~2/bash --login -i
goto :EOF


:conemu
setlocal

if "%~1" == "FILE" (
	set "conemu_cfgfile=%~dp0etc\ConEmu\%~2.xml"
) else (
	set "conemu_cfgfile=%~dp0etc\ConEmu\ConEmu.xml"
)

if not exist "%conemu_cfgfile%" (
	endlocal
	exit /b 1
)

cscript //nologo //e:javascript "%~f0" "%conemu_cfgfile%" %* || (
	endlocal
	exit /b 1
)

set "ConEmuArgs=/LoadCfgFile "%conemu_cfgfile%""
if exist "%~dp0etc\images\%~2.ico" (
	set "ConEmuArgs=%ConEmuArgs% /Icon "%~dp0etc\images\%~2.ico""
) else if exist "%~dp0etc\images\ConEmu.ico" (
	set "ConEmuArgs=%ConEmuArgs% /Icon "%~dp0etc\images\ConEmu.ico""
)

if "%~1" == "CONF" (
	set "ConEmuArgs=%ConEmuArgs% /Config "%~2""
) else if "%~1" == "TASK" (
	set "ConEmuArgs=%ConEmuArgs% /Cmd "{%~2}""
)

endlocal && start "%~2 starting" "%~dp0vendors\ConEmu\ConEmu.exe" %ConEmuArgs%
goto :EOF

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
