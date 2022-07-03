@echo off
cd /d "%~dp0"
echo 正在破解USB弹出功能文件
%~dp0Bin\Tools\binmay.exe -u %~dp0TempFile\apply\Windows\System32\DeviceSetupManager.dll\" -s u:SystemSetupInProgress -r u:DisableDeviceSetupMgr
del %~dp0TempFile\apply\Windows\System32\DeviceSetupManager.dll.org
