#Requires AutoHotkey v2.0

ReloadAllAhkScripts() {
    DetectHiddenWindows(true)
    SetTitleMatchMode(2)

    allAhkExe := WinGetList("ahk_class AutoHotkey")
    for index, hwnd in allAhkExe {
        if (hwnd = A_ScriptHwnd)  ; ignore the current window for reloading
        {
            continue
        }

        PostMessage(0x111, 65303, "", "", "ahk_id " . hwnd)
    }
    Reload()
}