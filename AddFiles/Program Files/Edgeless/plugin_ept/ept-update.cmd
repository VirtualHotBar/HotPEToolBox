@echo off
echo %time% ept-update-运行，开始下载插件索引 >>X:\Users\Log.txt
echo ept-update 开始更新插件索引...
"X:\Program Files\Edgeless\EasyDown\aria2c.exe" -x16 -c -d X:\Users\ept -o Data.txt https://pineapple.edgeless.top/api/v2/ept/index >>X:\Users\Log.txt
if exist X:\Users\ept\Data.txt (
    echo %time% ept-update-索引下载成功 >>X:\Users\Log.txt
    if exist X:\Users\ept\Index del /f /q X:\Users\ept\Index>nul
    ren X:\Users\ept\Data.txt Index
    if not exist X:\Users\ept\Index echo %time% ept-update-索引重命名失败 >>X:\Users\Log.txt
    echo ept-update 插件索引更新成功
) else (
    echo %time% ept-update-索引下载失败 >>X:\Users\Log.txt
    echo ept-update 索引更新失败，请检查网络连接或联系作者
)
echo %time% ept-update-任务完成 >>X:\Users\Log.txt
echo on