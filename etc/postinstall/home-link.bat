:: Setup a TEA-SET home as Cygwin/MSYS2/MinGW user home
::
:: Usage: home-link TYPE
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
::
:: The script assumes the following directory tree structure and HAVE TO BE
:: executed from within one of %TEA_SET%\vendors\*\home:
:: %TEA_SET%\home
:: %TEA_SET%\vendors\cygwin\home
:: %TEA_SET%\vendors\msys32\home
:: %TEA_SET%\vendors\msys64\home
:: ... and so on
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
mklink /j "%USERNAME%" "..\..\..\home"
goto :EOF

:create-symlinkd
mklink /d "%USERNAME%" "..\..\..\home"
goto :EOF

rem =======================================================================

:create-winlink
copy /b "%~dpn0.winlink" "%USERNAME%.lnk" || exit /b %ERRORLEVEL%
attrib +R "%USERNAME%.lnk"
goto :EOF

:create-cyglink
copy /b "%~dpn0.cyglink" "%USERNAME%" || exit /b %ERRORLEVEL%
attrib +S "%USERNAME%"
goto :EOF

rem =======================================================================

:show_usage
findstr /b "::" "%~f0"
goto :EOF

rem =======================================================================

rem EOF
