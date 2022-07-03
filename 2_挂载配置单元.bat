@echo off
cd /d "%~dp0"
reg load hklm\pe_def %~dp0TempFile\apply\windows\system32\config\default
reg load hklm\pe_soft %~dp0TempFile\apply\windows\system32\config\software
reg load hklm\pe_sys %~dp0TempFile\apply\windows\system32\config\system
reg load hklm\pe_drv %~dp0TempFile\apply\windows\system32\config\drivers

