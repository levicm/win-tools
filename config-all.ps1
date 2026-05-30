Write-Host "Creating restore point before any changes..."
Enable-ComputerRestore -Drive "C:\"
Checkpoint-Computer -Description "pre-wintools" -RestorePointType "MODIFY_SETTINGS"

Write-Host "Installing Winget..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/install/install-winget.ps1);

Write-Host "Debloat apps..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/debloat-apps.ps1);

Write-Host "Disabling Windows Defender..."
Write-Host "  NOTE: disable Tamper Protection first via Windows Security > Virus protection > Manage settings"
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/debloat-defender.ps1);

Write-Host "Disabling services..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/debloat-services.ps1);

Write-Host "Disabling scheduled tasks..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/debloat-scheduled-tasks.ps1);

Write-Host "Privacy tweaks..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/tweak-privacy.ps1);

Write-Host "Performance tweaks..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/tweak-performance.ps1);

Write-Host "Customize UI..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/customize.ps1);

Write-Host "Enabling Windows optional features..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/enable-features.ps1);

Write-Host "Installing Apps..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/install-apps.ps1);
