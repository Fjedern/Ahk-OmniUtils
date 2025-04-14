#Requires AutoHotkey v2.0

global MainMenu := Menu()

MainMenu.Add("Code", Menuhandler)

MenuHandler(Item, *) {
    switch (Item) {
        case "Code":
            WinActive "ahk_exe code.exe"
    }
}