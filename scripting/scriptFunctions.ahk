#Requires AutoHotkey v2.0

ApplicationLE() {
    Send "SELECT * FROM ApplicationLegalEntities WHERE [Name] LIKE ''"
    Sleep 300
    Send "{Left 1}"
}

SelectFromWithLegalId() {
    Send "SELECT * FROM  WHERE LegalEntityId = '" A_Clipboard "'"
    Sleep 300
    Send "{Left 61}"
}


; ------------------------------
scriptTemplateGui := Gui()

scriptTemplateGui.Add("Text", "x10 y10 w230 h20", "Task number - Description - LegalEntity")
scriptTemplateGui.Add("Text", "x10 y30 w230 h20", "Enter task name: ")
editBox := scriptTemplateGui.Add("Edit", "vTaskName x120 y40 w400 h60", "")

scriptTemplateGui.Add("Button", "x855 y130 w80 h30", "Ok").OnEvent("Click", ProcessUserInput)


ScriptTemplate() {
    clipboard := A_Clipboard
    startIndex := InStr(clipboard, "\", false, -1)

    if startIndex
    {
        extractedText := SubStr(clipboard, startIndex + 1)
        A_Clipboard := extractedText
    }

    scriptTemplateGui.Show()
}

ProcessUserInput(*) {
    inputsFromGui := scriptTemplateGui.Submit()
    todayDate := FormatTime(A_Now, "yyyy-MM-dd")
    scriptTemplate := FileRead("scripting\scriptTemplate.txt")
    scriptTemplateWithDate := StrReplace(scriptTemplate, "dateHere", todayDate)
    finishedScriptTemplate := StrReplace(scriptTemplateWithDate, "TaskHere", inputsFromGui.TaskName)

    A_Clipboard := finishedScriptTemplate
    editBox.Value := ""
    scriptTemplateGui.Hide()
}
; ------------------------------
