set "CHERE_INVOKING=1"
set "MSYS2_PATH_TYPE=inherit"

for /f "tokens=* delims=" %%d in ( '
	dir /o-n /b "%TEA_HOME%\vendors\winpty*msys2*"
' ) do set "PATH=%PATH%;%TEA_HOME%\vendors\%%~d\bin"
