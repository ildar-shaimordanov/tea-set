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

:: 7-zip path
set "SEVENZIP_HOME=%TEA_HOME%\vendors\7za"
if exist "%SEVENZIP_HOME%" set "PATH=%PATH%;%SEVENZIP_HOME%"

:: ========================================================================
::
:: PuTTY, curl etc
::
:: ========================================================================

set "PATH=%PATH%;%TEA_HOME%\opt\PuTTY"
set "PATH=%PATH%;%TEA_HOME%\opt\curl\bin"

:: ========================================================================
::
:: Apache Ant
::
:: ========================================================================

set "ANT_HOME=%TEA_HOME%\opt\apache-ant-1.9.3"
:: set "ANT_HOME=%TEA_HOME%\opt\apache-ant-1.9.4"
if exist "%ANT_HOME%" set "PATH=%PATH%;%ANT_HOME%\bin"

:: ========================================================================
::
:: IUM
::
:: ========================================================================

set "IUM_HOME=C:\IUM"
if exist "%IUM_HOME%" set "PATH=%PATH%;%IUM_HOME%\bin"
:: if exist "%IUM_HOME%\Solid" set "PATH=%PATH%;%IUM_HOME%\Solid\bin"
:: if exist "%IUM_HOME%\mysql" set "PATH=%PATH%;%IUM_HOME%\mysql\bin"

:: ========================================================================
::
:: WWW (WebServers aka D.N.W.R.)
::
:: ========================================================================

if exist "%TEA_HOME%\bin\www.bat" call "%TEA_HOME%\bin\www.bat" define
if defined WWW_HOME set "PATH=%PATH%;%WWW_HOME%\usr\bin"

:: ========================================================================
::
:: Node.JS
::
:: ========================================================================

if exist "%TEA_HOME%\opt\nodejs\node.exe" set "PATH=%PATH%;%TEA_HOME%\opt\nodejs"

:: ========================================================================
::
:: Multimedia processing (FFmpeg, Libav etc)
::
:: ========================================================================

set "PATH=%PATH%;%TEA_HOME%\opt\ffmpeg-20141004-git-1c4c78e-win32-static\bin"
:: set "PATH=%PATH%;%TEA_HOME%\opt\ffmpeg-20141004-git-1c4c78e-win64-static\bin"

set "PATH=%PATH%;%TEA_HOME%\opt\libav-win32\usr\bin"
:: set "PATH=%PATH%;%TEA_HOME%\opt\libav-win64\usr\bin"

set "PATH=%PATH%;%TEA_HOME%\opt\wavpack"

set "PATH=%PATH%;%TEA_HOME%\opt\vorbis-tools"

set "PATH=%PATH%;%TEA_HOME%\opt\flac-x32"
:: set "PATH=%PATH%;%TEA_HOME%\opt\flac-x64"

set "PATH=%PATH%;%TEA_HOME%\opt\lame"

:: ========================================================================
::
:: Java
::
:: ========================================================================

for %%d in (
	"C:\Program Files\Java\jdk"
	"C:\Program Files (x86)\Java\jdk"
	"C:\Program Files\Java\jre"
	"C:\Program Files (x86)\Java\jre"
) do if not defined JAVA_HOME for /d %%p in ( "%%~d*" ) do set "JAVA_HOME=%%p"

if defined JAVA_HOME set "PATH=%PATH%;%JAVA_HOME%\bin"

:: ========================================================================
::
:: VirtualBox
::
:: ========================================================================

if exist "C:\Program Files\Oracle\VirtualBox" set "PATH=%PATH%;C:\Program Files\Oracle\VirtualBox"

:: ========================================================================
::
:: SVN
::
:: ========================================================================

set "SVN_HOME=%TEA_HOME%\opt\svn-1.8.5"
if exist "%SVN_HOME%" set "PATH=%PATH%;%SVN_HOME%\bin"

:: ========================================================================
::
:: Git
::
:: ========================================================================

:: set "GIT_HOME=C:\Program Files (x86)\Git"
set "GIT_HOME=%TEA_HOME%\vendors\msysgit"

:: if exist "%GIT_HOME%" set "PATH=%PATH%;%GIT_HOME%\cmd"
if exist "%GIT_HOME%" set "PATH=%GIT_HOME%\bin;%GIT_HOME%\mingw\bin;%GIT_HOME%\cmd;%GIT_HOME%\share\vim\vim74;%PATH%"

:: ========================================================================
::
:: Unix tools (Cygwin, GoW, GnuWin32, MSysGit, UnixUtils, Win-Bash etc)
::
:: ========================================================================

:: Set the location for unix tools as you want
:: set "UNIX_HOME=%TEA_HOME%\vendors\x-cygwin"
:: set "UNIX_HOME=%TEA_HOME%\vendors\x-gnuwin32"
set "UNIX_HOME=%TEA_HOME%\vendors\x-gow-git"
:: set "UNIX_HOME=%TEA_HOME%\vendors\x-msysgit"
:: set "UNIX_HOME=%TEA_HOME%\vendors\x-unxutils"
:: set "UNIX_HOME=%TEA_HOME%\vendors\x-win-bash"

if defined UNIX_HOME set "PATH=%UNIX_HOME%\bin;%PATH%"

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
:: Integration with ConEmu
::
:: ========================================================================

:cmd.env.integration

if defined ConEmuANSI if /i "%ConEmuANSI%" == "ON" echo:[9999E

:: Integrate Git into prompt
if defined ConEmuBaseDir if exist "%ConEmuBaseDir%\IsConEmu.cmd" (
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

:: EOF
