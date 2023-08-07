Write-Host "Installing Wiget..."
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/levicm/win10script/master/install-winget.ps1'));

Write-Host "Essential tweaks..."
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/levicm/win10script/master/windows-tweaks.ps1'));

Write-Host "Windows optional resources..."
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/levicm/win10script/master/enable-win-resources.ps1'));

Write-Host "Installing Chocolatey..."
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));

Write-Host "Installing Essential Apps..."
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/levicm/win10script/master/install-essential-apps.ps1'));

Write-Host "Installing Tool Apps..."
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/levicm/win10script/master/install-tool-apps.ps1'));

Write-Host "Installing Office Apps..."
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/levicm/win10script/master/install-office-apps.ps1'));

Write-Host "Installing Dev Apps..."
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/levicm/win10script/master/install-dev-apps.ps1'));

Write-Host "Installing Media Apps..."
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/levicm/win10script/master/install-media-apps.ps1'));
