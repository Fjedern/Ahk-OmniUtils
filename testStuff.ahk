#Requires AutoHotkey v2.0

CoordMode("Mouse", "Screen") ; Set the coordinate mode to screen instead of active window


TestFunction1() {
    TestVar := "Hello, World!"

    MyGui := Gui()
    WinSetTransColor("FFFFFF", MyGui)
    MyGui.Add("Text", , TestVar)
    MyGui.Show()
}

; TestFunction2() {
;     TestGui := Gui(Options := "AlwaysOnTop Caption")
;     WinSetTransColor("FFFFFF", TestGui)
;     OnMessage(0x201, WM_LBUTTONDOWN())
;     TestGui.Add("Text", , "Hey")
;     TestGui.Show()
; }

; WM_LBUTTONDOWN() {
;     PostMessage(0xA1, 2, , , "A")
; }

; Gui, +AlwaysOnTop -Caption
; Gui, Add, Text,, Hey
; Gui, Show
; OnMessage(0x201, "WM_LBUTTONDOWN")

; WM_LBUTTONDOWN()
; {
; 		PostMessage, 0xA1, 2,,,A
; }

TestFunction2() {
    MyGui := Gui()
    MyGui.Opt("+AlwaysOnTop -Caption +ToolWindow")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
    MyGui.BackColor := "EEAA99"  ; Can be any RGB color (it will be made transparent below).
    MyGui.SetFont("s32")  ; Set a large font size (32-point).
    CoordText := MyGui.Add("Text", "cLime", "XXXXX YYYYY")  ; XX & YY serve to auto-size the window.
    ; Make all pixels of this color transparent and make the text itself translucent (150):
    WinSetTransColor(MyGui.BackColor " 150", MyGui)
    SetTimer(UpdateOSD, 200)
    UpdateOSD()  ; Make the first update immediate rather than waiting for the timer.
    MyGui.Show("x2060 y1200 NoActivate")  ; NoActivate avoids deactivating the currently active window.

    UpdateOSD(*)
    {
        MouseGetPos &MouseX, &MouseY
        CoordText.Value := "X" MouseX ", Y" MouseY
    }
}

TestFunction3() {
    MyGui := Gui("+Resize")
    MyBtn := MyGui.Add("Button", "default", "&Load New Image")
    MyBtn.OnEvent("Click", LoadNewImage)
    MyRadio := MyGui.Add("Radio", "ym+5 x+10 checked", "Load &actual size")
    MyGui.Add("Radio", "ym+5 x+10", "Load to &fit screen")
    MyPic := MyGui.Add("Pic", "xm")
    MyGui.Show()

    LoadNewImage(*)
    {
        Image := FileSelect(, , "Select an image:", "Images (*.gif; *.jpg; *.bmp; *.png; *.tif; *.ico; *.cur; *.ani; *.exe; *.dll)")
        if Image = ""
            return
        if (MyRadio.Value)  ; Display image at its actual size.
        {
            Width := 0
            Height := 0
        }
        else ; Second radio is selected: Resize the image to fit the screen.
        {
            Width := A_ScreenWidth - 28  ; Minus 28 to allow room for borders and margins inside.
            Height := -1  ; "Keep aspect ratio" seems best.
        }
        MyPic.Value := Format("*w{1} *h{2} {3}", Width, Height, Image)  ; Load the image.
        MyGui.Title := Image
        MyGui.Show("xCenter y0 AutoSize")  ; Resize the window to match the picture size.
    }
}