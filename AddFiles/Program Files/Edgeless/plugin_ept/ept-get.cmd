@echo off
echo %time% ept-get-运行，第一参数：%1，第二参数：%2，第三参数：%3 >>X:\Users\Log.txt
if "%1"=="install" (
    echo %time% ept-get-重定向至ept-install >>X:\Users\Log.txt
    call ept-install %2 %3
    goto endOfEtp
)

if "%1"=="remove" (
    echo %time% ept-get-重定向至ept-remove >>X:\Users\Log.txt
    call ept-remove %2 %3
    goto endOfEtp
)

if "%1"=="update" (
    echo %time% ept-get-重定向至ept-update >>X:\Users\Log.txt
    call ept-update
    goto endOfEtp
)

if "%1"=="upgrade" (
    echo %time% ept-重定向至ept-upgrade >>X:\Users\Log.txt
    call ept-upgrade %2
    goto endOfEtp
)
call ept-help.cmd
:endOfEtp
@echo on