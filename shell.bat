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
if exist "%~dp0etc\%~n0\%~1.bat" call "%~dp0etc\%~n0\%~1.bat"

:: Set the home dir
set "HOME=%~dp0home"

:: Check if ConEmu is available
if exist "%~dp0vendors\ConEmu\ConEmu.exe" if exist "%~dp0etc\ConEmu\%~1.xml" (
	call :conemu.check.config "%~dp0etc\ConEmu\%~1.xml" && (
		start "%~1 starting" "%~dp0vendors\ConEmu\ConEmu.exe" /LoadCfgFile "%~dp0etc\ConEmu\%~1.xml" /Icon "%~dp0etc\images\%~1.ico"
		goto :EOF
	)
)

if exist "%~dp0vendors\ConEmu\ConEmu.exe" if exist "%~dp0etc\ConEmu\ConEmu.xml" (
	call :conemu.check.config "%~dp0etc\ConEmu\ConEmu.xml" "/confname:%~1" && (
		start "%~1 starting" "%~dp0vendors\ConEmu\ConEmu.exe" /LoadCfgFile "%~dp0etc\ConEmu\ConEmu.xml" /Icon "%~dp0etc\images\ConEmu.ico" /Config "%~1"
		goto :EOF
	)
	call :conemu.check.config "%~dp0etc\ConEmu\ConEmu.xml" "/taskname:%~1" && (
		start "%~1 starting" "%~dp0vendors\ConEmu\ConEmu.exe" /LoadCfgFile "%~dp0etc\ConEmu\ConEmu.xml" /Icon "%~dp0etc\images\ConEmu.ico" /Cmd "{%~1}"
		goto :EOF
	)
)

:: Check if git-bash launcher is available
if exist "%~dp0vendors\%~1\git-bash.exe" (
	start "%~1 starting" "%~dp0vendors\%~1\git-bash.exe"
	goto :EOF
)

:: Check if mintty is available
for %%s in ( "bin" "usr\bin" "usr\local\bin" ) do if exist "%~dp0vendors\%~1\%%~s\mintty.exe" (
	start "%~1 starting" "%~dp0vendors\%~1\%%~s\mintty.exe" -c "%HOME%\.minttyrc" -i "%~dp0etc\images\%~1.ico" /%%~s/bash --login -i
	goto :EOF
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

:conemu.check.config
cscript //nologo //e:javascript "%~f0" %*
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

if ( WScript.Arguments.Unnamed.length == 0 ) {
	alert('Usage: ' + WScript.ScriptName + ' filename options');
	exit(1);
}

var filename = WScript.Arguments.Unnamed.item(0);
var confname = WScript.Arguments.Named.item('CONFNAME') || '.Vanilla';
var taskname = WScript.Arguments.Named.item('TASKNAME') || '';

var xpathstr = '/key[@name="Software"]/key[@name="ConEmu"]' 
	+ '/key[lower-case(@name)=lower-case("' + confname + '")]' 
	+ '/key[@name="Tasks"]/key';

if ( taskname ) {
	xpathstr += '/value[@name="Name"][lower-case(@data)=lower-case("{' + taskname + '}")]';
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
