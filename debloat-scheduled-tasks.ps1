Function DisableTask([string]$fullPath) {
    $parts = $fullPath.TrimStart('\').split('\')
    $name  = $parts[-1]
    $path  = if ($parts.Length -le 1) { '\' } else { '\' + ($parts[0..($parts.Length-2)] -join '\') + '\' }
    Disable-ScheduledTask -TaskName $name -TaskPath $path -ErrorAction SilentlyContinue | Out-Null
}

Function DisableScheduledTasks {
    Write-Output "Disabling scheduled tasks (ungrouped — themed tasks live in tweak-privacy/tweak-performance)..."

    # .NET background JIT precompilation — no user benefit, slows boot
    DisableTask "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319"
    DisableTask "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64"
    DisableTask "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64 Critical"
    DisableTask "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 Critical"

    # SmartScreen application identity check
    DisableTask "\Microsoft\Windows\AppID\SmartScreenSpecific"

    # Mobile Broadband metadata parser
    DisableTask "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"

    # PushToInstall — MS Store background auto-install
    DisableTask "\Microsoft\Windows\PushToInstall\LoginCheck"
    DisableTask "\Microsoft\Windows\PushToInstall\Registration"

    # Remote Assistance
    DisableTask "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask"

    # Speech model background download
    DisableTask "\Microsoft\Windows\Speech\SpeechModelDownloadTask"

    # Windows Media Sharing library update
    DisableTask "\Microsoft\Windows\Windows Media Sharing\UpdateLibrary"

    # WinSAT performance assessment (useful only on fresh install)
    DisableTask "\Microsoft\Windows\Maintenance\WinSAT"

    # Xbox Game Save
    DisableTask "\Microsoft\XblGameSave\XblGameSaveTask"

    # Intel telemetry / energy server (root-level tasks)
    DisableTask "\IUM-F1E24CA0-B63E-4F13-A9E3-4ADE3BFF3473"
    DisableTask "\IntelSURQC-Upgrade-86621605-2a0b-4128-8ffc-15514c247132"
    DisableTask "\IntelSURQC-Upgrade-86621605-2a0b-4128-8ffc-15514c247132-Logon"
    DisableTask "\USER_ESRV_SVC_QUEENCREEK"

    # Microsoft Edge auto-update tasks (root-level)
    DisableTask "\MicrosoftEdgeUpdateTaskMachineCore"
    DisableTask "\MicrosoftEdgeUpdateTaskMachineUA"

    # Third-party update checkers (root-level)
    DisableTask "\MiniToolPartitionWizard"

    # Google Updater — name contains an install-specific GUID, disable by path
    Get-ScheduledTask -TaskPath "\GoogleSystem\GoogleUpdater\" -ErrorAction SilentlyContinue | Disable-ScheduledTask -ErrorAction SilentlyContinue | Out-Null
    Get-ScheduledTask -TaskPath "\GoogleUserPEH\"              -ErrorAction SilentlyContinue | Disable-ScheduledTask -ErrorAction SilentlyContinue | Out-Null
}

DisableScheduledTasks
