#Requires AutoHotkey v2.0

global MainMenu := Menu()
global ScriptingMenu := Menu()
global ToDoMenu := Menu()
global UtilsMenu := Menu()
global DevMenu := Menu()
global SqlMenu := Menu()

; Build the shortcuts menu dynamically
BuildShortcutsMenu()

; Function to build the shortcuts menu by scanning available hotkeys
BuildShortcutsMenu() {
    ; Clear existing menus
    MainMenu.Delete()
    ScriptingMenu.Delete()
    ToDoMenu.Delete()
    UtilsMenu.Delete()
    DevMenu.Delete()
    SqlMenu.Delete()
    
    ; Get shortcuts by scanning files
    shortcuts := ScanForHotkeys()
    
    ; Build submenus
    BuildScriptingMenu(shortcuts)
    BuildToDoMenu(shortcuts)
    BuildUtilsMenu(shortcuts)
    BuildDevMenu(shortcuts)
    BuildSqlMenu()
    
    ; Add submenus to main menu with right arrows
    MainMenu.Add("Scripting ", ScriptingMenu)
    MainMenu.Add("ToDo App ", ToDoMenu)
    MainMenu.Add("Utilities ", UtilsMenu)
    MainMenu.Add("Development ", DevMenu)
    MainMenu.Add("Test SQL ", SqlMenu)
    MainMenu.Add("───────────────", MenuHandler) ; Visual separator
    MainMenu.Add("Code", MenuHandler)
    MainMenu.Add("Refresh Menu", MenuHandler)
}

; Build the Scripting submenu
BuildScriptingMenu(shortcuts) {
    ScriptingMenu.Add("Script Functions:", MenuHandler)
    
    ; Add script-related shortcuts
    scriptItems := [
        ["Numpad 1", "Application LE"],
        ["Numpad 2", "Select From With Legal ID"], 
        ["Numpad 3", "Make User Loginable"],
        ["Numpad 5", "Script Template"]
    ]
    
    for item in scriptItems {
        if (shortcuts.Has(item[1])) {
            menuText := item[2] . " (" . item[1] . ")"
            ScriptingMenu.Add(menuText, MenuHandler)
        }
    }
}

; Build the ToDo App submenu
BuildToDoMenu(shortcuts) {
    ToDoMenu.Add("ToDo Functions:", MenuHandler)
    
    ; Add ToDo-related shortcuts
    todoItems := [
        ["Numpad 6", "Toggle Add Item GUI"],
        ["Numpad 7", "Toggle ToDo Items GUI (Alt)"]
    ]
    
    for item in todoItems {
        if (shortcuts.Has(item[1])) {
            menuText := item[2] . " (" . item[1] . ")"
            ToDoMenu.Add(menuText, MenuHandler)
        }
    }
}

; Build the Utilities submenu
BuildUtilsMenu(shortcuts) {
    UtilsMenu.Add("Utility Functions:", MenuHandler)
    
    ; Add utility shortcuts
    utilItems := [
        ["Numpad 8", "Excel to CSV"],
        ["Numpad 9", "Reload All AHK Scripts"],
        ["Left Alt + Q", "Show Main Menu"]
    ]
    
    for item in utilItems {
        if (shortcuts.Has(item[1])) {
            menuText := item[2] . " (" . item[1] . ")"
            UtilsMenu.Add(menuText, MenuHandler)
        }
    }
}

; Build the Development submenu  
BuildDevMenu(shortcuts) {
    DevMenu.Add("Development Tools:", MenuHandler)
    
    ; Add development shortcuts
    devItems := [
        ["Numpad 7", "Reload Scripts (Development)"]
    ]
    
    for item in devItems {
        if (shortcuts.Has(item[1])) {
            menuText := item[2] . " (" . item[1] . ")"
            DevMenu.Add(menuText, MenuHandler)
        }
    }
    
    ; Add development utilities
    DevMenu.Add("───────────────", MenuHandler) ; Visual separator using dashes
    DevMenu.Add("Open VS Code", MenuHandler)
    DevMenu.Add("Reload Current Script", MenuHandler)
}

; Build the SQL submenu
BuildSqlMenu() {
    SqlMenu.Add("SQL Query Generator:", MenuHandler)
    SqlMenu.Add("Before Query", MenuHandler)
    SqlMenu.Add("Update Query", MenuHandler)
    SqlMenu.Add("After Query", MenuHandler)
}

; Function to scan AHK files for hotkeys and create readable descriptions
ScanForHotkeys() {
    shortcuts := Map()
    
    ; Define known hotkey mappings with descriptions
    hotkeyDescriptions := Map()
    hotkeyDescriptions["<!Q::"] := ["Left Alt + Q", "Show Main Menu"]
    hotkeyDescriptions["Numpad1::"] := ["Numpad 1", "Application LE"]
    hotkeyDescriptions["Numpad2::"] := ["Numpad 2", "Select From With Legal ID"]
    hotkeyDescriptions["Numpad3::"] := ["Numpad 3", "Make User Loginable"]
    hotkeyDescriptions["Numpad5::"] := ["Numpad 5", "Script Template"]
    hotkeyDescriptions["Numpad6::"] := ["Numpad 6", "Toggle Add Item GUI (ToDo)"]
    hotkeyDescriptions["Numpad7::"] := ["Numpad 7", "Reload Scripts (Development)"]
    hotkeyDescriptions["Numpad8::"] := ["Numpad 8", "Excel to CSV"]
    hotkeyDescriptions["Numpad9::"] := ["Numpad 9", "Reload All AHK Scripts"]
    
    ; Files to scan
    filesToScan := [
        A_ScriptDir . "\..\scripting\numpadMapping.ahk",
        A_ScriptDir . "\..\ToDoApp\hotkeyMapping.ahk"
    ]
    
    ; Scan each file
    for file in filesToScan {
        if (FileExist(file)) {
            try {
                content := FileRead(file)
                lines := StrSplit(content, "`n")
                
                for line in lines {
                    line := Trim(line)
                    ; Skip comments and empty lines
                    if (line == "" || SubStr(line, 1, 1) == ";")
                        continue
                        
                    ; Check if line contains a hotkey
                    if (RegExMatch(line, "^([^;]*::)", &match)) {
                        hotkey := match[1]
                        if (hotkeyDescriptions.Has(hotkey)) {
                            readable := hotkeyDescriptions[hotkey][1]
                            description := hotkeyDescriptions[hotkey][2]
                            shortcuts[readable] := description
                        }
                    }
                }
            }
        }
    }
    
    return shortcuts
}

; Function to convert AutoHotkey notation to readable format
ConvertToReadable(hotkeyNotation) {
    readable := hotkeyNotation
    
    ; Replace common modifiers
    readable := StrReplace(readable, "<!", "Left Alt + ")
    readable := StrReplace(readable, "<!", "Left Alt + ")
    readable := StrReplace(readable, "!>", " + Right Alt")
    readable := StrReplace(readable, "!", "Alt + ")
    readable := StrReplace(readable, "<^", "Left Ctrl + ")
    readable := StrReplace(readable, "^>", " + Right Ctrl")
    readable := StrReplace(readable, "^", "Ctrl + ")
    readable := StrReplace(readable, "<+", "Left Shift + ")
    readable := StrReplace(readable, "+>", " + Right Shift")
    readable := StrReplace(readable, "+", "Shift + ")
    readable := StrReplace(readable, "#", "Win + ")
    
    ; Replace common keys
    readable := StrReplace(readable, "Numpad", "Numpad ")
    
    ; Remove the :: at the end
    readable := StrReplace(readable, "::", "")
    
    return readable
}

MenuHandler(Item, *) {
    switch (Item) {
        case "Code", "Open VS Code":
            try {
                WinActivate("ahk_exe Code.exe")
            } catch {
                Run("code")
            }
        case "Refresh Menu":
            ; Clear and rebuild menu
            BuildShortcutsMenu()
        case "Reload Current Script":
            Reload()
        case "Before Query":
            SqlQueryBefore()
        case "Update Query":
            SqlQueryUpdate()
        case "After Query":
            SqlQueryAfter()
        case "Script Functions:", "ToDo Functions:", "Utility Functions:", "Development Tools:", "SQL Query Generator:", "───────────────":
            ; Do nothing for headers and separators
            return
        default:
            ; For shortcut items, show info or do nothing
            if (Item != "") {
                ; Could add functionality here to trigger the shortcut
                ; or show additional info about the shortcut
                ; Example: ToolTip("Shortcut: " . Item, 100, 100)
            }
    }
}