@echo off

if not exist "SumatraPDF.exe" (
	echo:SumatraPDF not found here.
	echo:Re-run this script under the folder where SumatraPDF is located.
	goto :EOF
)

if not exist "%~dp0SumatraPDF-settings.txt" (
	copy /b "%~dp0SumatraPDF-settings-default.txt" "%~dp0SumatraPDF-settings.txt"
)

if not exist "%~dp0sumatrapdfcache" (
	md "%~dp0sumatrapdfcache"
)

mklink "SumatraPDF-settings.txt" "..\..\etc\misc\SumatraPDF\SumatraPDF-settings.txt"
mklink /d "sumatrapdfcache" "..\..\etc\misc\SumatraPDF\sumatrapdfcache"
