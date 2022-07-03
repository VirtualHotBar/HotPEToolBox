import sys
import os
运行目录 = os.path.split( os.path.realpath( sys.argv[0] ) )[0] + "\\"
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