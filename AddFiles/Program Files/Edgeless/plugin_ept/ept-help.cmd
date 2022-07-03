@echo off
echo %time% ept-help-运行 >>X:\Users\Log.txt
echo.
echo Edgeless插件包管理工具
echo.
echo 语法：
echo    ept install 或 ept-install 或 ept-get install [序号] {-y /-a /-l}/[软件名] {-y /-a /-l}/[关键词]
echo        安装指定插件或搜索插件，参数-y表自动安装，参数-a表自动安装并保存，参数-l表通过LocalBoost安装并保存
echo.
echo    ept search 或 ept-search 或 ept-cache search [关键词]
echo        搜索指定插件并列出序号
echo.
echo    ept remove 或 ept-remove 或 ept-get remove [序号] {-y}/[关键词]
echo        移除指定插件或列出指定已加载的插件的序号，参数-y表自动移除
echo.
echo    ept update 或 ept-update 或 ept-get update
echo        更新本地索引
echo.
echo    ept upgrade 或 ept-upgrade 或 ept-get upgrade {-y /-b}
echo        升级启动盘中的插件，参数-y表自动升级，参数-b表自动升级但仅下载
echo.
echo    ept getver 或 ept-getver 或 ept-cache madison [软件名]
echo        列出指定插件的最新版本号
echo.
@echo on