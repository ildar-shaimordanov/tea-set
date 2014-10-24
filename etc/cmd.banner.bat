:: ========================================================================
::
:: This file is a helper script to show some specific environment 
:: variables such as %PATH% and families %FAR*%, %ConEmu*% and %*HOME%.
::
:: ========================================================================

@echo off

for %%m in ( set path doskey alias home conemu far ) do (
	if /i "%~1" == "/LIST" echo:%%m
	if /i "%~1" == "%%m" (
		call :show_%%m
		echo:
		goto :EOF
	)
)

if /i "%~1" == "/LIST" goto :EOF

echo:Usage:
echo:
echo:Show environment variables accordingly the PATTERN
echo:    %~n0 PATTERN
echo:
echo:Show the list of all available patterns
echo:    %~n0 /LIST
goto :EOF

:: ========================================================================

:show_set
set
goto :EOF

:show_path
for %%a in ( "%PATH:;=" "%" ) do echo:%%~a
goto :EOF

:show_doskey

:show_alias
doskey /macros
goto :EOF

:show_home
set | findstr /i "HOME="
goto :EOF

:show_conemu
set | findstr /i /b "ConEmu"
goto :EOF

:show_far
set | findstr /i /b "FAR"
goto :EOF

:: ========================================================================

:: EOF
