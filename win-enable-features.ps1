Function EnableOptionalFeatures {
    Write-Output "Enabling Telnet Client..."
    Enable-WindowsOptionalFeature -Online -All -NoRestart -FeatureName TelnetClient

    Write-Output "Enabling Virtual Machine Platform..."
    Enable-WindowsOptionalFeature -Online -All -NoRestart -FeatureName VirtualMachinePlatform

    Write-Output "Enabling Hyper-V..."
    Enable-WindowsOptionalFeature -Online -All -NoRestart -FeatureName Microsoft-Hyper-V-All 

    Write-Output "Enabling Windows Subsystem for Linux..."
    Enable-WindowsOptionalFeature -Online -All -NoRestart -FeatureName Microsoft-Windows-Subsystem-Linux

    Write-Output "Enabling Windows Sandbox..."
    Enable-WindowsOptionalFeature -Online -All -NoRestart -FeatureName Containers-DisposableClientVM
}

EnableOptionalFeatures;