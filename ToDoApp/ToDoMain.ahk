#Requires AutoHotkey v2.0

saveFileLocation := A_ScriptDir "\ToDoApp\todoSave.txt"
isFileExisting := FileExist(saveFileLocation)

if !isFileExisting
{
    FileAppend("", saveFileLocation)
}

isAddItemGuiOpen := false
isToDoItemsGuiOpen := true
ToDoItemsGuiSettings := CreateToDoItemsSettings(0, 0)

CreateToDoItemsSettings(guiX, guiY) {
    settings := ""
    if (guiX != 0 && guiY != 0) {
        settings := "x" guiX " y" guiY " w200 h200 AutoSize NoActivate"
    } else {
        settings := "x130 y980 w200 h200 AutoSize NoActivate"
    }
    return settings
}

; Create gui add item gui
ToDoGui := Gui("+AlwaysOnTop +ToolWindow -Caption +Border")
ToDoGui.Title := "To Do App"
inputTaskBox := ToDoGui.Add("Edit", "w100", "")
SendMessage(0x1501, True, StrPtr("Enter your task here..."), inputTaskBox.Hwnd)

; Create toDoItemsGui

ToDoItemsGui := Gui("+AlwaysOnTop +Border +Resize -MaximizeBox -Caption")
ToDoItemsGui.Title := "To Do Items"
ToDoItemsGui.SetFont("s12", "Arial")

ToDoItemsGui.Add("Text", "w100", "To Do Items: ")

InitGuiToDoItemsGui() {
    global saveFileLocation
    fileContents := FileRead(saveFileLocation)
    items := StrSplit(fileContents, "`n")
    for index, item in items {
        if (item != "") {
            ToDoItemsGui.Add("Text", "xs w100", item)
        }
    }

}

ToggleAddItemGui() {
    global isAddItemGuiOpen := !isAddItemGuiOpen
    isAddItemGuiOpen ? ToDoGui.Show() : ToDoGui.Hide()
}

if (isToDoItemsGuiOpen) {
    ToDoItemsGui.Show(CreateToDoItemsSettings(0, 0))
}

ToggleToDoItemsGui() {
    global isToDoItemsGuiOpen := !isToDoItemsGuiOpen
    isToDoItemsGuiOpen ? ToDoItemsGui.Show(ToDoItemsGuiSettings) : ToDoItemsGui.Hide()
}

SaveItemToFile(item) {
    FileAppend(item "`n", saveFileLocation)
}

AddToDoItem(item) {
    ToDoItemsGui.GetClientPos(&guiX, &guiY)
    ToDoItemsGui.Hide()
    ToDoItemsGui.Add("Text", "xs w100", item)
    ToDoItemsGui.Show(CreateToDoItemsSettings(guiX, guiY))
    SaveItemToFile(item)
}

; ---- On Enter press found here
; https://www.autohotkey.com/boards/viewtopic.php?t=127088
OnMessage(0x0100, WM_KEYDOWN) ; https://learn.microsoft.com/en-us/windows/win32/inputdev/wm-keydown

WM_KEYDOWN(W, L, M, H) {
    global inputTaskBox

    Static AutoRepeat := 0x40000000,    ; (1 << 30)
        VK_RETURN := 13              ; (0x0D)
    if (W = VK_RETURN) && !(L & AutoRepeat) && (H = inputTaskBox.Hwnd) {
        AddToDoItem(inputTaskBox.value)
        inputTaskBox.value := ""
        ToggleAddItemGui()
    }
}

; ------

; ---- Draggable window
; https://www.reddit.com/r/AutoHotkey/comments/xa5zpb/how_to_drag_a_gui_with_gui_caption_enabled/
; https://www.autohotkey.com/boards/viewtopic.php?t=79315

OnMessage(0x201, WM_LBUTTONDOWN)		;; window message for the mouse left click

WM_LBUTTONDOWN(W, L, M, H) {
    Static AutoRepeat := 0x40000000
    if AutoRepeat && (H = ToDoItemsGui.Hwnd) {
        PostMessage(0xA1, 2, , , "To Do Items")
    }
}


; ------
