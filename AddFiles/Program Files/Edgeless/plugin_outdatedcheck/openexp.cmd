for %%1 in (C Z Y X W V U T S R Q P O N M L K J I H G F E D ) do if exist %%1:\Edgeless\Resource echo %%1>Opath.txt
set /p Opath=<Opath.txt
echo %time% 过期插件包比对程序-手动管理-使用%Opath%作为Edgeless盘符 >>X:\Users\Log.txt
pecmd exec explorer %Opath%:\Edgeless\Resource
exit