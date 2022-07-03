echo %time% 7zf处理程序-运行 >>X:\Users\Log.txt
echo %time% 7zf处理程序-目标插件包 >>X:\Users\Log.txt
echo %1 >>X:\Users\Log.txt

::处理正常的加载请求

rd X:\Users\load7zf
echo %time% 7zf处理程序-载入插件包 >>X:\Users\Log.txt
pecmd exec ="%ProgramFiles%\Edgeless\plugin_loader\load.cmd" %1
"X:\Program Files\Edgeless\plugin_loader\pecmd.exe" "X:\Program Files\Edgeless\plugin_loader\7zftip.wcs"
exit


