#Requires AutoHotkey v2.0

ImageTest := "Resources\Awake.ico"
NekoSleep1Image := "Resources\sleep1.ico"
NekoSleep2Image := "Resources\sleep2.ico"
NekoRight1Image := "Resources\Right1.ico"
NekoRight2Image := "Resources\right2.ico"
NekoLeft1Image := "Resources\left1.ico"
NekoLeft2Image := "Resources\left2.ico"
NekoDownLeft1Image := "Resources\downleft1.ico"
NekoDownLeft2Image := "Resources\Downleft2.ico"
NekoDownRight1Image := "Resources\Downright1.ico"
NekoDownRight2Image := "Resources\downright2.ico"
NekoUpLeft1Image := "Resources\Upleft1.ico"
NekoUpLeft2Image := "Resources\Upleft2.ico"
NekoUpRight1Image := "Resources\Upright1.ico"
NekoUpRight2Image := "Resources\Upright2.ico"


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