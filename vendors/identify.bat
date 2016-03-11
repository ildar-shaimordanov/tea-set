
if /i "%~1 %~2" == "app clink" (
	rem set "CLINK_NAME=clink_0.4.5"
	rem set "CLINK_NAME=clink_0.4.7"
)

if /i "%~1 %~2" == "app Far3" (
	rem set "FAR_NAME=Far30b4499.x86.20160101"
	rem set "FAR_NAME=Far30b4545.x86.20160210"
)

if /i "%~1 %~2" == "app Perl" (
	rem set "PERL_NAME=StrawberryPerl-5.8.8.3"
	rem set "PERL_NAME=StrawberryPerl-5.16.2"
)

if /i "%~1 %~2" == "app Unix" (
	rem set "UNIX_NAME=cygwin"
	rem set "UNIX_NAME=gnuwin32"
	set "UNIX_NAME=gow"
	rem set "UNIX_NAME=msysgit"
	rem set "UNIX_NAME=PortableGit-2.7.2-32-bit"
	rem set "UNIX_NAME=PortableGit-2.7.2-64-bit"
	rem set "UNIX_NAME=unxutils"
	rem set "UNIX_NAME=win-bash"
)

:: ========================================================================

if /i "%~1 %~2" == "shell Git" (
	rem set "SHELL_NAME=msysgit"
	rem set "SHELL_NAME=PortableGit-2.7.2-32-bit"
	rem set "SHELL_NAME=PortableGit-2.7.2-64-bit"
)

if /i "%~1 %~2" == "shell ConEmu" (
	rem set "SHELL_NAME=ConEmuPack.160301"
	rem set "SHELL_NAME=ConEmuPack.160308"
)

if /i "%~1 %~2" == "shell ConsoleZ" (
	rem set "SHELL_NAME=ConsoleZ.x64.1.16.0.16038"
	rem set "SHELL_NAME=ConsoleZ.x86.1.16.0.16038"
)

:: ========================================================================

:: EOF
