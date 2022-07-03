cd /d "%ProgramFiles%\Edgeless\dynamic_creator"
echo %time% 动态提示生成程序-Tip-启动 >>X:\Users\Log.txt
set /a timeoutWait=%1+1000
if not defined timeoutWait echo %time% 动态提示生成程序-Tip-延时计算失败，退出 >>X:\Users\Log.txt
if not defined timeoutWait exit

echo %1 >timeout.txt
echo %2 >title.txt
echo %3 >content.txt
set /p timeout=<timeout.txt
set /p title=<title.txt
set /p content=<content.txt

echo %time% 动态提示生成程序-Tip-延时：%timeout%，标题：%title%，内容：%content% >>X:\Users\Log.txt

echo TIPS %title:~0,-1%,%content:~0,-1%,%timeout:~0,-1%,4, >tip.txt
echo WAIT %timeoutWait% >>tip.txt
del /f /q tip.wcs
ren tip.txt tip.wcs
start "X:\Program Files\Edgeless\plugin_loader\PECMD.EXE" tip.wcs