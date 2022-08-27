from __future__ import print_function
import ctypes, sys
from runpy import run_path
import os

runPath = os.path.split( os.path.realpath( sys.argv[0] ) )[0] + "\\"

#用NSudo提权运行命令
def nsudoRun (cmd):
    os.system(runPath + "Bin\\Tools\\NSudo.exe  -U:T -P:E -UseCurrentConsole -Wait cmd /c \""+cmd+"\"")
    #time.sleep(1)
    return

#获取管理员权限
def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

if is_admin():
    nsudoRun ("python.exe " + runPath + "main.py")
    

else:
    if sys.version_info[0] == 3:
    	ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1)


