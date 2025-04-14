#Requires AutoHotkey v2.0

CreateUserGui := Gui("+AlwaysOnTop -Caption +Border")
CreateUserGui.Add("Text", "vCenter w200", "TenantId")
TenantId := CreateUserGui.Add("Edit", "w200", "")
UserNameInput := CreateUserGui.Add("Edit", "vUserName w200", "")
PasswordInput := CreateUserGui.Add("Edit", "vPassword w200", "")
CreateButton := CreateUserGui.Add("Button", "Default", "Create User").OnEvent("Click", HandleSubmit)

CreateUser() {
    CreateUserGui.Show()
}

HandleSubmit(*) {
    CreateUserGui.Hide()
    UserNameInput.Text := ""
    PasswordInput.Text := ""

    MsgBox("Creating user: " UserNameInput.Text " with password: " PasswordInput.Text)
}