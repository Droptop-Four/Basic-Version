#NoTrayIcon

Goto, %1%

;----------

WindowsSearch:
 SetStoreCapsLockMode, Off
 Send, #s
ExitApp

AlternateSearch:
 SetStoreCapsLockMode, Off
 Send, !{Space}
ExitApp

;----------

StartMenu:
 SetStoreCapsLockMode, Off
 Send, {LWin}
ExitApp

ShowDesktop:
 SetStoreCapsLockMode, Off
 Send, #d
ExitApp

TaskView:
 SetStoreCapsLockMode, Off
 Send, #{Tab}
ExitApp

OpenCortana:
 SetStoreCapsLockMode, Off
 Send, #c
ExitApp

OpenCortana11:
 SetStoreCapsLockMode, Off
 If ProcessExist("Cortana.exe")
	Process,Close,Cortana.exe

 If !ProcessExist("Cortana.exe")
    Run, "C:\Program Files\WindowsApps\Microsoft.549981C3F5F10_3.2110.13603.0_x64__8wekyb3d8bbwe\Cortana.exe"

 ProcessExist(Name)
 {
	Process,Exist,%Name%
	return Errorlevel
 }
ExitApp

AppSwitcher:
 SetStoreCapsLockMode, Off
 Send, ^!{Tab}
 KeyWait, LButton, D
 KeyWait, LButton, U
 Run, "%2%" !SetVariable SavedAppTitleB "%3%" "Droptop\Other\BackgroundProcesses"
 Run, "%2%" !Update "Droptop\Other\BackgroundProcesses"
ExitApp

AppToggle:
 SetStoreCapsLockMode, Off
 Send, {Alt down}{Tab}
 Sleep, 100
 Send, {Tab}{Alt up}
ExitApp

LangSwitcher:
 Send, !{Esc}
 Send, {LAlt down}{LShift}
 KeyWait, LButton, U
 Send, {LAlt up}
ExitApp

LangToggle:
 Send, {LAlt down}{LShift}{LAlt up}
 ;KeyWait, LButton, U
 ;Send, {LWin up}
ExitApp

HangulToggle:
 Send, !{Esc}
 Sendinput, {vk15}
ExitApp

;----------

NextDesktop:
 SetStoreCapsLockMode, Off
 Send, #^{Right}
ExitApp

PreviousDesktop:
 SetStoreCapsLockMode, Off
 Send, #^{Left}
ExitApp

NewDesktop:
 SetStoreCapsLockMode, Off
 Send, #^d
ExitApp

CloseDesktop:
 SetStoreCapsLockMode, Off
 Send, #^{f4}
ExitApp

;----------

PrintScreen:
 Send, {PrintScreen}
ExitApp

SnippingTool:
 SetStoreCapsLockMode, Off
 Sleep, 50
 Send, #+s
ExitApp

;----------

OpenAppCmd:
 Run, cmd.exe
 WinWaitActive, C:\WINDOWS\SYSTEM32\cmd.exe, , 2
 Send, ^v
ExitApp

CustomHotkey:
 Send, !{Esc}
 Send, %2%
ExitApp

EscapeKey:
 SetStoreCapsLockMode, Off
 Send, {Esc}
ExitApp