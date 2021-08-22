Set objShell = WScript.CreateObject("WScript.Shell")
 
'All users Desktop
allUsersDesktop = objShell.SpecialFolders("AllUsersDesktop")
 
'The current users Desktop
usersDesktop = objShell.SpecialFolders("Desktop")
 
'Where to create the new shorcut
Set objShortCut = objShell.CreateShortcut(usersDesktop & "\Droptop Temporary Shortcut.lnk")
 
'What does the shortcut point to
objShortCut.TargetPath = WScript.Arguments.Item(0)
 
'Add a description
objShortCut.Description = ""
 
'Create the shortcut
objShortCut.Save

Dim objFso, strSourcePath, strDestPath
strSourcePath = usersDesktop & "\Droptop Temporary Shortcut.lnk"
strDestPath = WScript.Arguments.Item(1)
Set objFso = CreateObject("Scripting.FileSystemObject")
If objFso.FileExists(strSourcePath) then
	If objFso.FileExists(strDestPath) then
	Else
    objFso.MoveFile strSourcePath, strDestPath
	End If
End If
Set objFso = Nothing