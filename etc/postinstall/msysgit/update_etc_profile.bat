@echo off

copy /b "%~dp0..\..\..\vendors\msysgit\etc\profile" profile.orig

(
	echo:# Set new home dir
	echo:HOME='%~dp0..\..\..\home'
	echo:
	type profile.orig
) >"%~dp0..\..\..\vendors\msysgit\etc\profile"
