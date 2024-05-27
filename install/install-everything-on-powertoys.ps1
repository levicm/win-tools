# Everything path
$everythingPath = "C:\Program Files\Everything\"
# Powertoys path
$powertoysPath = "C:\Program Files\PowerToys\"
$powertoysLocalPath = "$($env:LOCALAPPDATA)\PowerToys\"

Write-Host "Install Everything plugin on PowerToys Run..."

# Install Powertoys
if ((Test-Path -Path $powertoysPath) -OR (Test-Path -Path $powertoysLocalPath)) {
    Write-Host "PowerToys found!"
} else {
    Write-Host "PowerToys not found! Installing..."
    winget install Microsoft.PowerToys --disable-interactivity --silent
}

# Install Everything
if (Test-Path -Path $everythingPath) {
    Write-Host "Everything found!"
} else {
    Write-Host "Everything not found! Installing..."
    winget install voidtools.Everything --disable-interactivity --silent
}

# Install Everything PowerToys Plugin
winget install lin-ycv.EverythingPowerToys --disable-interactivity --silent
