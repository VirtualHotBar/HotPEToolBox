@echo off
cd /d "%~dp0"
%~dp0Bin\Tools\wimlib\wimlib-imagex.exe apply %~dp0boot.wim 1 %~dp0TempFile\apply