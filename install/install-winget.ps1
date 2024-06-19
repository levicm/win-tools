Write-Host "Checking winget..."
[bool] $doInstall = $true
# Check if winget is installed
if (Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe) {
    Write-Host "Winget Already Installed"
    Write-Host "Checking if it is working..."
    winget upgrade
    if ($LastExitCode -eq 0) {
        Write-Host "Winget is ok"
        $doInstall = $false
    } else {
        Write-Host "Winget is installed but is not working well"
    }
}
if ($doInstall) {
    # Installing winget from the Github...
    Write-Host "Winget not found or not working, installing it..."
    # get latest download url
    $URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
    $URL = (Invoke-WebRequest -Uri $URL).Content | ConvertFrom-Json |
            Select-Object -ExpandProperty "assets" |
            Where-Object "browser_download_url" -Match '.msixbundle' |
            Select-Object -ExpandProperty "browser_download_url"
    # download
    Invoke-WebRequest -Uri $URL -OutFile "Setup.msix" -UseBasicParsing
    # install
    Add-AppxPackage -Path "Setup.msix"
    # delete file
    Remove-Item "Setup.msix"
    Write-Host "Winget Installed!"
}
