@echo off

if not exist "SumatraPDF.exe" (
	echo:SumatraPDF not found here.
	echo:Re-run this script under the folder where SumatraPDF is located.
	goto :EOF
)

SumatraPDF.exe -register-for-pdf
