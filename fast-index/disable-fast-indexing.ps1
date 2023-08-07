Write-Host "Disabling fast indexing..."
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows Search\Gathering Manager")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows Search\Gathering Manager" | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Search\Gathering Manager" -Name "DisableBackOff" -Type DWord -Value 0
Stop-Service "Wsearch" -WarningAction SilentlyContinue
Start-Service "Wsearch"
Control /name Microsoft.IndexingOptions