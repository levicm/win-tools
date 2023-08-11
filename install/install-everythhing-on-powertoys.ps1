# URL and Destination
$pluginUrl = "https://github.com/lin-ycv/EverythingPowerToys/releases/download/v0.72.0/Everything-0.72.0-x64.zip"
# Extract path
$extractPath = "c:\temp\"
# Get zipfile name from source URL
$zipFile = $extractPath + $(Split-Path -Path $pluginUrl -Leaf)
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

# Create temp destination for the zip
if (!(Test-Path -Path $extractPath)) {
    mkdir $extractPath
}

# Download file
Write-Host "Downloading file..."
Invoke-WebRequest -Uri $pluginUrl -OutFile $zipFile

Write-Host "Extracting file..."
# Create instance of COM Object
$objShell = New-Object -ComObject Shell.Application
# Extract the Files
$extractedFiles = $ObjShell.NameSpace($zipFile).Items()
# Copy the extracted files to the destination folder
$ObjShell.NameSpace($extractPath).CopyHere($extractedFiles)

if (Test-Path -Path $powertoysLocalPath) {
    $powertoysPath = $powertoysLocalPath
}

if (Test-Path -Path $powertoysPath) {
    # Powertoys plugins path
    $powertoysPluginsPath = $powertoysPath + "modules\launcher\Plugins\"
    $pluginFolderName = "Everything"
    $sourceFolder = $extractPath + $pluginFolderName
    $destFolder = $powertoysPluginsPath + $pluginFolderName
    
    Write-Host "Coping files from " $sourceFolder "to" $destFolder "..."
    Copy-Item -Force $sourceFolder $destFolder
} else {
    Write-Host "PowerToys path not found!!"
}
