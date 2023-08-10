Write-Host "Installing Chocolatey..."
iex (irm https://chocolatey.org/install.ps1);

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
