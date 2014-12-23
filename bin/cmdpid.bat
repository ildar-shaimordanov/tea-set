@echo off

if "%~1" == "/?" goto :help
if "%~1" == "-?" goto :help

if /i "%~1" == "/h" goto :help
if /i "%~1" == "-h" goto :help


for %%p in ( powershell.exe ) do if "%%~$PATH:p" == "" (
	>&2 echo:%%p required.
	exit /b 1
)


:cmdpid
for /f "tokens=*" %%p in ( '
	set "PPID=(Get-WmiObject Win32_Process -Filter ProcessId=$P).ParentProcessId" ^& ^
	call powershell -NoLogo -NoProfile -Command "$P = $pid; $P = %%PPID%%; %%PPID%%"
' ) do set CMDPID=%%p

goto :EOF


:help
echo:Calculates the Process ID of the currently running script or
echo:Command Prompt and stores in the environment variable CMDPID.
echo:
echo:Usage: %~n0
