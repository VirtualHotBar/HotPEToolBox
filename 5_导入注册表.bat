@echo off
cd /d "%~dp0"
echo 正在导入注册表项

reg import %~dp0Bin\RegistryFiles\SOFT_精简注册表.reg
reg import %~dp0Bin\RegistryFiles\CMD字体和透明.reg
reg import %~dp0Bin\RegistryFiles\HDTunePro.reg
reg import %~dp0Bin\RegistryFiles\Pecmd.ini.reg
reg import %~dp0Bin\RegistryFiles\StartIsBack_浅.reg
reg import %~dp0Bin\RegistryFiles\Windows颜色模式浅.reg
reg import %~dp0Bin\RegistryFiles\打开HotPE模块.reg
reg import %~dp0Bin\RegistryFiles\任务管理器默认详细信息.reg
reg import %~dp0Bin\RegistryFiles\任务栏合并按钮.reg
reg import %~dp0Bin\RegistryFiles\任务栏图标.reg
reg import %~dp0Bin\RegistryFiles\鼠标指针.reg
reg import %~dp0Bin\RegistryFiles\开始菜单不显示搜索.reg
reg import %~dp0Bin\RegistryFiles\开始菜单不显示最近打开项.reg
reg import %~dp0Bin\RegistryFiles\控制面板界面.reg
reg import %~dp0Bin\RegistryFiles\控制面板删除管理工具.reg
reg import %~dp0Bin\RegistryFiles\控制面板删除任务栏和导航.reg
reg import %~dp0Bin\RegistryFiles\控制面板删除设备和打印机.reg
reg import %~dp0Bin\RegistryFiles\控制面板删除无效图标.reg
reg import %~dp0Bin\RegistryFiles\控制面板删除字体.reg
reg import "%~dp0Bin\RegistryFiles\删除右键3D Edit.reg"
reg import %~dp0Bin\RegistryFiles\删除右键包含到库.reg
reg import %~dp0Bin\RegistryFiles\删除右键个性化和显示设置.reg
reg import %~dp0Bin\RegistryFiles\删除右键恢复到之前版本.reg
reg import %~dp0Bin\RegistryFiles\删除右键设为壁纸.reg
reg import %~dp0Bin\RegistryFiles\删除资源管理器内桌面等文件夹.reg
reg import %~dp0Bin\RegistryFiles\视觉效果.reg
reg import %~dp0Bin\RegistryFiles\修复此电脑右键管理.reg
reg import %~dp0Bin\RegistryFiles\隐藏3D对象等文件夹.reg
reg import %~dp0Bin\RegistryFiles\隐藏导航窗格.reg
reg import %~dp0Bin\RegistryFiles\隐藏开始菜单启动和管理工具.reg
reg import %~dp0Bin\RegistryFiles\隐藏映射网络驱动器.reg
reg import %~dp0Bin\RegistryFiles\隐藏3D对象等文件夹.reg
reg import %~dp0Bin\RegistryFiles\电源键默认重启.reg
reg import %~dp0Bin\RegistryFiles\计算机属性.reg
reg import %~dp0Bin\RegistryFiles\绕过TPM检测.reg
reg import %~dp0Bin\RegistryFiles\右键用记事本打开文件.reg
reg import %~dp0Bin\RegistryFiles\右键显示设置.reg
reg import %~dp0Bin\RegistryFiles\HashTab.reg
reg import %~dp0Bin\RegistryFiles\WinX开机动画.reg