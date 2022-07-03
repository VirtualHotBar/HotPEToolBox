@echo off
cd /d X:\Users\ept\upgrade
echo %time% ept-cutstr-运行，origin.txt： >>X:\Users\Log.txt
type origin.txt >>X:\Users\Log.txt
if exist name.txt del /f /q name.txt >nul
if exist ver.txt del /f /q ver.txt >nul
if exist au.txt del /f /q au.txt >nul
for /f "usebackq delims==_ tokens=1,2,3*" %%i in (origin.txt) do (
    echo %%i>>name.txt
    echo %%j>>ver.txt
    echo %%k>>au.txt
)
echo %time% ept-cutstr-任务完成，分别分割为： >>X:\Users\Log.txt
type name.txt >>X:\Users\Log.txt
type ver.txt >>X:\Users\Log.txt
type au.txt >>X:\Users\Log.txt