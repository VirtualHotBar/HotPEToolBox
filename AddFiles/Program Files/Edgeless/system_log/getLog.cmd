cd /d X:\Windows\System32
start notepad X:\Users\Log.txt
if exist X:\Users\Default\Desktop\Log_backup.txt del /f /q X:\Users\Default\Desktop\Log_backup.txt
if exist X:\Users\Default\Desktop\Log.txt ren X:\Users\Default\Desktop\Log.txt Log_backup.txt
copy /y X:\Users\Log.txt X:\Users\Default\Desktop\Log.txt
exit