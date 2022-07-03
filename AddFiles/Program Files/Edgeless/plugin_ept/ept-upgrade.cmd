@echo off
echo %time% ept-upgrade-运行，第一参数：%1 >>X:\Users\Log.txt
set /a retryTime=0
if exist Spath.txt del /f /q Spath.txt
if exist Y_u.txt del /f /q Y_u.txt
if exist X:\Users\ept\upgrade\DontLoad.txt del /f /q X:\Users\ept\upgrade\DontLoad.txt
if exist X:\Users\ept\upgrade\Retry.txt del /f /q X:\Users\ept\upgrade\Retry.txt

::扫描Edgeless启动盘，但是不取出其值，仅做检查
for %%1 in (Z Y X W V U T S R Q P O N M L K J I H G F E D C ) do if exist %%1:\Edgeless\version_Disk.txt echo %%1>Spath.txt
for %%1 in (Z Y X W V U T S R Q P O N M L K J I H G F E D C ) do if exist %%1:\Edgeless\version.txt echo %%1>Spath.txt
if not exist Spath.txt (
    echo ept-upgrade 请插入有效的Edgeless启动盘
    echo %time% ept-upgrade-没有检测到启动盘 >>X:\Users\Log.txt
    goto exitUpgrade
)
if exist Spath.txt del /f /q Spath.txt

::运行版本号比对脚本
echo ept-upgrade 正在对比插件信息...
pecmd load "X:\Program Files\Edgeless\plugin_ept\ept-upgrade.wcs"

::与wcs脚本同步Edgeless盘符
set /p EL_Part=<X:\Users\ept\upgrade\EL_Part.txt
if not defined EL_Part set /p EL_Part=<Spath.txt
if exist Spath.txt del /f /q Spath.txt

if not defined EL_Part (
    echo ept-upgrade 奇怪的错误：Edgeless盘符未定义
    echo %time% ept-upgrade-奇怪的错误：Edgeless盘符未定义 >>X:\Users\Log.txt
    goto endUpgrade
)

if not exist "X:\Users\ept\upgrade\UpgradeList_User.txt" (
    if not exist X:\Users\ept\upgrade\UpgradeList_Invaild.txt echo ept-upgrade 没有可以升级的插件
    echo %time% ept-upgrade-没有可以升级的插件 >>X:\Users\Log.txt
    if exist X:\Users\ept\upgrade\UpgradeList_Invaild.txt (
        echo %time% ept-upgrade-存在未知插件，列出： >>X:\Users\Log.txt
        type X:\Users\ept\upgrade\UpgradeList_Invaild.txt >>X:\Users\Log.txt
        echo ept-upgrade 没有可以升级的插件，不过ept注意到有一些无法识别的插件，请手动关注其更新情况：
        echo.
        echo ----------
        type X:\Users\ept\upgrade\UpgradeList_Invaild.txt
        echo ----------
        echo.
    )
    goto endUpgrade
)
echo ept-upgrade 检测到如下更新
echo.
echo ----------
type "X:\Users\ept\upgrade\UpgradeList_User.txt"
echo ----------
echo.

if /i "%1" == "-y" echo ept-upgrade 将会执行自动更新
if /i "%1" == "-b" echo ept-upgrade 将会执行自动更新但是不加载
if /i "%1" == "-y" echo Y >Y_u.txt
if /i "%1" == "-b" echo Y >Y_u.txt
if /i "%1" == "-b" echo B >X:\Users\ept\upgrade\DontLoad.txt
if exist Y_u.txt echo %time% ept-upgrade-Y_u.txt建立完成 >>X:\Users\Log.txt

if not exist Y_u.txt CHOICE /C ybn /M "您希望开始执行更新吗?（更新/仅下载/取消）"
if %errorlevel%==3 goto endUpgrade
if %errorlevel%==2 echo B >X:\Users\ept\upgrade\DontLoad.txt
echo %time% ept-upgrade-用户确认进行更新，选择：%errorlevel% >>X:\Users\Log.txt
if exist X:\Users\ept\upgrade\DontLoad.txt echo %time% ept-upgrade-DontLoad.txt建立完成 >>X:\Users\Log.txt

echo Start >X:\Users\ept\upgrade\UpgradeTime.txt

echo ept-upgrade 正在转移过期的插件包...
if not exist %EL_Part%:\Edgeless\Resource\过期插件包 md %EL_Part%:\Edgeless\Resource\过期插件包
if not exist %EL_Part%:\Edgeless\Resource\过期插件包 (
    echo ept-upgrade 对%EL_Part%盘的访问遭拒绝，请检查后重试
    echo %time% ept-upgrade-对%EL_Part%盘的访问遭拒绝 >>X:\Users\Log.txt
    goto endUpgrade
)
for /f "usebackq delims==; tokens=*" %%i in ("X:\Users\ept\upgrade\UpgradeList_Path.txt") do (
    move /y "%%i" %EL_Part%:\Edgeless\Resource\过期插件包 >nul
)
ren %EL_Part%:\Edgeless\Resource\过期插件包\*.7z *.7zf


echo ept-upgrade 开始下载更新，手贱点击窗口黑色部分会导致程序暂停
:reDown
for /f "usebackq delims==; tokens=*" %%i in ("X:\Users\ept\upgrade\UpgradeList_Name.txt") do (
    echo ept-upgrade 正在更新%%i
    if exist X:\Users\ept\DownloadFail.txt del /f /q X:\Users\ept\DownloadFail.txt >nul
    if exist X:\Users\ept\SaveFail.txt del /f /q X:\Users\ept\SaveFail.txt >nul
    pecmd exec =!cmd.exe /c "ept-install %%i -a"
    if exist X:\Users\ept\DownloadFail.txt (
        echo ept-upgrade =============错误：下载%%i失败=============
        echo.
        echo %time% ept-upgrade-错误：下载%%i失败 >>X:\Users\Log.txt
        echo %%i>>X:\Users\ept\upgrade\Retry.txt
    )
    if exist X:\Users\ept\SaveFail.txt (
        echo ept-upgrade =============错误：保存%%i失败=============
        echo.
        echo %time% ept-upgrade-错误：保存%%i失败 >>X:\Users\Log.txt
        echo %%i>>X:\Users\ept\upgrade\Retry.txt
    )
)
echo %time% ept-upgrade-当前轮下载任务完成，检查需要重试的插件 >>X:\Users\Log.txt
if "%retryTime%"=="1" (
    if exist Y_u.txt (
        echo %time% ept-upgrade-自动模式，当前已经重试一次，自动退出 >>X:\Users\Log.txt
        echo ept-upgrade 重试自动结束，以下插件的更新失败，请手动启用旧版本：
        type X:\Users\ept\upgrade\Retry.txt
        goto endUpgrade
    )
)
if not exist X:\Users\ept\upgrade\Retry.txt goto skipRetry

    echo ept-upgrade 准备开始对失败的项目进行重试，当前重试次数：%retryTime%，需要重试的插件有：
    type X:\Users\ept\upgrade\Retry.txt
    if not exist Y_u.txt CHOICE /C yn /M "您希望开始重试吗?（确认/取消）"
    echo.
    if %errorlevel%==2 (
        echo ept-upgrade 以下插件的更新失败，请手动启用旧版本（Resource目录下的“过期插件包”文件夹）：
        type X:\Users\ept\upgrade\Retry.txt
        goto endUpgrade
    )
    set /a retryTime+=1
    echo %time% ept-upgrade-开始对失败的项目重试，重试次数：%retryTime%，需要重试的插件有： >>X:\Users\Log.txt
    type X:\Users\ept\upgrade\Retry.txt >>X:\Users\Log.txt
    if exist X:\Users\ept\upgrade\UpgradeList_Name.txt del /f /q X:\Users\ept\upgrade\UpgradeList_Name.txt
    ren X:\Users\ept\upgrade\Retry.txt UpgradeList_Name.txt
    goto reDown

:skipRetry
if exist X:\Users\ept\upgrade\UpgradeTime.txt del /f /q X:\Users\ept\upgrade\UpgradeTime.txt
if exist X:\Users\ept\upgrade\UpgradeList_Invaild.txt (
    echo ept-upgrade 更新完成，不过ept注意到有一些无法识别的插件，请手动关注其更新情况：
        echo %time% ept-upgrade-存在未知插件，列出： >>X:\Users\Log.txt
        type X:\Users\ept\upgrade\UpgradeList_Invaild.txt >>X:\Users\Log.txt
        echo.
        echo ----------
        type X:\Users\ept\upgrade\UpgradeList_Invaild.txt
        echo ----------
        echo.
)
if not exist X:\Users\ept\upgrade\UpgradeList_Invaild.txt echo ept-upgrade 更新完成

:endUpgrade
if exist X:\Users\ept\upgrade\Retry.txt del /f /q X:\Users\ept\upgrade\Retry.txt
if not exist "X:\Users\ept\upgrade\RenameList_FullName.txt" (
    echo ept-upgrade 没有7zl需要处理，退出 >>X:\Users\Log.txt
    goto exitUpgrade
)

::恢复没有被升级的7zl文件
echo ept-upgrade 还原未升级的7zl，名单如下： >>X:\Users\Log.txt
type X:\Users\ept\upgrade\RenameList_FullName.txt >>X:\Users\Log.txt
for /f "usebackq delims==; tokens=*" %%i in ("X:\Users\ept\upgrade\RenameList_FullName.txt") do (
    echo ept-upgrade 检查："%EL_Part%:\Edgeless\Resource\%%i.7z" >>X:\Users\Log.txt
    if exist "%EL_Part%:\Edgeless\Resource\%%i.7z" echo ept-upgrade 还原未升级的7zl：%%i >>X:\Users\Log.txt
    if exist "%EL_Part%:\Edgeless\Resource\%%i.7z" ren "%EL_Part%:\Edgeless\Resource\%%i.7z" "%%i.7zl"
)

::匹配被升级的7zl文件，生成名单
dir /b "%EL_Part%:\Edgeless\Resource\*.7z">X:\Users\ept\upgrade\7zList.txt
echo ept-upgrade 准备还原升级的7zl，生成7z名单： >>X:\Users\Log.txt
type X:\Users\ept\upgrade\7zList.txt >>X:\Users\Log.txt
for /f "usebackq delims==; tokens=*" %%i in ("X:\Users\ept\upgrade\RenameList_Name.txt") do (
    echo %%i>X:\Users\ept\upgrade\matchName.txt
    call ept-upgrade-getmatch.cmd
)
echo ept-upgrade 匹配到的7zl文件名单： >>X:\Users\Log.txt
type X:\Users\ept\upgrade\7zlMatch.txt >>X:\Users\Log.txt

::对名单上的所有插件重命名拓展名为7zl
for /f "usebackq delims==; tokens=*" %%i in ("X:\Users\ept\upgrade\7zlMatch.txt") do (
    echo ept-upgrade 检查："%EL_Part%:\Edgeless\Resource\%%i" >>X:\Users\Log.txt
    if exist "%EL_Part%:\Edgeless\Resource\%%i" echo ept-upgrade 还原升级的7zl：%%i >>X:\Users\Log.txt
    if exist "%EL_Part%:\Edgeless\Resource\%%i" ren "%EL_Part%:\Edgeless\Resource\%%i" "%%il"
)

:exitUpgrade
echo ept-upgrade 程序退出 >>X:\Users\Log.txt
@echo on