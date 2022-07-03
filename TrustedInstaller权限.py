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

    运行目录 = os.path.split( os.path.realpath( sys.argv[0] ) )[0] + "\\"
    os.system(运行目录 + "Bin\\Tools\\NSudo.exe  -U:T -P:E -UseCurrentConsole cmd")
    #os.system(运行目录 + "Bin\\Tools\\NSudo.exe  -U:T -P:E cmd")
    
else:
    if sys.version_info[0] == 3:
    	ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1)

