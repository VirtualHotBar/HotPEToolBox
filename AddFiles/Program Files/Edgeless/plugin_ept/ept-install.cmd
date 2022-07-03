@if not exist X:\Users\ept\Index call ept-update
@if not exist X:\Users\ept\Index goto end
@echo off
echo %time% ept-install-运行，第一参数：%1，第二参数：%2 >>X:\Users\Log.txt
if exist X:\Users\ept\pack.7zf (
    echo ept-install 另一个ept-install正在运行，请等待其运行结束
    echo %time% ept-install-另一个ept-install正在运行，退出 >>X:\Users\Log.txt
    goto forceend
)
if exist tmp.txt del /f /q tmp.txt >nul
if exist name.txt del /f /q name.txt >nul
if exist ver.txt del /f /q ver.txt >nul
if exist au.txt del /f /q au.txt >nul
if exist cate.txt del /f /q cate.txt >nul
if exist X:\Users\ept\DownloadFail.txt del /f /q X:\Users\ept\DownloadFail.txt >nul
if exist X:\Users\ept\SaveFail.txt del /f /q X:\Users\ept\SaveFail.txt >nul

setlocal enabledelayedexpansion
set /a row=0
echo ept-install 正在读取本地插件索引...
echo %time% ept-install-读取本地插件索引 >>X:\Users\Log.txt
for /f "usebackq delims==; tokens=*" %%i in (X:\Users\ept\Index) do (
    set /a row+=1
    if !row!==%1 echo %%i >tmp.txt
)
if not exist tmp.txt (
    echo %time% ept-install-不存在tmp.txt，重定向至ept-search >>X:\Users\Log.txt
    call ept-search %1 tryhit %2
    @echo off
    goto end
)

echo %time% ept-install-开始解析tmp.txt，内容： >>X:\Users\Log.txt
type tmp.txt >>X:\Users\Log.txt
echo ept-install 正在解析插件信息...
for /f "usebackq delims==_ tokens=1,2,3,4*" %%i in (tmp.txt) do (
    echo %%i>name.txt
    echo %%j>ver.txt
    echo %%k>au.txt
    echo %%l>cate.txt
)
set /p name=<name.txt
set /p ver=<ver.txt
set /p au=<au.txt
set /p cate=<cate.txt
echo %time% ept-install-name:%name%,ver:%ver%,au:%au%,cate:%cate% >>X:\Users\Log.txt
if exist tmp.txt del /f /q tmp.txt >nul
if exist ver.txt del /f /q ver.txt >nul
if exist au.txt del /f /q au.txt >nul
if exist cate.txt del /f /q cate.txt >nul

if /i "%2" == "-y" echo ept-install 将会执行自动安装
if /i "%2" == "-a" echo ept-install 将会执行自动安装并保存
if /i "%2" == "-l" echo ept-install 将会执行LocalBoost安装并保存

if /i "%2" == "-y" echo Y >Y.txt
if /i "%2" == "-a" echo Y >Y.txt
if /i "%2" == "-a" echo A >A.txt
if /i "%2" == "-l" echo Y >Y.txt
if /i "%2" == "-l" echo L >L.txt

if exist Y.txt echo %time% ept-install-Y.txt建立完成 >>X:\Users\Log.txt
if exist A.txt echo %time% ept-install-A.txt建立完成 >>X:\Users\Log.txt
if exist L.txt echo %time% ept-install-L.txt建立完成 >>X:\Users\Log.txt

echo ept-install 此插件将被安装：
echo ----------
echo 软件名：%name%
echo 版本号：%ver%
echo 打包者：%au%
echo 分类：%cate%
echo ----------
echo.
if not exist Y.txt CHOICE /C yaln /M "您希望开始安装%name%吗?（安装/安装并保存/LocalBoost安装并保存/取消）"
if %errorlevel%==4 goto end
if %errorlevel%==2 echo A >A.txt
if %errorlevel%==3 echo L >L.txt
echo %time% ept-install-用户确认开始安装，选择：%errorlevel%，开始下载 >>X:\Users\Log.txt
echo ept-install 正在搜索本地仓库...
for %%1 in (Z Y X W V U T S R Q P O N M L K J I H G F E D C ) do (
    if exist "%%1:\Edgeless\Resource\%name%_%ver%_%au%.7zf" copy /y "%%1:\Edgeless\Resource\%name%_%ver%_%au%.7zf" X:\Users\ept\pack.7zf >nul
    if exist "%%1:\Edgeless\Resource\%name%_%ver%_%au%.7z" copy /y "%%1:\Edgeless\Resource\%name%_%ver%_%au%.7z" X:\Users\ept\pack.7zf >nul
    if exist X:\Users\ept\pack.7zf echo ept-install 已从本地仓库搬运目标插件包
    if exist X:\Users\ept\pack.7zf echo %time% ept-install-从本地仓库搬运："%%1:\Edgeless\Resource\%name%_%ver%_%au%.7z（f）" >>X:\Users\Log.txt
)
if not exist X:\Users\ept\pack.7zf echo ept-install 正在向服务器发送下载请求...
if not exist X:\Users\ept\pack.7zf "X:\Program Files\Edgeless\EasyDown\aria2c.exe" -x16 -c -d X:\Users\ept -o pack.7zf "http://s.edgeless.top/ept.php?name=%name%&version=%ver%&author=%au%&category=%cate:~0,-1%"
if not exist X:\Users\ept\pack.7zf (
    echo ept-install 下载失败，请检查网络或联系作者
    echo %time% ept-install-下载失败 >>X:\Users\Log.txt
    echo Fail >X:\Users\ept\DownloadFail.txt
    goto end
)
echo ept-install 正在安装插件包%name%...
echo %time% ept-install-开始安装 >>X:\Users\Log.txt
echo %name%_%ver%_%au%>X:\Users\ept\Name.txt
if not exist X:\Users\ept\upgrade\UpgradeTime.txt (
    if not exist L.txt pecmd exec -min ="%ProgramFiles%\Edgeless\plugin_loader\load.cmd" "X:\Users\ept\pack.7zf"
    if exist L.txt goto pLocalBoost
)
echo ept-install 已完成%name%的安装任务

if exist A.txt (
    echo "%name%_%ver%_%au%.7z" >savename.txt
    call ept-save.cmd
)

set Spath=
if exist X:\Users\ept\upgrade\UpgradeTime.txt set /p Spath=<Spath.txt
if exist X:\Users\ept\upgrade\UpgradeTime.txt (
    if not defined Spath echo %time% ept-install-错误：Spath未定义 >>X:\Users\Log.txt
    if not defined Spath goto end
    if exist X:\Users\ept\upgrade\DontLoad.txt echo %time% ept-install-遇到标签：不需要加载 >>X:\Users\Log.txt
    if exist X:\Users\ept\upgrade\DontLoad.txt goto end
    echo %time% ept-install-读取Edgeless盘符：%Spath%，加载目标路径："%Spath%:\Edgeless\Resource\%name%_%ver%_%au%.7z" >>X:\Users\Log.txt
    pecmd exec -min "%ProgramFiles%\Edgeless\plugin_loader\load.cmd" "%Spath%:\Edgeless\Resource\%name%_%ver%_%au%.7z"
)
goto end


:pLocalBoost
echo ept-install 正在通过LocalBoost安装...
echo %time% ept-install-跳转到LocalBoost处理分支，执行保存 >>X:\Users\Log.txt
echo "%name%_%ver%_%au%.7zl" >savename.txt
call ept-save.cmd

echo %time% ept-install-调用loadUnit安装 >>X:\Users\Log.txt
ren "X:\Users\ept\pack.7zf" "%name%_%ver%_%au%.7z"
if not exist X:\Users\LocalBoost md X:\Users\LocalBoost
echo "X:\Users\ept\%name%_%ver%_%au%.7z">"X:\Users\LocalBoost\pluginPath.txt"
if not exist "X:\Users\LocalBoost\repoPart.txt" pecmd exec ="X:\Program Files\Edgeless\plugin_localboost\GUI.wcs"
if not exist "X:\Users\LocalBoost\repoPart.txt" (
    echo %time% ept-install-用户关闭选择盘符对话框，退出 >>X:\Users\Log.txt
    goto end
)
pecmd exec ="X:\Program Files\Edgeless\plugin_localboost\installToRepo.wcs"
del /f /q "X:\Users\ept\%name%_%ver%_%au%.7z"
echo ept-install-任务完成
goto end


:end
@echo off
echo %time% ept-install-任务完成 >>X:\Users\Log.txt
if exist tmp.txt del /f /q tmp.txt >nul
if exist name.txt del /f /q name.txt >nul
if exist ver.txt del /f /q ver.txt >nul
if exist au.txt del /f /q au.txt >nul
if exist cate.txt del /f /q cate.txt >nul
if exist Y.txt del /f /q Y.txt >nul
if exist A.txt del /f /q A.txt >nul
if exist L.txt del /f /q L.txt >nul
if exist savename.txt del /f /q savename.txt >nul
if exist Spath.txt del /f /q Spath.txt
if exist X:\Users\ept\pack.7zf del /f /q X:\Users\ept\pack.7zf >nul

:forceend
echo on