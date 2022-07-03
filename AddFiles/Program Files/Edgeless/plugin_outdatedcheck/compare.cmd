echo %time% 过期插件包比对程序-运行 >>X:\Users\Log.txt
if exist X:\Users\outdated.txt del /f /q X:\Users\outdated.txt
for %%1 in (C Z Y X W V U T S R Q P O N M L K J I H G F E D ) do if exist %%1:\Edgeless\version_Disk.txt echo %%1>Opath.txt
for %%1 in (C Z Y X W V U T S R Q P O N M L K J I H G F E D ) do if exist %%1:\Edgeless\version.txt echo %%1>Opath.txt
set /p Upath=<Opath.txt

echo %time% 过期插件包比对程序-使用%Upath%作为Edgeless盘符 >>X:\Users\Log.txt
echo %time% 过期插件包比对程序-获得文件列表 >>X:\Users\Log.txt
dir /b "%Upath%:\Edgeless\Resource\*.*" >>X:\Users\Log.txt

dir /b "%Upath%:\Edgeless\Resource\*.7z" >7zlist.txt
for /f  "usebackq" %%a in  (7zlist.txt) do (

if "%%a" == "插件下载器.7z" echo %%a >> X:\Users\outdated.txt
if "%%a" == "插件加载工具.7z" echo %%a >> X:\Users\outdated.txt
if "%%a" == "修正盘符错乱(提取自微PE).7z" echo %%a >> X:\Users\outdated.txt
if "%%a" == "VMTools_10.2.5.3619_Cno.7z" echo %%a >> X:\Users\outdated.txt
if "%%a" == "VMTools.7z" echo %%a >> X:\Users\outdated.txt
if "%%a" == "迅雷极速版.7z" echo %%a >> X:\Users\outdated.txt
if "%%a" == "迅雷极速版_Ver2.0.7z" echo %%a >> X:\Users\outdated.txt
if "%%a" == "迅雷极速版_1.0.35.366_Cno.7z" echo %%a >> X:\Users\outdated.txt
if "%%a" == "WiFi.7z" echo %%a >> X:\Users\outdated.txt
if "%%a" == "WiFi_Beta_2.0.7z" echo %%a >> X:\Users\outdated.txt
if "%%a" == "WiFi_2.0.0.0_Cno.7z" echo %%a >> X:\Users\outdated.txt
if "%%a" == "微软五笔.7z" echo %%a >> X:\Users\outdated.txt
if "%%a" == "微软五笔_1.0.0.0_Cno.7z" echo %%a >> X:\Users\outdated.txt
if "%%a" == "UjyQii.7z" echo %%a >> X:\Users\outdated.txt
if "%%a" == "优捷易UjyQii_4.5.1.0_Cno.7z" echo %%a >> X:\Users\outdated.txt
if "%%a" == "傲梅分区助手技术员版_8.3.0.0_Cno.7z" echo %%a >> X:\Users\outdated.txt
if "%%a" == "傲梅分区助手企业版_8.2.0.0_Cno.7z" echo %%a >> X:\Users\outdated.txt
if "%%a" == "ept_Cno_null.7z" echo %%a >> X:\Users\outdated.txt



if "%%a" == "Nes_Inport.7z" echo %%a >> X:\Users\outdated.txt
if "%%a" == "Nes_Inport.7z" md X:\Users\nes_reload
)
if not exist X:\Users\outdated.txt echo %time% 过期插件包比对程序-没有过期插件 >>X:\Users\Log.txt
if not exist X:\Users\outdated.txt exit
echo %time% 过期插件包比对程序-存在过期插件 >>X:\Users\Log.txt
type X:\Users\outdated.txt >>X:\Users\Log.txt
cd /d X:\Windows\System32
xcmd.exe "X:\Program Files\Edgeless\plugin_outdatedcheck\outp.wcs"
exit