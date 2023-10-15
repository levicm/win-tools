$CodePath = $Env:USERPROFILE+"\AppData\Local\Programs\Microsoft VS Code\Code.exe"
#  Open files
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\*\shell\Open with VS Code") -ne $true) {  
    New-Item "HKLM:\SOFTWARE\Classes\*\shell\Open with VS Code" -force -ea SilentlyContinue 
};
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\*\shell\Open with VS Code' -Name '(default)' -Value 'Edit with VS Code' -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\*\shell\Open with VS Code' -Name 'Icon' -Value """$CodePath"",0" -PropertyType String -Force -ea SilentlyContinue;

if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\*\shell\Open with VS Code\command") -ne $true) {  
    New-Item "HKLM:\SOFTWARE\Classes\*\shell\Open with VS Code\command" -force -ea SilentlyContinue 
};
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\*\shell\Open with VS Code\command' -Name '(default)' -Value """$CodePath"" ""%1""" -PropertyType String -Force -ea SilentlyContinue;

if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\shell\vscode") -ne $true) {  
    New-Item "HKLM:\SOFTWARE\Classes\Directory\shell\vscode" -force -ea SilentlyContinue 
};
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Directory\shell\vscode' -Name '(default)' -Value 'Open Folder as VS Code Project' -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Directory\shell\vscode' -Name 'Icon' -Value """$CodePath"",0" -PropertyType String -Force -ea SilentlyContinue;

if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\shell\vscode\command") -ne $true) {  
    New-Item "HKLM:\SOFTWARE\Classes\Directory\shell\vscode\command" -force -ea SilentlyContinue 
};
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Directory\shell\vscode\command' -Name '(default)' -Value """$CodePath"" ""%1""" -PropertyType String -Force -ea SilentlyContinue;

if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\Background\shell\vscode") -ne $true) {  
    New-Item "HKLM:\SOFTWARE\Classes\Directory\Background\shell\vscode" -force -ea SilentlyContinue 
};
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Directory\Background\shell\vscode' -Name '(default)' -Value 'Open Folder as VS Code Project' -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Directory\Background\shell\vscode' -Name 'Icon' -Value """$CodePath"",0" -PropertyType String -Force -ea SilentlyContinue;

if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Classes\Directory\Background\shell\vscode\command") -ne $true) {  
    New-Item "HKLM:\SOFTWARE\Classes\Directory\Background\shell\vscode\command" -force -ea SilentlyContinue 
};
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Classes\Directory\Background\shell\vscode\command' -Name '(default)' -Value """$CodePath"" ""%V""" -PropertyType String -Force -ea SilentlyContinue;
