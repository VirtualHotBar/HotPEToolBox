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



光驱盘符 = input ("输入虚拟光驱盘符(不加冒号)：")
installWim = 光驱盘符 + ":\\sources\\install.wim"
bootWim = 光驱盘符 + ":\\sources\\boot.wim"
boot分卷 = PE配置.get('wim', 'boot分卷')
install分卷 = PE配置.get('wim', 'install分卷')
wimlibImagex= 运行目录 + "Bin\\Tools\\wimlib\\wimlib-imagex.exe"

print("正在从boot.wim提取文件")

os.system(wimlibImagex+" apply "+bootWim+" "+str(boot分卷)+" "+运行目录+"TempFile\\apply")

print("正在从boot.wim提取Cat文件")
清空目录 (运行目录 + "TempFile\\apply\\Windows\\System32\\CatRoot\\{127D0A1D-4EF2-11D1-8608-00C04FC295EE}\\")
清空目录 (运行目录 + "TempFile\\apply\\Windows\\System32\\CatRoot\\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\\")
os.system(wimlibImagex+" extract "+bootWim+" "+str(boot分卷)+" @"+运行目录+"Bin\\Files\\Cat.txt "+"--dest-dir="+运行目录+"TempFile\\apply "+" --nullglob --no-acls")

print("正在清理WinSxS文件")
清空目录 (运行目录 + "TempFile\\apply\\Windows\\WinSxS\\")

print("正在从install.wim提取文件")
#os.system(wimlibImagex+" extract "+installWim+" "+str(install分卷)+" \Windows\System32\Recovery\winre.wim "+"--dest-dir="+运行目录+"TempFile\\ "+" --nullglob --no-acls")
os.system(wimlibImagex+" extract "+installWim+" "+str(install分卷)+" @"+运行目录+"Bin\\Files\\install.txt "+"--dest-dir="+运行目录+"TempFile\\apply "+" --nullglob --no-acls")

print("正在从删除无用文件")
for line in open(运行目录+"Bin\\Files\\delFiles.txt", "r"):  #打开文件
    rs = line.rstrip('\n')  # 移除行尾换行符
    if os.path.isfile(运行目录+"TempFile\\apply\\"+rs):
        os.system("del "+运行目录+"TempFile\\apply\\"+rs+" /F /Q")
    if os.path.isdir(运行目录+"TempFile\\apply\\"+rs):
        os.system("rd "+运行目录+"TempFile\\apply\\"+rs+" /S /Q")

for line in open(运行目录+"Bin\\Files\\delFilesMore.txt", "r"):  #打开文件
    rs = line.rstrip('\n')  # 移除行尾换行符
    if os.path.isfile(运行目录+"TempFile\\apply\\"+rs):
        os.system("del "+运行目录+"TempFile\\apply\\"+rs+" /F /Q")
    if os.path.isdir(运行目录+"TempFile\\apply\\"+rs):
        os.system("rd "+运行目录+"TempFile\\apply\\"+rs+" /S /Q")

for line in open(运行目录+"Bin\\Files\\delFilesMore(drivers).txt", "r"):  #打开文件
    rs = line.rstrip('\n')  # 移除行尾换行符
    if os.path.isfile(运行目录+"TempFile\\apply\\"+rs):
        os.system("del "+运行目录+"TempFile\\apply\\"+rs+" /F /Q")
    if os.path.isdir(运行目录+"TempFile\\apply\\"+rs):
        os.system("rd "+运行目录+"TempFile\\apply\\"+rs+" /S /Q")

for line in open(运行目录+"Bin\\Files\\clearDir.txt", "r"):  #打开文件
    rs = line.rstrip('\n')  # 移除行尾换行符
    清空目录(运行目录+"TempFile\\apply\\"+rs)
    
print("正在从install.wim提取注册表文件:system,drivers")
os.system(wimlibImagex+" extract "+installWim+" "+str(install分卷)+" \Windows\System32\config\system "+"--dest-dir="+运行目录+"TempFile\\config "+" --nullglob --no-acls")
os.system(wimlibImagex+" extract "+installWim+" "+str(install分卷)+" \Windows\System32\config\drivers "+"--dest-dir="+运行目录+"TempFile\\config "+" --nullglob --no-acls")

print("正在添加文件:AddFiles\*")
复制目录(运行目录+"AddFiles",运行目录+"TempFile\\apply")

print("正在加密Pecmd脚本文件")
#加密PECMD脚本(运行目录+"TempFile\\apply\\windows\\system32\\PECMD.ini")

print("正在挂载配置单元")
挂载配置单元 (运行目录+"TempFile\\config\\drivers","hklm\os_drv")
挂载配置单元 (运行目录+"TempFile\\config\\system","hklm\os_sys")
挂载配置单元 (运行目录+"TempFile\\apply\\windows\\system32\\config\\default","hklm\pe_def")
挂载配置单元 (运行目录+"TempFile\\apply\\windows\\system32\\config\\software","hklm\pe_soft")
挂载配置单元 (运行目录+"TempFile\\apply\\windows\\system32\\config\\system","hklm\pe_sys")
挂载配置单元 (运行目录+"TempFile\\apply\\windows\\system32\\config\\DRIVERS","hklm\pe_drv")

print("正在导入注册表项")

导入注册表项 (运行目录 + "Bin\\RegistryFiles\\explorer.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\pe_def.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\pe_soft.reg")
导入注册表项 (运行目录 + "Bin\\RegistryFiles\\Pecmd.ini.reg")

print("正在修改C:\\为X:\\")
os.system(运行目录 + "Bin\\Tools\\regfind.exe"+" -p HKEY_LOCAL_MACHINE\\pe_soft -y C:\\ -y -r X:\\")

print("正在处理Interactive User")
os.system(运行目录 + "Bin\\Tools\\regfind.exe"+" -p HKEY_LOCAL_MACHINE\\pe_soft\Classes\AppID -y Interactive User -r")

print("复制必要的SYSTEM注册表到PE")
for line in open(运行目录+"\\Bin\\RegistryFiles\\pe_sys.txt", "r"):  #打开文件
    rs = line.rstrip('\n')  # 移除行尾换行符
    复制注册表项("hklm\\os_sys\\"+rs,"hklm\\pe_sys\\"+rs)

导入注册表项 (运行目录 + "Bin\\RegistryFiles\\pe_sys.reg")

print("复制必要的drivers注册表到PE")
for line in open(运行目录+"\\Bin\\RegistryFiles\\pe_drv.txt", "r"):  #打开文件
    rs = line.rstrip('\n')  # 移除行尾换行符
    复制注册表项("hklm\\os_drv\\"+rs,"hklm\\pe_drv\\"+rs)

os.system(运行目录 + "copyDriver.bat")

导入注册表项 (运行目录 + "Bin\\RegistryFiles\\pe_drv.reg")  


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
