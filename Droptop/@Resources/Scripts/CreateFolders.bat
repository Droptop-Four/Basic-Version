rmdir /s /q %1Droptop Folders\Bookmarks"
rmdir /s /q %1Droptop Folders\Control"
rmdir /s /q %1Droptop Folders\ControlWin7"
rmdir /s /q %1Droptop Folders\CustomFolder1"
rmdir /s /q %1Droptop Folders\CustomFolder2"
rmdir /s /q %1Droptop Folders\CustomFolder3"
rmdir /s /q %1Droptop Folders\CustomFolder4"
rmdir /s /q %1Droptop Folders\CustomFolder5"
rmdir /s /q %1Droptop Folders\CustomFolder6"
rmdir /s /q %1Droptop Folders\CustomFolder7"
rmdir /s /q %1Droptop Folders\Games"
rmdir /s /q %1Droptop Folders\Other files"
rmdir /s /q %1Droptop Folders\PinnedApps"
rmdir /s /q %1Droptop Folders"

mkdir %1Droptop Folders"

xcopy /s /e /y /i %1Droptop\Folders\Backups" %1Droptop Folders"

xcopy /s /y /i /f "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" %1Droptop Folders\PinnedApps"

"Wscript.exe" %1Droptop\@Resources\Scripts\IconsColor1.vbs" %1"