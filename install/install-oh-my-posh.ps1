
winget install Microsoft.PowerShell
winget install JanDeDobbeleer.OhMyPosh -s winget
oh-my-posh font install CascadiaCode
New-Item -Path $PROFILE -Type File -Force
Write-Output "oh-my-posh init pwsh | Invoke-Expression" > $PROFILE

