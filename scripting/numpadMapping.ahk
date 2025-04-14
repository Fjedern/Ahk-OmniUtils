#Requires AutoHotkey v2.0

#Include scriptFunctions.ahk
#Include ..\misc\interactWithAhk.ahk
#Include ..\misc\excelToCsvInDownloads.ahk
#Include ..\ContextMenu\menu1.ahk

<!Q:: {
    MainMenu.Show()
}


Numpad1:: {
    ApplicationLe()
}

Numpad2:: {
    SelectFromWithLegalId()
}

Numpad3:: {
    MakeUserLoginable()
}

Numpad5:: {
    ScriptTemplate()
}

; Numpad6:: {
;     ToggleToDoItemsGui()
; }

; Numpad7:: {
;     ToggleAddItemGui()
; }

Numpad8:: {
    ExcelToCsv()
}

Numpad9:: {
    ReloadAllAhkScripts()
}