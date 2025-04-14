#Requires AutoHotkey v2.0

SaveItemToFile(item) {
    global saveFileLocation
    FileAppend(item "`n", saveFileLocation)
}