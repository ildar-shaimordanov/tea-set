@echo off

if "%~1" == "" (
call :heredoc :HEREDOCHELP & goto :EOF
heredoc: attempt to embed the idea of heredoc to batch scripts.

There are few ways for using this solution:

1. call heredoc :LABEL [FILENAME] & goto :LABEL
Calling the external script "heredoc.bat" passing the heredoc LABEL and 
the name of the caller file. "FILENAME" is optional argument. The special 
environment variable "%HEREDOCFILE%" set to the filename of the caller 
script allows to avoid passing it as the second argument. 

2. call :heredoc :LABEL & goto :LABEL
Embed the subroutine ":heredoc" into yuor script.

Both LABEL and :LABEL forms are possible. Instead of "goto :LABEL" it is 
possible to use "goto" with another label, or "goto :EOF", or "exit /b".

Variables to be evaluated within the heredoc should be called in the 
delayed expansion style ^("^!var^!" rather than "%var%", for instance^).

Literal exclamation marks "^!" and carets "^^" must be escaped with a 
caret "^".

Additionally, parantheses "(" and ")" should be escaped, as well, if they 
are part of the heredoc content within parantheses of the script block.
:HEREDOCHELP
rem
)

:: http://stackoverflow.com/a/15032476/3627676
:heredoc LABEL [FILENAME]
setlocal enabledelayedexpansion
if not defined HEREDOCFILE set "HEREDOCFILE=%~f2"
if not defined HEREDOCFILE set "HEREDOCFILE=%~f0"
set go=
for /f "delims=" %%A in ( '
	findstr /n "^" "%HEREDOCFILE%"
' ) do (
	set "line=%%A"
	set "line=!line:*:=!"

	if defined go (
		if /i "!line!" == "!go!" goto :EOF
		echo:!line!
	) else (
		rem delims are ( ) > & | TAB , ; = SPACE
		for /f "tokens=1-3 delims=()>&|	,;= " %%i in ( "!line!" ) do (
			if /i "%%i %%j %%k" == "call :heredoc %1" set "go=%%k"
			if /i "%%i %%j %%k" == "call heredoc %1" set "go=%%k"
			if defined go if not "!go:~0,1!" == ":" set "go=:!go!"
		)
	)
)
goto :EOF
