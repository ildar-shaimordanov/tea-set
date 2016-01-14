@echo off

:: 1. Install MSysGit
:: 2. Proceed to this directory "%TEA_HOME%\etc\postinstall"
:: 3. Run the script "update_etc_profile.bat"
:: 4. Close the current MSysGit session

copy /b "%~dp0..\..\vendors\msysgit\etc\profile" "%~dp0profile.orig"

(
	echo:# Set new home dir
	echo:HOME="$^( cd / ; cd "$^( pwd -W ^)/../../home" ; pwd ^)"
	echo:
	type "%~dp0profile.orig"
) >"%~dp0..\..\vendors\msysgit\etc\profile"
