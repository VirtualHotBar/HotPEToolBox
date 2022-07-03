@echo off
cd /d "%~dp0"
%~dp0Bin\Tools\wimlib\wimlib-imagex capture "%~dp0TempFile\apply" "%~dp0Kernel.wim" "Boot" 1 --compress=lzx:100 --boot    