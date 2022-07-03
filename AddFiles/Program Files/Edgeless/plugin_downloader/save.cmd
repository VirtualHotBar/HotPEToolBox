echo %time% 插件包下载程序-保存到U盘服务-启动 >>X:\Users\Log.txt
set /p w=<name.txt
echo %time% 插件包下载程序-保存到U盘服务-使用%w%_插件下载器版本.7z作为文件名 >>X:\Users\Log.txt
for %%1 in (Z Y X W V U T S R Q P O N M L K J I H G F E D C ) do if exist %%1:\Edgeless\version_Disk.txt echo %%1>Spath.txt
for %%1 in (Z Y X W V U T S R Q P O N M L K J I H G F E D C ) do if exist %%1:\Edgeless\version.txt echo %%1>Spath.txt
set /p Spath=<Spath.txt
echo %time% 插件包下载程序-保存到U盘服务-使用%Spath%作为Edgeless盘符 >>X:\Users\Log.txt
copy /y "X:\Program Files\Edgeless\plugin_downloader\tar.7zf" "%Spath%:\Edgeless\Resource\%w%_插件下载器版本.7z"
cd /d X:\Windows\System32
if not exist %Spath%:\Edgeless\Resource\%w%_插件下载器版本.7z pecmd file "X:\Program Files\Edgeless\plugin_downloader\tar.7zf"=>"%Spath%:\Edgeless\Resource\%w%_插件下载器版本.7z"
if not exist %Spath%:\Edgeless\Resource\%w%_插件下载器版本.7z echo %time% 插件包下载程序-保存到U盘服务-保存失败 >>X:\Users\Log.txt
if exist %Spath%:\Edgeless\Resource\%w%_插件下载器版本.7z echo %time% 插件包下载程序-保存到U盘服务-保存成功 >>X:\Users\Log.txt
if exist %Spath%:\Edgeless\Resource\%w%_插件下载器版本.7z pecmd exec !"X:\Program Files\Edgeless\dynamic_creator\dynamic_tip.cmd" 3000 Edgeless插件下载器 已将%w%保存至%Spath%盘
exit