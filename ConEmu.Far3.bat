@echo off
start "%~n0 starting" "%~dp0vendors\ConEmu\ConEmu.exe" /LoadCfgFile "%~dp0etc\ConEmu\%~n0.xml" /Icon "%~dp0etc\images\%~n0.ico" %*
