echo %time% 过期插件包比对程序-全部禁用-运行 >>X:\Users\Log.txt
for %%1 in (C Z Y X W V U T S R Q P O N M L K J I H G F E D ) do if exist %%1:\Edgeless\Resource echo %%1>Opath.txt
set /p Opath=<Opath.txt
echo %time% 过期插件包比对程序-全部禁用-使用%Opath%作为Edgeless盘符 >>X:\Users\Log.txt
echo %time% 过期插件包比对程序-全部禁用-程序执行前文件列表 >>X:\Users\Log.txt
dir /b "%Upath%:\Edgeless\Resource\*.*" >>X:\Users\Log.txt
cd /d %Upath%:\Edgeless\Resource
for /f  "usebackq" %%a in  (X:\Users\outdated.txt) do (
    ren %%a %%a_过期的插件.7zf
)
echo %time% 过期插件包比对程序-全部禁用-程序执行后文件列表 >>X:\Users\Log.txt
dir /b "%Upath%:\Edgeless\Resource\*.*" >>X:\Users\Log.txt
if exist X:\Users\outdated.txt del /f /q X:\Users\outdated.txt
pecmd exec explorer %Opath%:\Edgeless\Resource
exit