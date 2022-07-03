@echo off
cd /d "%~dp0"
echo 正在添加文件:AddFiles\*
xcopy %~dp0AddFiles %~dp0TempFile\apply /Q /Y /H /R /E
