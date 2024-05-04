#Requires AutoHotkey v2.0

ImageTest := A_ScriptDir . "\neko\Resources\Awake.ico"
NekoSleep1Image := A_ScriptDir . "\neko\Resources\sleep1.ico"
NekoSleep2Image := A_ScriptDir . "\neko\Resources\sleep2.ico"
NekoRight1Image := A_ScriptDir . "\neko\Resources\Right1.ico"
NekoRight2Image := A_ScriptDir . "\neko\Resources\right2.ico"
NekoLeft1Image := A_ScriptDir . "\neko\Resources\left1.ico"
NekoLeft2Image := A_ScriptDir . "\neko\Resources\left2.ico"
NekoDownLeft1Image := A_ScriptDir . "\neko\Resources\downleft1.ico"
NekoDownLeft2Image := A_ScriptDir . "\neko\Resources\Downleft2.ico"
NekoDownRight1Image := A_ScriptDir . "\neko\Resources\Downright1.ico"
NekoDownRight2Image := A_ScriptDir . "\neko\Resources\downright2.ico"
NekoUpLeft1Image := A_ScriptDir . "\neko\Resources\Upleft1.ico"
NekoUpLeft2Image := A_ScriptDir . "\neko\Resources\Upleft2.ico"
NekoUpRight1Image := A_ScriptDir . "\neko\Resources\Upright1.ico"
NekoUpRight2Image := A_ScriptDir . "\neko\Resources\Upright2.ico"


firstRun := true

CoordMode("Mouse", "Screen") ; Set the coordinate mode to screen instead of active window


NekoSleep() {
    global currentImage
    global CurrentPic
    global ImageTest
    global firstRun

    if (firstRun) {
        currentImage := NekoSleep1Image
        firstRun := false
    }

    if (currentImage = NekoSleep2Image) {
        currentImage := NekoSleep1Image
    }
    else {
        currentImage := NekoSleep2Image
    }

    CurrentPic.Value := currentImage
}

NekoMove(direction) {
    global currentImage
    global CurrentPic

    if (Direction = "Right") {
        currentImage := (currentImage = NekoRight2Image) ? NekoRight1Image : NekoRight2Image
    }
    else if (Direction = "Left") {
        currentImage := (currentImage = NekoLeft2Image) ? NekoLeft1Image : NekoLeft2Image
    }
    else if (Direction = "downLeft") {
        currentImage := (currentImage = NekoDownLeft2Image) ? NekoDownLeft1Image : NekoDownLeft2Image
    }
    else if (Direction = "downRight") {
        currentImage := (currentImage = NekoDownRight2Image) ? NekoDownRight1Image : NekoDownRight2Image
    }
    else if (Direction = "upRight") {
        currentImage := (currentImage = NekoUpRight2Image) ? NekoUpRight1Image : NekoUpRight2Image
    }
    else if (Direction = "upLeft") {
        currentImage := (currentImage = NekoUpLeft2Image) ? NekoUpLeft1Image : NekoUpLeft2Image
    } else {
        currentImage := (currentImage = NekoSleep2Image) ? NekoSleep1Image : NekoSleep2Image
    }

    CurrentPic.Value := currentImage
}