#Requires AutoHotkey v2.0

ExcelToCsv() {
    ; Create Input GUI for Excel file name
    inputGui := Gui()
    inputGui.Add("Text", "", "Enter Excel File Name (without extension):")
    inputFileName := inputGui.Add("Edit", "vExcelFileName")
    inputGui.Add("Button", "Default", "Convert").OnEvent("Click", ButtonConvert)
    inputGui.Show()

    ButtonConvert(*) {
        excelFileName := inputFileName.Value

        if (baseFileName := Trim(excelFileName)) {
            ; Add the ".xlsx" extension
            excelFileName := baseFileName ".xlsx"

            ; Create Excel COM object
            xl := ComObject("Excel.Application")

            ; Make Excel visible (optional, can be set to 0 to run in the background)
            xl.Visible := 1

            ; Open the Excel file
            xlWorkbook := xl.Workbooks.Open(A_MyDocuments "\..\Downloads\" excelFileName)

            ; Specify the CSV file name with the same base name but with .csv extension
            csvFileName := baseFileName ".csv"

            ; Save as CSV
            xlWorkbook.SaveAs(A_MyDocuments "\..\Downloads\" csvFileName, 6) ; 6 corresponds to CSV format

            ; Close Excel without saving changes
            xl.Quit()

            ; Release COM objects
            xlWorkbook := ""
            xl := ""

            MsgBox("Excel file converted to CSV successfully.")
        } else {
            MsgBox("Please enter a valid Excel file name (without extension).")
        }

        inputGui.Destroy()
        return
    }
}