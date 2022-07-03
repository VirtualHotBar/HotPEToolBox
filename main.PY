#!/usr/bin/python
# -*- coding: UTF-8 -*-
import sys
import os
import configparser

def 清空目录 (path):
    os.system("rd /s /Q \""+ path + "\"")
    if os.path.exists(path)==False:
        os.makedirs(path)
    return
def 复制目录 (path,pathGoTo):
    os.system("xcopy \""+ path+"\" \"" + pathGoTo + "\" /Q /Y /H /R /E")
    return
def 挂载配置单元 (FileName,KeyName):
    os.system ("reg load "+KeyName+" \""+FileName+"\"")
    return
def 卸载配置单元 (KeyName):
    os.system ("reg unload "+KeyName)
    return
def 导入注册表项 (FileName):
    os.system ("reg import \""+FileName+"\"")
    return
def 复制注册表项 (KeyName,toKeyName):
    os.system ("reg copy \""+KeyName+"\" \""+toKeyName+"\"  /S /F")
    return    
def 加密PECMD脚本 (path):
    os.system(运行目录+"Bin\Tools\pecmd.exe \"CMPS -bin "+path+","+path+".new\"")
    os.remove(path)
    os.rename(path+".new",path)
    return


os.system("title HotPE生成脚本")


运行目录 = os.path.split( os.path.realpath( sys.argv[0] ) )[0] + "\\"
执行文件名 =sys.argv[0]

# 初始化
PE配置 = configparser.ConfigParser()

# 读取配置文件
PE配置.read(运行目录 +'PE_config.txt', encoding='ANSI')

print("正在清理文件")
清空目录 (运行目录 + "TempFile\\apply")
清空目录 (运行目录 + "TempFile\\config")

bootWim = 运行目录 + "boot.wim"
boot分卷 = PE配置.get('wim', 'boot分卷')
wimlibImagex= 运行目录 + "Bin\\Tools\\wimlib\\wimlib-imagex.exe"

print("正在从boot.wim提取文件")

os.system(wimlibImagex+" apply "+bootWim+" "+str(boot分卷)+" "+运行目录+"TempFile\\apply")

print("正在从删除无用文件")
for line in open(运行目录+"delFiles.txt", "r"):  #打开文件
    rs = line.rstrip('\n')  # 移除行尾换行符
    if os.path.isfile(运行目录+"TempFile\\apply\\"+rs):
        os.system("del "+运行目录+"TempFile\\apply\\"+rs+" /F /Q")
    if os.path.isdir(运行目录+"TempFile\\apply\\"+rs):
        os.system("rd "+运行目录+"TempFile\\apply\\"+rs+" /S /Q")

print("正在添加文件:AddFiles\*")
复制目录(运行目录+"AddFiles",运行目录+"TempFile\\apply")

print("正在添加文件:Edgeless\*")
复制目录(运行目录+"Edgeless",运行目录+"TempFile\\apply")

print("正在加密Pecmd脚本文件")
#加密PECMD脚本(运行目录+"TempFile\\apply\\windows\\system32\\PECMD.ini")
#加密PECMD脚本(运行目录+"TempFile\\apply\\Program Files\\PETools.ini")
#加密PECMD脚本(运行目录+"TempFile\\apply\\Program Files\\RegistryFiles\\Edgeless\\注册Edgeless.ini")

print("正在挂载配置单元")
挂载配置单元 (运行目录+"TempFile\\config\\drivers","hklm\os_drv")
挂载配置单元 (运行目录+"TempFile\\config\\system","hklm\os_sys")
挂载配置单元 (运行目录+"TempFile\\apply\\windows\\system32\\config\\default","hklm\pe_def")
挂载配置单元 (运行目录+"TempFile\\apply\\windows\\system32\\config\\software","hklm\pe_soft")
挂载配置单元 (运行目录+"TempFile\\apply\\windows\\system32\\config\\system","hklm\pe_sys")
挂载配置单元 (运行目录+"TempFile\\apply\\windows\\system32\\config\\DRIVERS","hklm\pe_drv")

print("正在导入注册表项")

导入注册表项 (运行目录 + "Bin\\RegistryFiles\\SOFT_精简注册表.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\CMD字体和透明.reg")
#导入注册表项 (运行目录 + "Bin\\RegistryFiles\\explorer.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\HDTunePro.reg")
#导入注册表项 (运行目录 + "Bin\\RegistryFiles\\pe_def.reg")
#导入注册表项 (运行目录 + "Bin\\RegistryFiles\\pe_soft.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\Pecmd.ini.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\StartIsBack_浅.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\Windows颜色模式浅.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\打开HotPE模块.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\任务管理器默认详细信息.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\任务栏合并按钮.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\任务栏图标.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\鼠标指针.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\开始菜单不显示搜索.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\开始菜单不显示最近打开项.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\控制面板界面.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\控制面板删除管理工具.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\控制面板删除任务栏和导航.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\控制面板删除设备和打印机.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\控制面板删除无效图标.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\控制面板删除字体.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\删除右键3D Edit.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\删除右键包含到库.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\删除右键个性化和显示设置.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\删除右键恢复到之前版本.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\删除右键设为壁纸.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\删除资源管理器内桌面等文件夹.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\视觉效果.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\修复此电脑右键管理.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\隐藏3D对象等文件夹.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\隐藏导航窗格.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\隐藏开始菜单启动和管理工具.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\隐藏映射网络驱动器.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\隐藏3D对象等文件夹.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\电源键默认重启.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\计算机属性.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\绕过TPM检测.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\右键用记事本打开文件.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\右键显示设置.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\HashTab.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\WinX开机动画.reg")


#os.system(运行目录 + "Bin\\Tools\\regfind.exe"+" -p HKEY_LOCAL_MACHINE\\pe_soft -y C:\\ -y -r X:\\")

#os.system(运行目录 + "Bin\\Tools\\regfind.exe"+" -p HKEY_LOCAL_MACHINE\\pe_soft\Classes\AppID -y Interactive User -r")

#os.system(运行目录 + "copyDriver.bat")

#导入注册表项 (运行目录 + "Bin\\RegistryFiles\\pe_drv.reg")  

print("正在修改图标")
if os.path.exists(运行目录+"TempFile\\apply\\Windows\\System32\\imageres.dll"):
    os.system("copy \""+运行目录+"TempFile\\apply\\Windows\System32\\imageres.dll\" \""+运行目录+"Bin\\imageres_dll\\imageres.dll\"")
    os.system(运行目录 + "Bin\\imageres_dll\\cmd.bat")
    os.system("del "+运行目录+"TempFile\\apply\\windows\\system32\\imageres.dll /F /S /Q")
    os.system("del "+运行目录+"TempFile\\apply\\windows\\SysWOW64\\imageres.dll /F /S /Q")
    os.system("copy \""+运行目录+"Bin\\imageres_dll\\new_imageres.dll\" \""+运行目录+"TempFile\\apply\\windows\\system32\\imageres.dll\"")
    os.system("copy \""+运行目录+"Bin\\imageres_dll\\new_imageres.dll\" \""+运行目录+"TempFile\\apply\\windows\\SysWOW64\\imageres.dll\"")
    #os.system("del "+运行目录+"TempFile\\imageres32.dll /F /S /Q")
    #os.system("del "+运行目录+"TempFile\\temp_imageres32.dll /F /S /Q")
    #os.system("del "+运行目录+"TempFile\\new_imageres32.dll /F /S /Q")

print("正在卸载配置单元")
卸载配置单元 ("hklm\os_drv")
卸载配置单元 ("hklm\os_sys")
卸载配置单元 ("hklm\pe_def")
卸载配置单元 ("hklm\pe_soft")
卸载配置单元 ("hklm\pe_sys")
卸载配置单元 ("hklm\pe_drv")

os.system("del /f /q /ah \"" + 运行目录 + "TempFile\\apply\\Windows\\System32\\config\\*.*\"")

print("正在破解USB弹出功能文件")
os.system(运行目录 +"Bin\\Tools\\binmay.exe -u \"" + 运行目录 + "TempFile\\apply\\Windows\\System32\\DeviceSetupManager.dll\" -s u:SystemSetupInProgress -r u:DisableDeviceSetupMgr")

print("正在删除dll备份文件")
os.system("del \"" + 运行目录 + "TempFile\\apply\\Windows\\System32\\DeviceSetupManager.dll.org\"")

print("正在打包成Kernel.wim")
os.system(wimlibImagex+" capture \"" + 运行目录 + "TempFile\\apply\" \""+运行目录+"\\Kernel.wim\" \"HotPE\" --boot --compress=lzx --rebuild")

print("正在打包成ISO")
os.system("del "+运行目录+"TempFile\\ISO\\HotPE\\Kernel.wim /F /S /Q")
os.system("copy \""+运行目录+"Kernel.wim\" \""+运行目录+"TempFile\\ISO\\HotPE\\Kernel.wim\"")
os.system(运行目录 +"Bin\\Tools\\oscdimg.exe  -m -o -u2 -udfver102 -h -bootdata:2#p0,e,b"+运行目录+"Bin\\Tools\\Etfsboot.com#pEF,e,b"+运行目录+"Bin\\Tools\\Efisys.bin -l\"HotPE工具箱\" "+运行目录+"TempFile\\ISO\\ "+运行目录+"HotPE工具箱.iso")

input("构建结束，回车启动虚拟机测试")
os.system(运行目录 + "启动虚拟机测试.bat")
