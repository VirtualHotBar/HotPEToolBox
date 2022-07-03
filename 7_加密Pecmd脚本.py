import sys
import os
def 加密PECMD脚本 (path):
    os.system(运行目录+"Bin\Tools\pecmd.exe \"CMPS -bin "+path+","+path+".new\"")
    os.remove(path)
    os.rename(path+".new",path)
    return
运行目录 = os.path.split( os.path.realpath( sys.argv[0] ) )[0] + "\\"
print("正在加密Pecmd脚本文件")
加密PECMD脚本(运行目录+"TempFile\\apply\\windows\\system32\\PECMD.ini")
加密PECMD脚本(运行目录+"TempFile\\apply\\Program Files\\PETools.ini")
#加密PECMD脚本(运行目录+"TempFile\\apply\\Program Files\\RegistryFiles\\Edgeless\\注册Edgeless.ini")
