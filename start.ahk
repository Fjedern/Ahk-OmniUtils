#Requires AutoHotkey v2.0

#SingleInstance Force
#Include testStuff.ahk
; #Include hotkeyMappings\numpadMapping.ahk
; #Include neko\startNeko.ahk

startNeko := IniRead("settings.ini", "startOptions", "neko")
if (startNeko = 1) {
    Run("neko\startNeko.ahk")
}

startScriptUtils := IniRead("settings.ini", "startOptions", "scriptUtils")
if (startScriptUtils = 1) {
    Run("scripting\StartScriptUtils.ahk")
}

startTodo := IniRead("settings.ini", "startOptions", "todo")
if (startTodo = 1) {
    Run("ToDoApp\ToDoMain.ahk")
}

startpTimer := IniRead("settings.ini", "startOptions", "pTimer")
if (startpTimer = 1) {
    Run("pTimer\pTimerMain.ahk")
}

; TestFunction1()
; TestFunction2()
; TestFunction3()
