@echo off
start "Command Prompt starting" "%~dp0..\vendors\ConEmu\ConEmu.exe" /LoadCfgFile "%~dp0ConEmu\ConEmu.Prompt.xml" /Icon "%~dp0images\ConEmu.Prompt.ico" /NoSingle %*
