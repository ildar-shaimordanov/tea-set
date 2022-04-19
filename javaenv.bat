@echo off

call :shellenv.lookup.jdk
call :shellenv.lookup.jre

if defined JRE_HOME set "JAVA_HOME=%JRE_HOME%"
if defined JDK_HOME set "JAVA_HOME=%JDK_HOME%"

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

:: ========================================================================

:shellenv.lookup.jre
call :shellenv.lookup.java JRE_HOME jre "Java Runtime Environment"
goto :EOF

:: ========================================================================

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

:: EOF
