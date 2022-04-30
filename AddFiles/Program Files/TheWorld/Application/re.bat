if "%1"=="dd" goto unlock
ECHO {"auto_update":{"enabled":false}}>"%programfiles%\网络工具\TheWorld\User Data\Local State"
del theworld.exe /q
rename theworld1.exe theworld.exe
start theworld.exe cn.bing.com
exit
:unlock
icacls "%programfiles%\网络工具\TheWorld\User Data\Default\Cache" /grant system:F
icacls "%programfiles%\网络工具\TheWorld\User Data\Default\Media Cache" /grant system:F
del "%programfiles%\网络工具\TheWorld\User Data\Default\Cache\*" /s /q /f >nul 2>nul
del "%programfiles%\网络工具\TheWorld\User Data\Default\Media Cache\*" /s /q /f >nul 2>nul