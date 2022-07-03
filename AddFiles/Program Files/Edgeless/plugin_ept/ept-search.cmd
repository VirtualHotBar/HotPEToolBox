@if not exist X:\Users\ept\Index call ept-update
@if not exist X:\Users\ept\Index goto endSearch
@echo off
echo %time% ept-search-运行，第一参数：%1，开始对第一参数去引号 >>X:\Users\Log.txt
echo %1>bare.txt
set /p key=<bare.txt
echo %key:"=%>bare.txt
set /p key=<bare.txt
del /f /q bare.txt
echo %time% ept-search-第一参数去引号后的结果：%key% >>X:\Users\Log.txt
echo %time% ept-search-运行find，输出如下： >>X:\Users\Log.txt
if exist X:\Users\ept\Result.txt del /f /q X:\Users\ept\Result.txt
find /n /i "%key%" X:\Users\ept\Index >X:\Users\ept\Result.txt
type X:\Users\ept\Result.txt >>X:\Users\Log.txt

if "%2" neq "tryhit" goto skipHit
echo %time% ept-search-尝试hit >>X:\Users\Log.txt
if exist tmp.txt del /f /q tmp.txt
findstr /b /n /i /c:"%key%_" X:\Users\ept\Index >tmp.txt
if not exist tmp.txt (
    echo %time% ept-search-hit失败，因为tmp.txt不存在 >>X:\Users\Log.txt
    goto skipHit
)
set readNull=
set /p readNull=<tmp.txt
if not defined readNull (
    echo %time% ept-search-hit失败，因为tmp.txt为空 >>X:\Users\Log.txt
    goto skipHit
)
echo %time% ept-search-hit成功，命中的行： >>X:\Users\Log.txt
type tmp.txt >>X:\Users\Log.txt

for /f "usebackq delims==: tokens=1*" %%i in (tmp.txt) do (
    echo %%i >hitNum.txt
)
set /p hitNum=<hitNum.txt
if not defined hitNum (
    echo %time% ept-search-hit失败，奇怪的问题：序号解析失败 >>X:\Users\Log.txt
    goto skipHit
)
echo %time% ept-search-hitNum：%hitNum% >>X:\Users\Log.txt
if exist hitNum.txt del /f /q hitNum.txt
if exist tmp.txt del /f /q tmp.txt
echo ept-search 自动命中序号为%hitNum%的插件
call ept-install %hitNum% %3
@echo off
goto endSearch

:skipHit
echo ept-search 在本地索引中命中以下插件
find /n /i "%key%" X:\Users\ept\Index
echo ----------
echo.
echo 使用   ept install [序号] / [软件名]    安装
:endSearch
@echo off
echo %time% ept-search-任务完成 >>X:\Users\Log.txt