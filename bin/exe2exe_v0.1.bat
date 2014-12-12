@echo off

for %%p in ( sed.exe ) do if "%%~$PATH:p" == "" (
	echo:You must install sed to use the tool>&2
	exit /b 1
)

if "%~1" == "" (
	echo:%~n0 Version 0.1 Beta
	echo:Create EXE-file call redirector
	echo:
	echo:USAGE
	echo:    %~n0 [/C] [/EXE NAME] command-line
	echo:
	echo:OPTIONS
	echo:/C
	echo:    Chdir to wrapper directory
	echo:/EXE NAME
	echo:    The name of the executable file
	goto :EOF
)

setlocal enabledelayedexpansion

set "exe_stub=%~dpn0.bin"
if not exist "!exe_stub!" (
	echo:!exe_stub! not exist>&2
	endlocal
	exit /b 1
)

set "exe_chdir="
if /i "%~1" == "/C" (
	set "exe_chdir=/\[ \]/s/\[ \]/[x]/"
	shift /1
)

if /i "%~1" == "/EXE" (
	set "exe_name=%~dp0%~nx2"
	shift /1
	shift /1
) else (
	set "exe_name=%~dp0%~nx1"
)

if not defined exe_name (
	echo:Executable file not defined>&2
	endlocal
	exit /b 1
)

set "exe_cmd=%~1"
:cmdline_loop_begin
shift /1
if "%~1" == "" goto cmdline_loop_end
set "exe_cmd=!exe_cmd! %1"
goto cmdline_loop_begin
:cmdline_loop_end

if not defined exe_cmd (
	echo:Command for execution not defined>&2
	endlocal
	exit /b 1
)

::set "exe_cmd=%1 %2 %3 %4 %5 %6 %7 %8 %9"
set "exe_str=A!exe_cmd!"
set /a "exe_cmd_len=0"
for /l %%a in ( 12, -1, 0 ) do (
	set /a "exe_cmd_len|=1<<%%a"
	for %%b in ( !exe_cmd_len! ) do if "!exe_str:~%%b,1!" == "" set /a "exe_cmd_len&=~1<<%%a"
)

if !exe_cmd_len! gtr 270 (
	echo:Provided string is longer than 270 chars>&2
	endlocal
	exit /b 1
)

echo:Executable file:    [!exe_name!]
echo:Executable command: [!exe_cmd!]
if defined exe_chdir echo:Chdir to wrapper directory: [x]

set "exe_cmd=!exe_cmd:\=\\!"
set "exe_cmd=!exe_cmd:|=\|!"
set "exe_cmd=!exe_cmd:/=\/!"
set "exe_cmd=!exe_cmd:"=\"!"
::set "exe_cmd=!exe_cmd:[=\[!"
::set "exe_cmd=!exe_cmd:]=\]!"
::set "exe_cmd=!exe_cmd:(=\(!"
::set "exe_cmd=!exe_cmd:)=\)!"
::set "exe_cmd=!exe_cmd:{=\{!"
::set "exe_cmd=!exe_cmd:}=\}!"

sed -b -r "!exe_chdir!;/_{270}/s/_{!exe_cmd_len!}/!exe_cmd!/" "!exe_stub!" >"!exe_name!"

endlocal
goto :EOF

