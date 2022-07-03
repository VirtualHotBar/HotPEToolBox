echo %time% ept-save-启动 >>X:\Users\Log.txt
set /p w=<savename.txt
if exist savename.txt del /f /q savename.txt
if exist Spath.txt del /f /q Spath.txt
if exist X:\Users\ept\SaveFail.txt del /f /q X:\Users\ept\SaveFail.txt >nul
echo %time% ept-save-使用%w:~1,-2%作为文件名 >>X:\Users\Log.txt
for %%1 in (Z Y X W V U T S R Q P O N M L K J I H G F E D C ) do if exist %%1:\Edgeless\version_Disk.txt echo %%1>Spath.txt
for %%1 in (Z Y X W V U T S R Q P O N M L K J I H G F E D C ) do if exist %%1:\Edgeless\version.txt echo %%1>Spath.txt
if not exist Spath.txt (
    echo ept-install 保存%w:~1,-2%失败，未检测到合法的Edgeless启动盘
    goto endSave
)
set /p Spath=<Spath.txt
echo %time% ept-save-使用%Spath%作为Edgeless盘符 >>X:\Users\Log.txt
@copy /y "X:\Users\ept\pack.7zf" "%Spath%:\Edgeless\Resource\%w:~1,-2%" >nul
if not exist "%Spath%:\Edgeless\Resource\%w:~1,-2%" pecmd file "X:\Users\ept\pack.7zf"=>"%Spath%:\Edgeless\Resource\%w:~1,-2%"
if not exist "%Spath%:\Edgeless\Resource\%w:~1,-2%" echo %time% ept-install-保存到U盘服务-保存失败 >>X:\Users\Log.txt
if exist "%Spath%:\Edgeless\Resource\%w:~1,-2%" echo %time% ept-install-保存到U盘服务-保存成功 >>X:\Users\Log.txt
if exist "%Spath%:\Edgeless\Resource\%w:~1,-2%" echo ept-install 已将%w:~1,-2%保存至%Spath%盘
if not exist "%Spath%:\Edgeless\Resource\%w:~1,-2%" (
    echo ept-install 保存%w:~1,-2%至%Spath%盘失败
    echo Fail >X:\Users\ept\SaveFail.txt
)
:endSave
if not exist X:\Users\ept\upgrade\UpgradeTime.txt (
    if exist Spath.txt del /f /q Spath.txt
)