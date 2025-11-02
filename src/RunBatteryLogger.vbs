' ---------------------------------------------------------
' RunBatteryLogger.vbs
' Launches batteryLogger.ps1 silently using PowerShell
' Author: Ivan Gonzalez (https://github.com/ivanMSC/)
' Version: 1.0
' License: MIT
' ---------------------------------------------------------

Option Explicit

Dim shell, scriptPath
Set shell = CreateObject("Wscript.Shell")

' Build path to the PowerShell script (relative to this file)
scriptPath = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName) & "\batteryLogger.ps1"

' Run PowerShell invisibly
shell.Run "powershell -NoProfile -ExecutionPolicy Bypass -File """ & scriptPath & """", 0, False
