:: Setup a TEA-SET home as Cygwin user home
::
:: Usage: cygwin-home TYPE
::
:: Available types:
::
:: junction	creates a directory junction.
:: symlinkd	creates a directory symbolic link. Elevated privileges
::		could be required to complete this command.
:: winlink	creates symlinks as Windows shortcuts with a special header
::		and the R/O attribute set.
:: cyglink	creates symlinks in the old-fashioned Cygwin style
::		(a special file with the System attribute set).
@echo off

if "%~1" == "" (
	findstr /b "::" "%~f0"
	goto :EOF
)

for %%n in (
	junction
	symlinkd
	winlink
	cyglink
) do if /i "%~1" == "%%~n" (
	call :create-%%~n
	if errorlevel 1 echo:Execution failed>&2
	goto :EOF
)

echo:Bad option: %~1>&2
goto :EOF

rem =======================================================================

:create-junction
call :mklink j
goto :EOF

:create-symlinkd
call :mklink d
goto :EOF

:mklink
setlocal
cd "%~dp0..\..\vendors\cygwin\home" || exit /b %ERRORLEVEL%
mklink /%~1 "%USERNAME%" "..\..\..\home"
goto :EOF

rem =======================================================================

:create-winlink
call :copy-file R winlink "%USERNAME%.lnk"
goto :EOF

:create-cyglink
call :copy-file S cyglink "%USERNAME%"
goto :EOF

:copy-file
setlocal
set "dstfile=%~dp0..\..\vendors\cygwin\home\%~3"
copy /b "%~dpn0.%~2" "%dstfile%" || exit /b %ERRORLEVEL%
attrib +%~1 "%dstfile%"
goto :EOF

rem =======================================================================

:show_usage
findstr /b "::" "%~f0"
goto :EOF

rem =======================================================================

rem EOF
