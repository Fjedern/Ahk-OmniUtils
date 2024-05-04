#Requires AutoHotkey v2.0
SetWorkingDir A_InitialWorkingDir

#Include ..\scripting\scriptFunctions.ahk
#Include ..\misc\interactWithAhk.ahk
#Include ..\misc\excelToCsvInDownloads.ahk
#Include ..\ToDoApp\ToDoMain.ahk


Numpad1:: {
    ApplicationLe()
}

Numpad2:: {
    SelectFromWithLegalId()
}

Numpad5:: {
    ScriptTemplate()
}

Numpad6:: {
    ToggleToDoItemsGui()
}

Numpad7:: {
    ToggleAddItemGui()
}

Numpad8:: {
    ExcelToCsv()
}

Numpad9:: {
    ReloadAllAhkScripts()
}