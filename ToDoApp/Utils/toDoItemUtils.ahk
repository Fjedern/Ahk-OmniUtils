#Requires AutoHotkey v2.0

CreateToDoItemsSettings(guiX, guiY) {
    settings := ""
    if (guiX != 0 && guiY != 0) {
        settings := "x" guiX " y" guiY " w200 h200 AutoSize NoActivate"
    } else {
        settings := "x130 y980 w200 h200 AutoSize NoActivate"
    }
    return settings
}

InitGuiToDoItemsGui() {
    global saveFileLocation
    global ToDoItemsGui
    fileContents := FileRead(saveFileLocation)
    items := StrSplit(fileContents, "`n")
    for index, item in items {
        if (item != "") {
            ToDoItemsGui.Add("Text", "xs w100", item)
        }
    }
}

ToggleToDoItemsGui() {
    global isToDoItemsGuiOpen := !isToDoItemsGuiOpen
    isToDoItemsGuiOpen ? ToDoItemsGui.Show(ToDoItemsGuiSettings) : ToDoItemsGui.Hide()
}

AddToDoItem(item) {
    global ToDoItemsGui
    ToDoItemsGui.GetClientPos(&guiX, &guiY)
    ToDoItemsGui.Hide()
    ToDoItemsGui.Add("Text", "xs w100", item)
    ToDoItemsGui.Show(CreateToDoItemsSettings(guiX, guiY))
    SaveItemToFile(item)
}