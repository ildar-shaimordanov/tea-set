set "CHERE_INVOKING=1"

for /f "tokens=* delims=" %%d in ( '
	dir /o-n /b "%TEA_HOME%\vendors\winpty*cygwin*"
' ) do set "PATH=%PATH%;%TEA_HOME%\vendors\%%~d\bin"
