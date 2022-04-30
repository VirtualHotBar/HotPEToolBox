@echo off
cd /d "%~dp0"
%~dp0ResourceHacker.exe -open  "%~dp0imageres.dll" -save "%~dp0temp_imageres.dll" -action  delete  -mask ICONGROUP
%~dp0ResourceHacker.exe -open  "%~dp0temp_imageres.dll" -save "%~dp0new_imageres.dll" -action  addoverwrite  -res "%~dp0imageres.dll.res"
del %~dp0temp_imageres.dll
