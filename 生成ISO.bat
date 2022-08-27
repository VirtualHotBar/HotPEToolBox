@echo off
cd /d "%~dp0"
del %~dp0TempFile\ISO\HotPE\Kernel.wim /F /S /Q
copy %~dp0Kernel.wim %~dp0TempFile\ISO\HotPE\Kernel.wim
%~dp0Bin\Tools\oscdimg.exe  -m -o -u2 -udfver102 -h -bootdata:2#p0,e,b%~dp0Bin\Tools\Etfsboot.com#pEF,e,b%~dp0Bin\Tools\Efisys.bin %~dp0TempFile\ISO\ %~dp0HotPE工具箱.iso