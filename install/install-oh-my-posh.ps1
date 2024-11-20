# Install OhMyPosh
winget install JanDeDobbeleer.OhMyPosh -s winget
# Install CacadiaCode Nerd Fonts
oh-my-posh font install CascadiaCode
# Install better Terminal Icons
Install-Module -Name Terminal-Icons -Repository PSGallery

# Install PSReadLine, a code completion tool
# Before, we need install PowerShellGet
Install-Module -Name PowerShellGet -Force
Install-Module  PSReadLine
# If there is a Profile, do a backup
if ( Test-Path -Path $PROFILE -PathType Leaf ) {
    $PROFILE_BAK = $PROFILE + ".bak" 
    Move-Item -Path $PROFILE -Destination $PROFILE_BAK
}
# Download a GitHub Profile to be a new PowerShell Profile
Invoke-WebRequest https://raw.githubusercontent.com/levicm/win-tools/master/powershell/Microsoft.PowerShell_profile.ps1 -OutFile $PROFILE

# Create a new simple profile
#New-Item -Path $PROFILE -Type File -Force
#Write-Output "oh-my-posh init pwsh | Invoke-Expression" > $PROFILE

