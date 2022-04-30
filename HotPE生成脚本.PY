from __future__ import print_function
import ctypes, sys
import os

def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False
if is_admin():
    import sys
    import os
    def 卸载配置单元 (KeyName):
        os.system ("reg unload "+KeyName)
        return

    卸载配置单元 ("hklm\os_drv")
    卸载配置单元 ("hklm\os_sys")
    卸载配置单元 ("hklm\pe_def")
    卸载配置单元 ("hklm\pe_soft")
    卸载配置单元 ("hklm\pe_sys")
    卸载配置单元 ("hklm\pe_drv")

    运行目录 = os.path.split( os.path.realpath( sys.argv[0] ) )[0] + "\\"
    os.system(运行目录 + "Bin\\Tools\\NSudo.exe  -U:T -P:E python.exe " +  运行目录 + "main.PY")
    
else:
    if sys.version_info[0] == 3:
    	ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1)

