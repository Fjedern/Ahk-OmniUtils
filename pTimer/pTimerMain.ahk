#Requires AutoHotkey v2.0

tomatoCount := 0
running := 0
Minutes := 20
Timer := A_TickCount + Minutes * 60 * 1000
Remaining := 0


PTimerGui := Gui("+AlwaysOnTop +Border +Resize +MaximizeBox -Caption")
PTimerGui.Title := "Pomodoro Timer"
; PTimerGui.SetFont("s32")

countDownStatusText := PTimerGui.Add("Text", "", "Pomodoro")
countDownText := PTimerGui.Add("Text", "", "XX:YY")
; countDownToggleButton := PTimerGui.Add("Button", "x10 y40 w100 h20", "Start")
countDownToggleButton := PTimerGui.Add("Button", "w100 h20", "Start")
tomatoText := PTimerGui.Add("Text", "", "")

countDownToggleButton.OnEvent("Click", ToggleTimer)

PTimerGui.Show()


ToggleTimer(*) {
    ; MsgBox("🍅")
    ToggleStart()
}


; ---- Draggable window
; https://www.reddit.com/r/AutoHotkey/comments/xa5zpb/how_to_drag_a_gui_with_gui_caption_enabled/
; https://www.autohotkey.com/boards/viewtopic.php?t=79315

OnMessage(0x201, WM_LBUTTONDOWN)		;; window message for the mouse left click

WM_LBUTTONDOWN(W, L, M, H) {
    Static AutoRepeat := 0x40000000
    if AutoRepeat && (H = PTimerGui.Hwnd) {
        PostMessage(0xA1, 2, , , "Pomodoro Timer")
    }
}

; ------

ToggleStart(*) {
    global running
    if (running == 0) {
        running := 1
        countDownStatusText.Text := "Running..."
        SetTimer(Update, 1000)
    } else {
        running := 0
        countDownStatusText.Text := "Paused"
        SetTimer(Update, 0)
    }
}

; Update timer
Update(*) {
    global Timer, countDownText, Remaining, Minutes, Seconds
    Remaining := Timer - A_TickCount
    if (Remaining < 0) {
        SetTimer(Update, 0)
        Remaining := 0
        CreateTomato()
    }
    Minutes := Remaining // (60 * 1000)
    Seconds := Mod((Remaining // 1000), 60)
    countDownText.Text := Format("{:02}:{:02}", Minutes, Seconds)
}

CreateTomato() {
    global tomatoCount, tomatoText
    tomatoCount := tomatoCount + 1
    ; add one tomato to tomato text
    tomatoText.Text := tomatoText.Text . "🍅"
}