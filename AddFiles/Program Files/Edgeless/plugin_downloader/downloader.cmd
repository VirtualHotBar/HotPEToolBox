@echo off
cd /d "%~dp0"
set /p w=<Target.txt
set /p n=<name.txt
if exist php.txt set /p php=<php.txt
if exist savepath.txt set /p savepath=<savepath.txt
if exist savename.txt set /p savename=<savename.txt
echo %time% 插件包下载程序-运行 >>X:\Users\Log.txt
echo %time% 插件包下载程序-任务名称：%n% >>X:\Users\Log.txt
echo %time% 插件包下载程序-任务Token：%w% >>X:\Users\Log.txt
if exist php.txt echo %time% 自定义下载程序-PHP名称：%php% >>X:\Users\Log.txt
if exist savepath.txt echo %time% 自定义下载程序-保存路径：%savepath% >>X:\Users\Log.txt
if exist savepath.txt echo %time% 自定义下载程序-保存名称：%savename% >>X:\Users\Log.txt
set noRetry=f
if defined php goto selfSetDown

:home
cls
title Edgeless插件下载器-正在下载%n%
color 3f
if exist "X:\Program Files\Edgeless\plugin_downloader\tar.7zf" del /f /q "X:\Program Files\Edgeless\plugin_downloader\tar.7zf"
"X:\Program Files\Edgeless\EasyDown\aria2c.exe" -x16 -c -o "tar.7zf" http://s.edgeless.top/?token=%w%
::"X:\Program Files\Edgeless\EasyDown\EasyDown.exe" -Down("http://s.edgeless.top/?token=%w%","tar.7zf","X:\Program Files\Edgeless\plugin_downloader")
if not exist "X:\Program Files\Edgeless\plugin_downloader\tar.7zf" goto df
echo %time% 插件包下载程序-下载成功 >>X:\Users\Log.txt
start pecmd load over.wcs
exit


:df
echo %time% 插件包下载程序-检查网络 >>X:\Users\Log.txt
cls
title 正在检查网络
ping cloud.tencent.com
if %errorlevel%==1 goto nonet
if %noRetry%==f goto retry
title Edgeless服务器无响应
echo %time% 插件包下载程序-服务器无响应（已自动重试） >>X:\Users\Log.txt
cls
echo.
echo.
echo.
echo         下载失败，Edgeless服务器无响应
echo               请联系作者解决此问题
echo.
echo.
pause
start pecmd load GUI.wcs
exit


:nonet
title 无法连接至互联网
echo %time% 插件包下载程序-Edgeless未联网 >>X:\Users\Log.txt
cls
echo.
echo.
echo.
echo         下载失败，当前系统未接入互联网
echo.
echo.
echo.
pause
start pecmd load GUI.wcs
exit

:retry
set noRetry=t
echo %time% 插件包下载程序-准备自动重试 >>X:\Users\Log.txt
cls
echo.
echo   Edgeless服务器正在解析下载地址，请稍候...
echo         程序将在3秒后重新发送下载请求
pecmd wait 3000
goto home


:selfSetDown
cls
if not defined savepath goto error
if not defined savename goto error
set noRetry=t
title Edgeless自定义下载器-正在下载%n%
color 3f
if exist "%savepath%%savename%" del /f /q "%savepath%%savename%"
cd /d "%savepath%"
"X:\Program Files\Edgeless\EasyDown\aria2c.exe" -x16 -c -o "%savename%" http://s.edgeless.top/?token=%w%
cd /d "%~dp0"
::"X:\Program Files\Edgeless\EasyDown\EasyDown.exe" -Down("http://s.edgeless.top/%php%.php?token=%w%","%savename%","%savepath%")
if not exist "%savepath%%savename%" goto df
echo %time% 自定义下载程序-下载成功 >>X:\Users\Log.txt
explorer "%savepath%"
cd /d X:\Windows\System32
pecmd exec "%savepath%%savename%"
exit



:error
title 出现了一些问题
echo %time% 自定义下载程序-变量定义不完全 >>X:\Users\Log.txt
cls
echo.
echo.
echo.
echo       下载失败，我们的程序出现了传参失败的错误
echo               请联系作者解决此问题
echo.
echo.
echo.
pause
exit
