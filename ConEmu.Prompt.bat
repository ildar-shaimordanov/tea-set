@echo off
start "Command Prompt starting" "%~dp0vendors\ConEmu\ConEmu.exe" /LoadCfgFile "%~dp0etc\ConEmu\ConEmu.Prompt.xml" /Icon "%~dp0etc\images\ConEmu.Prompt.ico" /NoSingle %*
