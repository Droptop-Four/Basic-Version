@echo Setting DPI. Please wait...
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %2Rainmeter.exe" /t "REG_SZ" /d %1 /f
taskkill /f /im "Rainmeter.exe"
start "" %2Rainmeter.exe"
timeout /T 3 /NOBREAK
taskkill /f /im "Rainmeter.exe"
start "" %2Rainmeter.exe"
exit