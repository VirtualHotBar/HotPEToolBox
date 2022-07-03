import sys
import os
运行目录 = os.path.split( os.path.realpath( sys.argv[0] ) )[0] + "\\"
print("正在从删除无用文件")
for line in open(运行目录+"delFiles.txt", "r"):  #打开文件
    rs = line.rstrip('\n')  # 移除行尾换行符
    if os.path.isfile(运行目录+"TempFile\\apply\\"+rs):
        os.system("del \""+运行目录+"TempFile\\apply\\"+rs+"\" /F /Q")
    if os.path.isdir(运行目录+"TempFile\\apply\\"+rs):
        os.system("rd \""+运行目录+"TempFile\\apply\\"+rs+"\" /S /Q")
