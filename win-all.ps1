Write-Host "Installing Winget..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/install/install-winget.ps1);

Write-Host "Debloat..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/win-debloat.ps1);

Write-Host "Essential tweaks..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/win-tweaks.ps1);

Write-Host "Customize..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/win-customize.ps1);

Write-Host "Windows optional features..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/win-enable-features.ps1);

Write-Host "Installing Apps..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/win-install-apps.ps1);
