@echo off
mode 80,20
echo %time% 插件加载程序-运行 >>X:\Users\Log.txt
echo %1 >>X:\Users\Log.txt
title 正在加载自定义插件包
if exist "%ProgramFiles%\Edgeless\cmdlist.txt" del /f /q "%ProgramFiles%\Edgeless\cmdlist.txt"
if exist "%ProgramFiles%\Edgeless\wcslist.txt" del /f /q "%ProgramFiles%\Edgeless\wcslist.txt"
cd /d "%ProgramFiles%\Edgeless"
if not exist 安装程序 md 安装程序
ren killep.wcs killep.ini
move /y *.cmd 安装程序
move /y *.wcs 安装程序
move /y Nes.ini 安装程序
ren killep.ini killep.wcs
cd /d %~dp0
7z.exe x %1 -o"x:\program files\edgeless" -aoa
dir /b "%ProgramFiles%\Edgeless\*.cmd" >"%ProgramFiles%\Edgeless\cmdlist.txt"
dir /b "%ProgramFiles%\Edgeless\*.wcs" >"%ProgramFiles%\Edgeless\wcslist.txt"
echo %time% 插件加载程序-外置批处理列表 >>X:\Users\Log.txt
dir /b "%ProgramFiles%\Edgeless\*.cmd" >>X:\Users\Log.txt
dir /b "%ProgramFiles%\Edgeless\*.wcs" >>X:\Users\Log.txt
if exist "%ProgramFiles%\Edgeless\cmdlist.txt" (
for /f  "usebackq" %%a in  ("%ProgramFiles%\Edgeless\cmdlist.txt") do (
pecmd exec ="%ProgramFiles%\Edgeless\%%a"
  )
  )
if exist "%ProgramFiles%\Edgeless\wcslist.txt" (
dir /b "%ProgramFiles%\Edgeless\*.wcs" >"%ProgramFiles%\Edgeless\wcslist.txt"
for /f  "usebackq" %%a in  ("%ProgramFiles%\Edgeless\wcslist.txt") do (
::start "" /D "%ProgramFiles%\Edgeless\" "%%a"
pecmd load "%ProgramFiles%\Edgeless\%%a"
  )
  )
if exist "%ProgramFiles%\Edgeless\启动盘制作工具\制作启动盘.exe" pecmd link "X:\Users\Default\Desktop\制作启动盘","X:\Program Files\Edgeless\启动盘制作工具\制作启动盘.exe",,"X:\Users\Icon\shortcut\usbburner.ico",0
pecmd exec X:\Users\Icon\setDesktopIcon.exe
exit