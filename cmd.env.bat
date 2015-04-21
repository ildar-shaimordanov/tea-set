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
:: Show banner by cmd.banner.bat
::
:: ========================================================================

set "SHOW_BANNER_FAR=conemu far home path"
set "SHOW_BANNER_CMD=conemu home path"

:: ========================================================================
::
:: Environment settings
::
:: ========================================================================

:: Tea-Set homedir
for /f "tokens=*" %%p in ( "%~dp0." ) do set "TEA_HOME=%%~fp"

:: Common paths
set "PATH=%PATH%;%TEA_HOME%\bin;%TEA_HOME%\var"

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

call :cmd.env.set.home WWW_HOME "%TEA_HOME%\WWW"

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

:: Set the location for unix tools as you want
::call :cmd.env.set.home UNIX_HOME "%TEA_HOME%\vendors\cygwin" /p
::call :cmd.env.set.home UNIX_HOME "%TEA_HOME%\vendors\gnuwin32" /p
call :cmd.env.set.home UNIX_HOME "%TEA_HOME%\vendors\gow-git" /p
::call :cmd.env.set.home UNIX_HOME "%TEA_HOME%\vendors\msysgit" /p
::call :cmd.env.set.home UNIX_HOME "%TEA_HOME%\vendors\unxutils" /p
::call :cmd.env.set.home UNIX_HOME "%TEA_HOME%\vendors\win-bash" /p

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

:: if defined PERL_HOME set "PATH=%PATH%;%PERL_HOME%\perl\site\bin;%PERL_HOME%\perl\bin;%PERL_HOME%\c\bin"
if defined PERL_HOME set "PATH=%PERL_HOME%\perl\site\bin;%PERL_HOME%\perl\bin;%PERL_HOME%\c\bin;%PATH%"

:: ========================================================================
::
:: VirtualBox
::
:: ========================================================================

if exist "%ProgramFiles%\Oracle\VirtualBox" set "PATH=%PATH%;%ProgramFiles%\Oracle\VirtualBox"

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

for /d %%d in ( "C:\PROGS\opt\*" ) do call :cmd.env.select.set.path "%%~d"

:: ========================================================================
::
:: Integration with ConEmu
::
:: ========================================================================

:cmd.env.integration

if defined ConEmuANSI if /i "%ConEmuANSI%" == "ON" echo:[9999E

:: Integrate Git into prompt
if /i "%~1" == "set-git-prompt" if defined ConEmuBaseDir if exist "%ConEmuBaseDir%\IsConEmu.cmd" (
	call "%ConEmuBaseDir%\IsConEmu.cmd" >nul && prompt $p$s{git}$_$g$s
)

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

:: %~1 - one of them: jdk or jre
:cmd.env.lookup.java
set "%~1_HOME="
for /f %%d in ( '
	dir /b "%ProgramFiles%\Java\%~1*" "%ProgramFiles(x86)%\Java\%~1*" ^| sort
' ) do if exist "%ProgramFiles%\Java\%%d" (
	set "%~1_HOME=%ProgramFiles%\Java\%%d"
) else (
	set "%~1_HOME=%ProgramFiles(x86)%\Java\%%d"
)
goto :EOF

:: ========================================================================

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

:: %~1 - the directory's path
:: %~2 - /P to force prepending to %PATH%, or empty
:cmd.env.select.set.path
:: Only one of these paths will be appended to %PATH%
call :cmd.env.set.path "%~1\bin" "%~2" && goto :EOF
call :cmd.env.set.path "%~1\cmd" "%~2" && goto :EOF
call :cmd.env.set.path "%~1"     "%~2" && goto :EOF
goto :EOF

:: ========================================================================

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

:: %~1 - the directory's path
:cmd.env.check.path
:: Skip if the path is specified in %PATH%
for %%p in ( "%PATH:;=" "%" ) do if /i "%~1" == "%%~p" exit /b 1

:: Skiep if no executables in the path
dir /b /a-d "%~1\*.exe" "%~1\*.bat" "%~1\*.cmd" >nul 2>nul

goto :EOF

:: ========================================================================

:: EOF
