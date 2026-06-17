Option Explicit

Dim shell, fso, appDir, command
Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

appDir = fso.GetParentFolderName(WScript.ScriptFullName)
command = "cmd /c cd /d """ & appDir & """ && python -m http.server 4173 --bind 127.0.0.1"

shell.Run command, 0, False
WScript.Sleep 900
shell.Run "http://127.0.0.1:4173/", 1, False
