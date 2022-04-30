@echo off
cd /d "%~dp0"

for /d %%f in ("%~dp0data\TempFile\apply\windows\system32\DriverStore\FileRepository\netrndis.inf*") do (
echo DriverDatabase\DriverPackages\%%~nf%%~xf
reg copy "hklm\os_drv\DriverDatabase\DriverPackages\%%~nf%%~xf" "hklm\pe_drv\DriverDatabase\DriverPackages\%%~nf%%~xf" /S /F
)
for /d %%g in ("%~dp0data\TempFile\apply\windows\system32\DriverStore\FileRepository\rndiscmp.inf*") do (
echo DriverDatabase\DriverPackages\%%~ng%%~xg
reg copy "hklm\os_drv\DriverDatabase\DriverPackages\%%~ng%%~xg" "hklm\pe_drv\DriverDatabase\DriverPackages\%%~ng%%~xg" /S /F
)
