cd /d "%ProgramFiles%\Edgeless\dynamic_creator"
echo %time% 动态提示生成程序-msgbox-启动 >>X:\Users\Log.txt
echo %1 >mtitle.txt
echo %2 >mcontent.txt
set /p title=<mtitle.txt
set /p content=<mcontent.txt

echo %time% 动态提示生成程序-msgbox-标题：%title%，内容：%content% >>X:\Users\Log.txt

echo msgbox "%content%",64,"%title%">alert.vbs && start alert.vbs && ping -n 2 127.1>nul && del alert.vbs
