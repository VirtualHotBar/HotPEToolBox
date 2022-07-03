@echo off
echo %time% ept-cache-运行，第一参数：%1，第二参数：%2 >>X:\Users\Log.txt

if "%1"=="search" (
    echo %time% ept-cache-重定向至ept-search >>X:\Users\Log.txt
    call ept-search %2
    goto endOfEtp
)

if "%1"=="madison" (
    echo %time% ept-cache-重定向至ept-getver >>X:\Users\Log.txt
    call ept-getver %2
    goto endOfEtp
)

call ept-help.cmd
:endOfEtp
@echo on