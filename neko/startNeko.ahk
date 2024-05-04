#Requires AutoHotkey v2.0

#Include nekoMove.ahk
#Include debugWindow.ahk

debug := false

if (debug) {
    ShowDebugWindow("testText")
}


moveNeko := true
NekoStartGui := Gui("+Resize")
NekoStartGui.Add("Button", "vToggle", "Toggle").OnEvent("Click", ToggleNekoMove)
startGuiText := NekoStartGui.Add("Text", "ym w100 h100", "direction")
NekoStartGui.Title := "Neko"
icon := LoadPicture(A_ScriptDir . "\neko\Resources\Awake.ico", "Icon1 w" 32 " h" 32, &imgtype)
SendMessage(0x0080, 1, icon, NekoStartGui)
NekoStartGui.Show("w200 h40")


ToggleNekoMove(*) {
    global moveNeko
    moveNeko := !moveNeko
}

CoordMode("Mouse", "Screen") ; Set the coordinate mode to screen instead of active window

NekoGui := Gui()
NekoGui.Opt("+AlwaysOnTop -Caption +ToolWindow")
NekoGui.BackColor := "EEAA99"
WinSetTransColor(NekoGui.BackColor, NekoGui)
; WinSetTransColor(NekoGui.BackColor " 200", NekoGui) ; 200 is the transparency level


CurrentPic := NekoGui.Add("Pic")
global ImageTest := A_ScriptDir . "\neko\Resources\Awake.ico"

CurrentPic.Value := ImageTest
global currentImage := ImageTest

SetTimer(UpdateNeko, 600)
NekoGui.Show("xCenter yCenter AutoSize NoActivate")


speedFactor := 20  ; Increase or decrease this value to adjust the speed
stopThreshold := 50  ; Stop moving the GUI when it's this close to the mouse

UpdateNeko(*) {
    CurrentPic.Opt("-Redraw")
    global NekoGui
    global moveNeko
    global CurrentPic

    if (moveNeko) {
        ; Get the current position of the mouse cursor
        MouseGetPos(&MouseX, &MouseY)

        ; Get the current position of the GUI
        NekoGui.GetClientPos &NekoGuiX, &NekoGuiY

        ; Calculate the direction vector from the GUI to the mouse cursor
        directionX := MouseX - NekoGuiX
        directionY := MouseY - NekoGuiY

        ; Calculate the distance between the GUI and the mouse cursor
        distance := Sqrt(directionX ** 2 + directionY ** 2)


        ; Normalize the direction vector to a length of 1
        directionX := directionX / distance
        directionY := directionY / distance

        ; Determine the direction of movement
        if (directionX > 0) {
            if (directionY > 0) {
                direction := "downRight"
            } else if (directionY < 0) {
                direction := "upRight"
            } else {
                direction := "right"
            }
        } else if (directionX < 0) {
            if (directionY > 0) {
                direction := "downLeft"
            } else if (directionY < 0) {
                direction := "upLeft"
            } else {
                direction := "left"
            }
        } else {
            if (directionY > 0) {
                direction := "down"
            } else if (directionY < 0) {
                direction := "up"
            } else {
                direction := "stationary"
            }
        }

        ; startGuiText.Value := direction
        UpdateDebugVar1(direction)
        UpdateDebugVar2(distance)
        testVar := directionX . " x" . directionY . " y"
        UpdateDebugVar3(testVar)


        ; If the GUI is close to the mouse, stop moving it
        if (distance < stopThreshold) {
            ; MouseGetPos(&mouseXTest, &mouseYTest)


            NekoSleep()


        } else {
            NekoMove(direction)

            ; Move the GUI in the direction of the mouse cursor
            NekoGui.Move(NekoGuiX + directionX * speedFactor, NekoGuiY + directionY * speedFactor)
        }
    } else {
        NekoSleep()
    }
    CurrentPic.Opt("+Redraw")

}