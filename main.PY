from __future__ import print_function
import ctypes
from runpy import run_path
import os
import sys
import os
import configparser
import time

runPath = os.path.split( os.path.realpath( sys.argv[0] ) )[0] + "\\"
runFile =sys.argv[0]



def emptyDir (path):#清空目录
    os.system("rd /s /Q \""+ path + "\"")
    if os.path.exists(path)==False:
        os.makedirs(path)
    return

def copyDir (path,pathGoTo):#复制目录
    os.system("xcopy \""+ path+"\" \"" + pathGoTo + "\" /Q /Y /H /R /E")
    return

def loadConfigUnit (FileName,KeyName):#加载配置单元
    os.system ("reg load "+KeyName+" \""+FileName+"\"")
    return

def unloadConfigUnit (KeyName):#卸载配置单元
    os.system ("reg unload "+KeyName)
    return

def importReg (FileName):#导入注册表
    os.system ("reg import \""+FileName+"\"")
    return

def copyRegKey (KeyName,toKeyName):#复制注册表项
    os.system ("reg copy \""+KeyName+"\" \""+toKeyName+"\"  /S /F")
    return

def encryptPecmdScript (path):#加密PECMD脚本
    os.system(runPath+"Bin\Tools\pecmd.exe \"CMPS -bin "+path+","+path+".new\"")
    os.remove(path)
    os.rename(path+".new",path)
    return

def begin ():
    # 初始化
    os.system("title HotPEBuildTools 2.4.2022.8")
    
    print("正在清理文件\n")
    emptyDir (runPath+"TempFile\\apply")
    emptyDir (runPath + "TempFile\\apply")
    emptyDir (runPath + "TempFile\\config")

    wimlibImagex= runPath + "Bin\\Tools\\wimlib\\wimlib-imagex.exe"

    isoLetter = input ("输入虚拟光驱盘符(不加冒号)：")
    print("\n")

    installWim = isoLetter + ":\\sources\\install.wim"
    bootWim = isoLetter + ":\\sources\\boot.wim"

    os.system (wimlibImagex + " info "+isoLetter+":\\sources\\boot.wim|FIND  \"Description\" ")
    bootVolume = input ("输入Boot.wim分卷(从1开始)：")
    print("\n")

    os.system (wimlibImagex + " info "+isoLetter+":\\sources\\install.wim|FIND  \"Display Name\" ")
    installVolume = input ("输入install.wim分卷(从1开始)：")

    print("\n正在从boot.wim提取文件")
    
    os.system(wimlibImagex+" apply "+bootWim+" "+str(bootVolume)+" "+runPath+"TempFile\\apply")

    print("\n正在从boot.wim提取Cat文件")
    emptyDir (runPath + "TempFile\\apply\\Windows\\System32\\CatRoot\\{127D0A1D-4EF2-11D1-8608-00C04FC295EE}\\")
    emptyDir (runPath + "TempFile\\apply\\Windows\\System32\\CatRoot\\{F750E6C3-38EE-11D1-85E5-00C04FC295EE}\\")
    os.system(wimlibImagex+" extract "+bootWim+" "+str(bootVolume)+" @"+runPath+"Bin\\Files\\Cat.txt "+"--dest-dir="+runPath+"TempFile\\apply "+" --nullglob --no-acls")

    print("\n正在清理WinSxS文件")
    emptyDir (runPath + "TempFile\\apply\\Windows\\WinSxS\\")

    print("\n正在从install.wim提取文件")
    #os.system(wimlibImagex+" extract "+installWim+" "+str(installVolume)+" \Windows\System32\Recovery\winre.wim "+"--dest-dir="+runPath+"TempFile\\ "+" --nullglob --no-acls")
    os.system(wimlibImagex+" extract "+installWim+" "+str(installVolume)+" @"+runPath+"Bin\\Files\\install.txt "+"--dest-dir="+runPath+"TempFile\\apply "+" --nullglob --no-acls")

    print("\n正在删除无用文件")
    for line in open(runPath+"Bin\\Files\\delFiles.txt", "r"):  #打开文件
        rs = line.rstrip('\n')  # 移除行尾换行符
        if os.path.isfile(runPath+"TempFile\\apply\\"+rs):
            os.system("del "+runPath+"TempFile\\apply\\"+rs+" /F /Q")
        if os.path.isdir(runPath+"TempFile\\apply\\"+rs):
            os.system("rd "+runPath+"TempFile\\apply\\"+rs+" /S /Q")

    for line in open(runPath+"Bin\\Files\\delFilesMore.txt", "r"):  #打开文件
        rs = line.rstrip('\n')  # 移除行尾换行符
        if os.path.isfile(runPath+"TempFile\\apply\\"+rs):
            os.system("del "+runPath+"TempFile\\apply\\"+rs+" /F /Q")
        if os.path.isdir(runPath+"TempFile\\apply\\"+rs):
            os.system("rd "+runPath+"TempFile\\apply\\"+rs+" /S /Q")

    for line in open(runPath+"Bin\\Files\\delFilesMore(drivers).txt", "r"):  #打开文件
        rs = line.rstrip('\n')  # 移除行尾换行符
        if os.path.isfile(runPath+"TempFile\\apply\\"+rs):
            os.system("del "+runPath+"TempFile\\apply\\"+rs+" /F /Q")
        if os.path.isdir(runPath+"TempFile\\apply\\"+rs):
            os.system("rd "+runPath+"TempFile\\apply\\"+rs+" /S /Q")

    for line in open(runPath+"Bin\\Files\\clearDir.txt", "r"):  #打开文件
        rs = line.rstrip('\n')  # 移除行尾换行符
        emptyDir(runPath+"TempFile\\apply\\"+rs)
    
    print("\n正在从install.wim提取注册表文件:system,drivers")
    os.system(wimlibImagex+" extract "+installWim+" "+str(installVolume)+" \Windows\System32\config\system "+"--dest-dir="+runPath+"TempFile\\config "+" --nullglob --no-acls")
    os.system(wimlibImagex+" extract "+installWim+" "+str(installVolume)+" \Windows\System32\config\drivers "+"--dest-dir="+runPath+"TempFile\\config "+" --nullglob --no-acls")

    print("\n正在添加文件:AddFiles\*")
    copyDir(runPath+"AddFiles",runPath+"TempFile\\apply")
    

    print("\n正在加密Pecmd脚本文件")
    encryptPecmdScript(runPath+"TempFile\\apply\\windows\\system32\\PECMD.ini")
    

    print("\n正在挂载配置单元")
    
    loadConfigUnit (runPath+"TempFile\\config\\drivers","hklm\os_drv")
    loadConfigUnit (runPath+"TempFile\\config\\system","hklm\os_sys")
    loadConfigUnit (runPath+"TempFile\\apply\\windows\\system32\\config\\default","hklm\pe_def")
    loadConfigUnit (runPath+"TempFile\\apply\\windows\\system32\\config\\software","hklm\pe_soft")
    loadConfigUnit (runPath+"TempFile\\apply\\windows\\system32\\config\\system","hklm\pe_sys")
    loadConfigUnit (runPath+"TempFile\\apply\\windows\\system32\\config\\DRIVERS","hklm\pe_drv")

    print("\n正在导入注册表项")
    
    importReg (runPath + "Bin\\RegistryFiles\\explorer.reg")
    importReg (runPath + "Bin\\RegistryFiles\\pe_def.reg")
    importReg (runPath + "Bin\\RegistryFiles\\pe_soft.reg")
    importReg (runPath + "Bin\\RegistryFiles\\Pecmd.ini.reg")

    importReg (runPath + "Bin\\RegistryFiles\\SOFT_精简注册表.reg")
    importReg (runPath + "Bin\\RegistryFiles\\CMD字体和透明.reg")
    importReg (runPath + "Bin\\RegistryFiles\\HDTunePro.reg")
    importReg (runPath + "Bin\\RegistryFiles\\StartIsBack_浅.reg")
    importReg (runPath + "Bin\\RegistryFiles\\Windows颜色模式浅.reg")
    importReg (runPath + "Bin\\RegistryFiles\\打开HotPE模块.reg")
    importReg (runPath + "Bin\\RegistryFiles\\任务管理器默认详细信息.reg")
    importReg (runPath + "Bin\\RegistryFiles\\任务栏合并按钮.reg")
    importReg (runPath + "Bin\\RegistryFiles\\任务栏图标.reg")
    importReg (runPath + "Bin\\RegistryFiles\\鼠标指针.reg")
    importReg (runPath + "Bin\\RegistryFiles\\开始菜单不显示搜索.reg")
    importReg (runPath + "Bin\\RegistryFiles\\开始菜单不显示最近打开项.reg")
    importReg (runPath + "Bin\\RegistryFiles\\控制面板界面.reg")
    importReg (runPath + "Bin\\RegistryFiles\\控制面板删除管理工具.reg")
    importReg (runPath + "Bin\\RegistryFiles\\控制面板删除任务栏和导航.reg")
    importReg (runPath + "Bin\\RegistryFiles\\控制面板删除设备和打印机.reg")
    importReg (runPath + "Bin\\RegistryFiles\\控制面板删除无效图标.reg")
    importReg (runPath + "Bin\\RegistryFiles\\控制面板删除字体.reg")
    importReg (runPath + "Bin\\RegistryFiles\\删除右键3D Edit.reg")
    importReg (runPath + "Bin\\RegistryFiles\\删除右键包含到库.reg")
    importReg (runPath + "Bin\\RegistryFiles\\删除右键个性化和显示设置.reg")
    importReg (runPath + "Bin\\RegistryFiles\\删除右键恢复到之前版本.reg")
    importReg (runPath + "Bin\\RegistryFiles\\删除右键设为壁纸.reg")
    importReg (runPath + "Bin\\RegistryFiles\\删除资源管理器内桌面等文件夹.reg")
    importReg (runPath + "Bin\\RegistryFiles\\视觉效果.reg")
    importReg (runPath + "Bin\\RegistryFiles\\修复此电脑右键管理.reg")
    importReg (runPath + "Bin\\RegistryFiles\\隐藏3D对象等文件夹.reg")
    importReg (runPath + "Bin\\RegistryFiles\\隐藏导航窗格.reg")
    importReg (runPath + "Bin\\RegistryFiles\\隐藏开始菜单启动和管理工具.reg")
    importReg (runPath + "Bin\\RegistryFiles\\隐藏映射网络驱动器.reg")
    importReg (runPath + "Bin\\RegistryFiles\\隐藏3D对象等文件夹.reg")
    importReg (runPath + "Bin\\RegistryFiles\\电源键默认重启.reg")
    importReg (runPath + "Bin\\RegistryFiles\\计算机属性.reg")
    importReg (runPath + "Bin\\RegistryFiles\\绕过TPM检测.reg")
    importReg (runPath + "Bin\\RegistryFiles\\右键用记事本打开文件.reg")
    importReg (runPath + "Bin\\RegistryFiles\\右键显示设置.reg")
    importReg (runPath + "Bin\\RegistryFiles\\HashTab.reg")
    importReg (runPath + "Bin\\RegistryFiles\\WinX开机动画.reg")


    print("\n正在替换注册表的C:\\为X:\\")
    os.system(runPath + "Bin\\Tools\\regfind.exe"+" -p HKEY_LOCAL_MACHINE\\pe_soft -y C:\\ -y -r X:\\")

    print("\n正在处理Interactive User")
    os.system(runPath + "Bin\\Tools\\regfind.exe"+" -p HKEY_LOCAL_MACHINE\\pe_soft\Classes\AppID -y Interactive User -r")

    print("\n复制必要的SYSTEM注册表到PE")
    for line in open(runPath+"\\Bin\\RegistryFiles\\pe_sys.txt", "r"):  #打开文件
        rs = line.rstrip('\n')  # 移除行尾换行符
        copyRegKey("hklm\\os_sys\\"+rs,"hklm\\pe_sys\\"+rs)

    importReg (runPath + "Bin\\RegistryFiles\\pe_sys.reg")

    print("\n复制必要的drivers注册表到PE")
    for line in open(runPath+"\\Bin\\RegistryFiles\\pe_drv.txt", "r"):  #打开文件
        rs = line.rstrip('\n')  # 移除行尾换行符
        copyRegKey("hklm\\os_drv\\"+rs,"hklm\\pe_drv\\"+rs)

    os.system(runPath + "copyDriver.bat")

    importReg (runPath + "Bin\\RegistryFiles\\pe_drv.reg")  


    print("\n正在卸载配置单元")
    
    unloadConfigUnit ("hklm\os_drv")
    unloadConfigUnit ("hklm\os_sys")
    unloadConfigUnit ("hklm\pe_def")
    unloadConfigUnit ("hklm\pe_soft")
    unloadConfigUnit ("hklm\pe_sys")
    unloadConfigUnit ("hklm\pe_drv")

    os.system("del /f /q /ah \"" + runPath + "TempFile\\apply\\Windows\\System32\\config\\*.*\"")

    print("\n正在修改图标")
    if os.path.exists(runPath+"TempFile\\apply\\Windows\\System32\\imageres.dll"):
        os.system("copy \""+runPath+"TempFile\\apply\\Windows\System32\\imageres.dll\" \""+runPath+"Bin\\imageres_dll\\imageres.dll\"")
        os.system(runPath + "Bin\\imageres_dll\\cmd.bat")
        os.system("del "+runPath+"TempFile\\apply\\windows\\system32\\imageres.dll /F /S /Q")
        os.system("del "+runPath+"TempFile\\apply\\windows\\SysWOW64\\imageres.dll /F /S /Q")
        os.system("copy \""+runPath+"Bin\\imageres_dll\\new_imageres.dll\" \""+runPath+"TempFile\\apply\\windows\\system32\\imageres.dll\"")
        os.system("copy \""+runPath+"Bin\\imageres_dll\\new_imageres.dll\" \""+runPath+"TempFile\\apply\\windows\\SysWOW64\\imageres.dll\"")
        #os.system("del "+runPath+"TempFile\\imageres32.dll /F /S /Q")
        #os.system("del "+runPath+"TempFile\\temp_imageres32.dll /F /S /Q")
        #os.system("del "+runPath+"TempFile\\new_imageres32.dll /F /S /Q")

    print("\n正在破解USB弹出功能文件")
    os.system(runPath +"Bin\\Tools\\binmay.exe -u \"" + runPath + "TempFile\\apply\\Windows\\System32\\DeviceSetupManager.dll\" -s u:SystemSetupInProgress -r u:DisableDeviceSetupMgr")

    print("\n正在删除dll备份文件")
    os.system("del \"" + runPath + "TempFile\\apply\\Windows\\System32\\DeviceSetupManager.dll.org\"")

    print("\n正在打包成Kernel.wim")
    os.system(wimlibImagex+" capture \"" + runPath + "TempFile\\apply\" \""+runPath+"\\Kernel.wim\" \"HotPE\" --boot --compress=lzx --rebuild")

    print("\n正在打包成ISO")
    os.system("del "+runPath+"TempFile\\ISO\\HotPE\\Kernel.wim /F /S /Q")
    os.system("copy \""+runPath+"Kernel.wim\" \""+runPath+"TempFile\\ISO\\HotPE\\Kernel.wim\"")
    os.system(runPath +"Bin\\Tools\\oscdimg.exe  -m -o -u2 -udfver102 -h -bootdata:2#p0,e,b"+runPath+"Bin\\Tools\\Etfsboot.com#pEF,e,b"+runPath+"Bin\\Tools\\Efisys.bin -l\"HotPE工具箱\" "+runPath+"TempFile\\ISO\\ "+runPath+"HotPE工具箱.iso")

    input("\n构建结束，回车启动虚拟机测试")
    os.system(runPath + "启动虚拟机测试.bat")
    
    return



#入口
if __name__=='__main__':
    #获取管理员权限
    def is_admin():
        try:
            return ctypes.windll.shell32.IsUserAnAdmin()
        except:
            return False

    if is_admin():
        begin ()
    else:
        os.system("python.exe " + runPath + "HotPEBuildTools.py")
        #if sys.version_info[0] == 3:
    	#    ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1)
        
