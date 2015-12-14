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

if defined CMD_ENV_LOADED goto :cmd.env.integration

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
:: Show banner by shellinfo.bat
::
:: ========================================================================

set "SHOW_BANNER_FAR=conemu far home path"
set "SHOW_BANNER_CMD=conemu home path"

:: ========================================================================
::
:: Tea-Set
::
:: ========================================================================

for /f "tokens=*" %%p in ( "%~dp0." ) do call :cmd.env.set.home TEA_HOME "%%~fp"

:: ========================================================================
::
:: 7-ZIP
::
:: ========================================================================

call :cmd.env.set.home SEVENZIP_HOME "%TEA_HOME%\vendors\7za"

:: ========================================================================
::
:: OpenLDAP
::
:: ========================================================================

call :cmd.env.set.home OPENLDAP_HOME "%TEA_HOME%\opt\OpenLDAP"

:: ========================================================================
::
:: IUM
::
:: ========================================================================

call :cmd.env.set.home IUM_HOME "C:\IUM"

:: ========================================================================
::
:: WWW (WebServers aka D.N.W.R.)
::
:: ========================================================================

call :cmd.env.set.home WWW_HOME "%TEA_HOME%\vendors\WWW"

:: ========================================================================
::
:: Git
::
:: ========================================================================

:: set "GIT_HOME=%ProgramFiles(x86)%\Git"
::set "GIT_HOME=%TEA_HOME%\vendors\msysgit"

:: if exist "%GIT_HOME%" set "PATH=%PATH%;%GIT_HOME%\cmd"
::if exist "%GIT_HOME%" set "PATH=%GIT_HOME%\bin;%GIT_HOME%\mingw\bin;%GIT_HOME%\cmd;%GIT_HOME%\share\vim\vim74;%PATH%"

:: ========================================================================
::
:: Unix tools (Cygwin, GoW, GnuWin32, MSysGit, UnixUtils, Win-Bash etc)
::
:: ========================================================================

:: Set the first existing location for unix tools.
:: The minus symbol "-" in the front of the package names inverts the 
:: directory as not existing.
for %%f in (
	"-cygwin"
	"-git-for-windows"
	"-gnuwin32"
	"-gow-git"
	"msysgit"
	"-unxutils"
	"-win-bash"
) do call :cmd.env.set.home UNIX_HOME "%TEA_HOME%\vendors\%%~f" /P

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

:: set "PERL_HOME=%TEA_HOME%\vendors\strawberryPerl-5.8.8.3"
set "PERL_HOME=%TEA_HOME%\vendors\StrawberryPerl-5.16.2"
for %%f in ( 
	"c" 
	"perl" 
	"perl\site" 
) do call :cmd.env.select.path "%PERL_HOME%\%%~f" /P

:: ========================================================================
::
:: VirtualBox
::
:: ========================================================================

call :cmd.env.select.path "%ProgramFiles%\Oracle\VirtualBox"

:: ========================================================================
::
:: Java
::
:: ========================================================================

call :cmd.env.lookup.java jre
call :cmd.env.lookup.java jdk

if defined JDK_HOME (
	call :cmd.env.set.home JAVA_HOME "%JDK_HOME%"
) else if defined JRE_HOME (
	call :cmd.env.set.home JAVA_HOME "%JRE_HOME%"
)

:: ========================================================================
::
:: Autoloading the rest of tools from %TEA_HOME%\opt
::
:: ========================================================================

for /d %%d in ( "%TEA_HOME%\opt\*" ) do call :cmd.env.select.path "%%~d"

:: ========================================================================
::
:: Integration with ConEmu
::
:: ========================================================================

:cmd.env.integration

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

:: This routine looks for the latest version of JDK or JRE installed on 
:: the PC and sets the environment variable (JDK_HOME or JRE_HOME, 
:: respectively) to the appropriate path. It considers all java versions 
:: are installed by default under %ProgramFiles% and %ProgramFiles(x86)%.
::
:: %~1 - one of them: jdk or jre
:cmd.env.lookup.java
set "%~1_HOME="
for /f %%d in ( '
	dir /b "%ProgramFiles%\Java\%~1*" "%ProgramFiles(x86)%\Java\%~1*" 2^>nul ^| sort
' ) do if exist "%ProgramFiles%\Java\%%d" (
	set "%~1_HOME=%ProgramFiles%\Java\%%d"
) else (
	set "%~1_HOME=%ProgramFiles(x86)%\Java\%%d"
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
:cmd.env.set.home
if defined %~1 goto :EOF

:: Set all provided paths to %PATH%
call :cmd.env.set.path "%~2\bin"     "%~3" && set "%~1=%~2"
call :cmd.env.set.path "%~2\sbin"    "%~3" && set "%~1=%~2"
call :cmd.env.set.path "%~2\usr\bin" "%~3" && set "%~1=%~2"
call :cmd.env.set.path "%~2"         "%~3" && set "%~1=%~2"
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
:cmd.env.select.path

:: Only one of these paths will be appended to %PATH%
call :cmd.env.set.path "%~1\bin"     "%~2" && goto :EOF
call :cmd.env.set.path "%~1\usr\bin" "%~2" && goto :EOF
call :cmd.env.set.path "%~1\cmd"     "%~2" && goto :EOF
call :cmd.env.set.path "%~1"         "%~2" && goto :EOF
goto :EOF

:: ========================================================================

:: Checks the provided directory if it is new and adds to %PATH%.
::
:: By default, all the paths are appended to %PATH%. In the case when 
:: paths should to be prepended, use "/P" option.
::
:: %~1 - the directory's path
:: %~2 - /P to force prepending to %PATH%, or empty
:cmd.env.set.path
:: Check if the path is not specified in %PATH% and contains executables
call :cmd.env.check.path "%~1" || goto :EOF

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
:cmd.env.check.path
:: Skip if the path is specified in %PATH%
for %%p in ( "%PATH:;=" "%" ) do if /i "%~1" == "%%~p" exit /b 1

:: Skip if no executables in the path
dir /b /a-d "%~1\*.exe" "%~1\*.bat" "%~1\*.cmd" >nul 2>nul

goto :EOF

:: ========================================================================

:: EOF
