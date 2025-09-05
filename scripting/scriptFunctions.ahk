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
    scriptTemplate := FileRead("scriptTemplate.txt")
    scriptTemplateWithDate := StrReplace(scriptTemplate, "dateHere", todayDate)
    finishedScriptTemplate := StrReplace(scriptTemplateWithDate, "TaskHere", inputsFromGui.TaskName)

    A_Clipboard := finishedScriptTemplate
    editBox.Value := ""
    scriptTemplateGui.Hide()
}
; ------------------------------

MakeUserLoginable() {
    userName := A_Clipboard
    Send "BEGIN TRANSACTION `n`nUPDATE AspNetUsers SET LockoutEnabled = 0, LockoutEnd = NULL WHERE UserName = '" userName "'`n`nROLLBACK"
    Sleep 300
}

; ------------------------------
; SQL Query Generator Functions
; ------------------------------

; Global GUI for SQL query input
global sqlGui := ""
global tableNameEdit := ""
global columnNameEdit := ""
global queryType := ""

; Create SQL input GUI
CreateSqlGui() {
    global sqlGui, tableNameEdit, columnNameEdit
    
    ; Destroy existing GUI if it exists
    if (sqlGui != "" && IsObject(sqlGui)) {
        try {
            sqlGui.Destroy()
        }
    }
    
    sqlGui := Gui("+Resize", "SQL Query Generator")
    
    sqlGui.Add("Text", "x10 y10 w100 h20", "Table Name:")
    tableNameEdit := sqlGui.Add("Edit", "x120 y10 w300 h25")
    
    sqlGui.Add("Text", "x10 y45 w400 h40", "Column Names (comma-separated):`nExample: FirstName, LastName, Email")
    columnNameEdit := sqlGui.Add("Edit", "x10 y85 w410 h60 Multi VScroll")
    
    sqlGui.Add("Button", "x120 y160 w100 h30", "Generate").OnEvent("Click", GenerateSqlQuery)
    sqlGui.Add("Button", "x230 y160 w100 h30", "Cancel").OnEvent("Click", (*) => sqlGui.Hide())
    
    return sqlGui
}

; Generate the SQL query based on type
GenerateSqlQuery(*) {
    global sqlGui, tableNameEdit, columnNameEdit, queryType
    
    inputs := sqlGui.Submit()
    tableName := tableNameEdit.Text
    columnNamesInput := columnNameEdit.Text
    
    if (tableName == "" || columnNamesInput == "") {
        MsgBox("Please enter both table name and column name(s).")
        return
    }
    
    ; Parse column names (split by comma and trim whitespace)
    columnNames := []
    rawColumns := StrSplit(columnNamesInput, ",")
    for rawColumn in rawColumns {
        trimmedColumn := Trim(rawColumn)
        if (trimmedColumn != "") {
            columnNames.Push(trimmedColumn)
        }
    }
    
    if (columnNames.Length == 0) {
        MsgBox("Please enter at least one valid column name.")
        return
    }
    
    ; Save the current clipboard content to use as LegalEntityId
    legalEntityId := A_Clipboard
    query := ""
    
    switch queryType {
        case "before":
            query := BuildBeforeQuery(tableName, columnNames, legalEntityId)
        case "update":
            query := BuildUpdateQuery(tableName, columnNames, legalEntityId)
        case "after":
            query := BuildAfterQuery(tableName, columnNames, legalEntityId)
    }
    
    ; Completely replace the clipboard with the new query
    A_Clipboard := query
    sqlGui.Hide()
    
    ; Show confirmation
    MsgBox("SQL query copied to clipboard!")
}

; Build the BEFORE query for multiple columns
BuildBeforeQuery(tableName, columnNames, legalEntityId) {
    selectParts := [tableName . ".id"]
    
    ; Add each column and its New counterpart
    for columnName in columnNames {
        selectParts.Push(tableName . "." . columnName)
        selectParts.Push("'' AS New" . columnName)
    }
    
    selectClause := ""
    for i, part in selectParts {
        if (i > 1) {
            selectClause .= ", "
        }
        selectClause .= part
    }
    
    return "SELECT " . selectClause . " INTO #tmp_before_update FROM " . tableName . " WHERE LegalEntityId = '" . legalEntityId . "'"
}

; Build the UPDATE query for multiple columns
BuildUpdateQuery(tableName, columnNames, legalEntityId) {
    setParts := []
    
    ; Add SET clause for each column
    for columnName in columnNames {
        setParts.Push(tableName . "." . columnName . " = tmp.New" . columnName)
    }
    
    setClause := ""
    for i, part in setParts {
        if (i > 1) {
            setClause .= ", "
        }
        setClause .= part
    }
    
    return "UPDATE " . tableName . " SET " . setClause . " FROM " . tableName . " INNER JOIN #tmp_before_update tmp ON " . tableName . ".id = tmp.id WHERE LegalEntityId = '" . legalEntityId . "'"
}

; Build the AFTER query for multiple columns
BuildAfterQuery(tableName, columnNames, legalEntityId) {
    selectParts := [tableName . ".id"]
    
    ; Add each column, its New value, and Old value
    for columnName in columnNames {
        selectParts.Push(tableName . "." . columnName)
        selectParts.Push("tmp.New" . columnName)
        selectParts.Push("tmp." . columnName . " AS Old" . columnName)
    }
    
    selectClause := ""
    for i, part in selectParts {
        if (i > 1) {
            selectClause .= ", "
        }
        selectClause .= part
    }
    
    return "SELECT " . selectClause . " INTO #tmp_after_update FROM " . tableName . " INNER JOIN #tmp_before_update tmp ON " . tableName . ".id = tmp.id WHERE LegalEntityId = '" . legalEntityId . "'"
}

; Functions to open GUI for each query type
SqlQueryBefore() {
    global queryType
    queryType := "before"
    CreateSqlGui()
    sqlGui.Show()
}

SqlQueryUpdate() {
    global queryType
    queryType := "update"
    CreateSqlGui()
    sqlGui.Show()
}

SqlQueryAfter() {
    global queryType
    queryType := "after"
    CreateSqlGui()
    sqlGui.Show()
}