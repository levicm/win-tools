Write-Host "Installing Chocolatey..."
iex (irm https://chocolatey.org/install.ps1);

Write-Host "Installing Wiget..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/install/install-winget.ps1);

Write-Host "Debloat..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/win-debloat.ps1);

Write-Host "Essential tweaks..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/win-tweaks.ps1);

Write-Host "Customize..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/win-customize.ps1);

Write-Host "Windows optional features..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/win-enable-features.ps1);

Write-Host "Installing Essential Apps..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/install/install-essential-apps.ps1);

Write-Host "Installing Tool Apps..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/install/install-tool-apps.ps1);

Write-Host "Installing Office Apps..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/install/install-office-apps.ps1);

Write-Host "Installing Dev Apps..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/install/install-dev-apps.ps1);

Write-Host "Installing Media Apps..."
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/install/install-media-apps.ps1);
