@echo off

copy /b "%~dp0..\..\..\vendors\msysgit\etc\profile" "%~dp0profile.orig"

(
	echo:# Set new home dir
	echo:HOME="$^( cd / ; cd "$^( pwd -W ^)/../../home" ; pwd ^)"
	echo:
	type "%~dp0profile.orig"
) >"%~dp0..\..\..\vendors\msysgit\etc\profile"
