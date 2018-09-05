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

for /f "tokens=*" %%p in ( "%~dp0." ) do call :shellenv.set.home TEA_HOME "%%~fp"

:: ========================================================================
::
:: 7-ZIP
::
:: ========================================================================

call :shellenv.set.home SEVENZIP_HOME "%TEA_HOME%\vendors\7za"

:: ========================================================================
::
:: OpenLDAP
::
:: ========================================================================

call :shellenv.set.home OPENLDAP_HOME "%TEA_HOME%\opt\OpenLDAP"

:: ========================================================================
::
:: IUM Sandbox
::
:: ========================================================================

if exist "C:\IUM\etc\sandbox-release" (
	for /f "usebackq eol=# delims=; tokens=1,2,*" %%a in (
		"C:\IUM\etc\sandbox-release"
	) do if not "%%~a" == "" (
		rem 1. do attempt to assign to the sandbox drive
		call :shellenv.set.home IUM_HOME "%%~a"
	) else if not "%%~b" == "" (
		rem 2. do attempt to assign to the sandbox path
		call :shellenv.set.home IUM_HOME "%%~b"
	)
)

:: ========================================================================
::
:: WWW (WebServers aka D.N.W.R.)
::
:: ========================================================================

call :shellenv.set.home WWW_HOME "%TEA_HOME%\vendors\WWW"

:: ========================================================================
::
:: Unix tools (Cygwin, GoW, GnuWin32, MSysGit, Git_Bash, UnixUtils, Win-Bash etc)
::
:: ========================================================================

set "UNIX_NAME=unxutils"

if exist "%~dp0vendors\identify.bat" call "%~dp0vendors\identify.bat" app Unix

if defined UNIX_NAME call :shellenv.set.home UNIX_HOME "%TEA_HOME%\vendors\%UNIX_NAME%" /P

:: What is the HOME directory?
:: http://gnuwin32.sourceforge.net/faq.html
:: set "HOME=%TEA_HOME%"

:: The program aborts with the message: cannot create file /tmp/...
:: http://gnuwin32.sourceforge.net/faq.html
:: set "TMPDIR=%TEMP%"
:: set "TMP=%TEMP%"

:: How can I disable native language support?
:: http://gnuwin32.sourceforge.net/faq.html
:: set "LANG=en"
:: set "LANGUAGE=en"

:: ========================================================================
::
:: Perl
:: (prepend in PATH to overrride other Perls from other places)
::
:: ========================================================================

set "PERL_NAME=Perl"

if exist "%~dp0vendors\identify.bat" call "%~dp0vendors\identify.bat" app Perl

if defined PERL_NAME set "PERL_HOME=%TEA_HOME%\vendors\%PERL_NAME%"
if defined PERL_NAME for %%f in ( 
	"c" 
	"perl" 
	"perl\site" 
) do call :shellenv.select.path "%PERL_HOME%\%%~f" /P

:: ========================================================================
::
:: VirtualBox
::
:: ========================================================================

call :shellenv.select.path "%ProgramFiles%\Oracle\VirtualBox"

:: ========================================================================
::
:: Java
::
:: ========================================================================

call :shellenv.lookup.jdk
call :shellenv.lookup.jre

if defined JDK_HOME (
	call :shellenv.set.home JAVA_HOME "%JDK_HOME%"
) else if defined JRE_HOME (
	call :shellenv.set.home JAVA_HOME "%JRE_HOME%"
)

:: ========================================================================
::
:: Autoloading the rest of tools from %TEA_HOME%\opt
::
:: ========================================================================

for /d %%d in ( "%TEA_HOME%\opt\*" ) do call :shellenv.select.path "%%~d"

:: ========================================================================
::
:: Integration with ConEmu
::
:: ========================================================================

:shellenv.integration

if defined ConEmuANSI if /i "%ConEmuANSI%" == "ON" echo:[9999E

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

:: These routines look for the latest version of JDK or JRE installed on 
:: the PC and set the environment variable (JDK_HOME or JRE_HOME, 
:: respectively) to the appropriate path. Initially they look for paths in 
:: Windows Registry. If nothing is found there, they try to find all Java 
:: directories under %ProgramFiles% and %ProgramFiles(x86)% and set to the 
:: latest one.
::
:: %~1 - variable name (JDK_HOME or JRE_HOME)
:: %~2 - engine name (jdk or jre)
:: %~3 - registry name ("Java Development Kit" or "Java Runtime Environment")

:shellenv.lookup.jdk
call :shellenv.lookup.java JDK_HOME jdk "Java Development Kit"
goto :EOF

:shellenv.lookup.jre
call :shellenv.lookup.java JRE_HOME jre "Java Runtime Environment"
goto :EOF

:shellenv.lookup.java
set "%~1="

for %%q in (
	"HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\%~3"
	"HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\JavaSoft\%~3"
) do for /f "tokens=1,2,*" %%a in ( '
	reg query "%%~q" /v "JavaHome" /s 2^>nul ^| find "JavaHome"
' ) do if exist "%%~c" (
	set "%~1=%%~c"
)

for /f %%d in ( '
	dir /b "%ProgramFiles%\Java" "%ProgramFiles(x86)%\Java" 2^>nul ^| findstr /i "%~2" ^| sort
' ) do if exist "%ProgramFiles%\Java\%%d" (
	set "%~1=%ProgramFiles%\Java\%%d"
) else (
	set "%~1=%ProgramFiles(x86)%\Java\%%d"
)
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
:: %~1 - home name variable (looks like XXX_HOME)
:: %~2 - the directory's path
:: %~3 - /P to force prepending to %PATH%, or empty

:shellenv.set.home
if defined %~1 goto :EOF

:: Set all provided paths to %PATH%
call :shellenv.set.path "%~2\bin"     "%~3" && set "%~1=%~2"
call :shellenv.set.path "%~2\sbin"    "%~3" && set "%~1=%~2"
call :shellenv.set.path "%~2\usr\bin" "%~3" && set "%~1=%~2"
call :shellenv.set.path "%~2"         "%~3" && set "%~1=%~2"
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
:: %~2 - /P to force prepending to %PATH%, or empty

:shellenv.select.path

:: Only one of these paths will be appended to %PATH%
call :shellenv.set.path "%~1\bin"     "%~2" && goto :EOF
call :shellenv.set.path "%~1\usr\bin" "%~2" && goto :EOF
call :shellenv.set.path "%~1\cmd"     "%~2" && goto :EOF
call :shellenv.set.path "%~1"         "%~2" && goto :EOF
goto :EOF

:: ========================================================================

:: Checks the provided directory if it is new and adds to %PATH%.
::
:: By default, all the paths are appended to %PATH%. In the case when 
:: paths should to be prepended, use "/P" option.
::
:: %~1 - the directory's path
:: %~2 - /P to force prepending to %PATH%, or empty

:shellenv.set.path

:: Check if the path is not specified in %PATH% and contains executables
call :shellenv.check.path "%~1" || goto :EOF

:: Append or prepend new path to %PATH%
if /i     "%~2" == "/P" set "PATH=%~1;%PATH%"
if /i not "%~2" == "/P" set "PATH=%PATH%;%~1"
goto :EOF

:: ========================================================================

:: Checks the provided directory if it is new in %PATH%.
::
:: Returns ERRORLEVEL == 1 if path is found in %PATH% or no executables in 
:: the specified path, otherwise 0.
::
:: %~1 - the directory's path

:shellenv.check.path

:: Skip if the path is specified in %PATH%
for %%p in ( "%PATH:;=" "%" ) do if /i "%~1" == "%%~p" exit /b 1

:: Skip if no executables in the path
dir /b /a-d "%~1\*.exe" "%~1\*.bat" "%~1\*.cmd" >nul 2>nul

goto :EOF

:: ========================================================================

:: EOF
