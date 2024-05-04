#Requires AutoHotkey v2.0

DebugGui := Gui("+Resize +AlwaysOnTop")
debugText1 := DebugGui.Add("Text", "w200", "Debug")
debugText2 := DebugGui.Add("Text", "xs w200", "Debug2")
debugText3 := DebugGui.Add("Text", "xs w600", "Debug3")

ShowDebugWindow(debugVar1) {
    debugText1.Text := debugVar1
    DebugGui.Show("x200 y200 w200 h200 AutoSize")
}

UpdateDebugVar1(debugVar1) {
    debugText1.Text := debugVar1
}

UpdateDebugVar2(debugVar2) {
    debugText2.Text := debugVar2
}

UpdateDebugVar3(debugVar3) {
    debugText3.Text := debugVar3
}