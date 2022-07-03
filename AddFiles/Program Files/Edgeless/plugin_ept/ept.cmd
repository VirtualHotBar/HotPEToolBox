@echo off
echo %time% ept-运行，第一参数：%1，第二参数：%2，第三参数：%3 >>X:\Users\Log.txt
if "%1"=="search" (
    echo %time% ept-重定向至ept-search >>X:\Users\Log.txt
    call ept-search %2
    goto endOfEtp
)
if "%1"=="install" (
    echo %time% ept-重定向至ept-install >>X:\Users\Log.txt
    call ept-install %2 %3
    goto endOfEtp
)

if "%1"=="remove" (
    echo %time% ept-重定向至ept-remove >>X:\Users\Log.txt
    call ept-remove %2 %3
    goto endOfEtp
)

if "%1"=="update" (
    echo %time% ept-重定向至ept-update >>X:\Users\Log.txt
    call ept-update
    goto endOfEtp
)

if "%1"=="upgrade" (
    echo %time% ept-重定向至ept-upgrade >>X:\Users\Log.txt
    call ept-upgrade %2
    goto endOfEtp
)

if "%1"=="getver" (
    echo %time% ept-cache-重定向至ept-getver >>X:\Users\Log.txt
    call ept-getver %2
    goto endOfEtp
)
call ept-help.cmd
:endOfEtp
@echo on