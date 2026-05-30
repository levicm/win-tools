# Disable Windows Defender - Comprehensive Script
#
# Layers applied in this order (most effective first):
#   1. Set-MpPreference   - disables scanning engines while service is still alive
#   2. Scheduled tasks    - always applicable, no restriction
#   3. Services           - requires Tamper Protection OFF
#   4. Group Policy keys  - belt-and-suspenders; survives reboots, works even with TP ON
#   5. Direct registry    - best-effort; protected by TrustedInstaller ACL even with TP off
#
# PRE-REQUISITE: disable Tamper Protection first via
#   Windows Security > Virus & threat protection > Manage settings > Tamper Protection (OFF)

Function CheckTamperProtection {
    $tp = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features" `
                             -Name "TamperProtection" -ErrorAction SilentlyContinue).TamperProtection
    if ($tp -eq 5) {
        Write-Warning "Tamper Protection is ON (value=5)."
        Write-Warning "Disable it first: Windows Security > Virus & threat protection > Manage settings > Tamper Protection (OFF)"
        Write-Warning "Layers 1 and 3 will be blocked until you do so. Layer 2 and 4 will still apply."
        Write-Host ""
    } else {
        Write-Host "Tamper Protection is off (value=$tp)."
    }
}

Function DisableDefenderMpPreference {
    Write-Host ""
    Write-Host "[Layer 1] Set-MpPreference - disabling scanning engines..."

    $svc = Get-Service -Name "WinDefend" -ErrorAction SilentlyContinue
    if ($null -eq $svc -or $svc.Status -ne "Running") {
        Write-Host "  WinDefend service is not running - Set-MpPreference not needed (engine already down)."
        return
    }

    Try {
        Set-MpPreference -DisableRealtimeMonitoring                       $true  -ErrorAction Stop
        Set-MpPreference -DisableBehaviorMonitoring                       $true
        Set-MpPreference -DisableBlockAtFirstSeen                         $true
        Set-MpPreference -DisableIOAVProtection                           $true
        Set-MpPreference -DisablePrivacyMode                              $true
        Set-MpPreference -DisableArchiveScanning                          $true
        Set-MpPreference -DisableIntrusionPreventionSystem                $true
        Set-MpPreference -DisableScriptScanning                           $true
        Set-MpPreference -DisableRemovableDriveScanning                   $true
        Set-MpPreference -DisableScanningMappedNetworkDrivesForFullScan   $true
        Set-MpPreference -DisableScanningNetworkFiles                     $true
        Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine    $true
        Set-MpPreference -MAPSReporting                                   Disabled
        Set-MpPreference -SubmitSamplesConsent                            2
        Set-MpPreference -UILockdown                                      $true
        Set-MpPreference -LowThreatDefaultAction                          Allow
        Set-MpPreference -ModerateThreatDefaultAction                     Allow
        Set-MpPreference -HighThreatDefaultAction                         Allow
        Set-MpPreference -SevereThreatDefaultAction                       Allow
        Write-Host "  Set-MpPreference settings applied."
    } Catch {
        Write-Warning "  Set-MpPreference blocked (Tamper Protection may still be ON): $_"
    }
}

Function DisableDefenderScheduledTasks {
    Write-Host ""
    Write-Host "[Layer 2] Scheduled tasks - disabling..."
    $taskPath = "\Microsoft\Windows\Windows Defender\"
    $tasks = @(
        "Windows Defender Cache Maintenance"
        "Windows Defender Cleanup"
        "Windows Defender Scheduled Scan"
        "Windows Defender Verification"
    )
    foreach ($task in $tasks) {
        $result = Disable-ScheduledTask -TaskName $task -TaskPath $taskPath -ErrorAction SilentlyContinue
        if ($result) {
            Write-Host "  Disabled: $task"
        } else {
            Write-Host "  Already disabled or not found: $task"
        }
    }
}

Function DisableDefenderServices {
    Write-Host ""
    Write-Host "[Layer 3] Services - setting Start=4 (disabled)..."

    # Defender core services and drivers
    $services = @(
        "WinDefend"   # Microsoft Defender Antivirus Service
        "WdNisSvc"    # Microsoft Defender Antivirus Network Inspection Service
        "WdNisDrv"    # Microsoft Network Realtime Inspection Service (driver)
        "WdFilter"    # Microsoft antimalware file system filter driver
        "WdBoot"      # Microsoft Defender Antivirus Boot Driver
        "Sense"       # Windows Defender Advanced Threat Protection (Pro/Enterprise only)
    )

    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services"
    foreach ($svc in $services) {
        $svcObj = Get-Service -Name $svc -ErrorAction SilentlyContinue
        if ($null -eq $svcObj) {
            Write-Host "  Not found (may not apply to this edition): $svc"
            continue
        }
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Try {
            Set-ItemProperty -Path "$regPath\$svc" -Name "Start" -Type DWord -Value 4 -ErrorAction Stop
            Write-Host "  Disabled: $svc"
        } Catch {
            # Try sc.exe as an alternative path - sometimes bypasses ACL restrictions
            $scResult = & sc.exe config $svc start= disabled 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  Disabled via sc.exe: $svc"
            } else {
                Write-Warning "  Could not disable $svc - $($_.Exception.Message)"
            }
        }
    }

    # wscsvc (Windows Security Center) - reports Defender status in the tray/Security app
    # Its registry key has TrustedInstaller ACL; stop-only is sufficient
    $wsc = Get-Service -Name "wscsvc" -ErrorAction SilentlyContinue
    if ($wsc -and $wsc.Status -eq "Running") {
        Stop-Service -Name "wscsvc" -Force -ErrorAction SilentlyContinue
        Write-Host "  Stopped: wscsvc (Windows Security Center)"
    }
    & sc.exe config wscsvc start= disabled 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) { Write-Host "  Disabled: wscsvc" }
}

Function DisableDefenderGroupPolicy {
    Write-Host ""
    Write-Host "[Layer 4] Group Policy registry - applies on reboot, survives TP..."

    $defenderPol = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
    If (!(Test-Path $defenderPol)) { New-Item -Path $defenderPol -Force | Out-Null }
    Set-ItemProperty -Path $defenderPol -Name "DisableAntiSpyware" -Type DWord -Value 1
    Set-ItemProperty -Path $defenderPol -Name "DisableAntiVirus"   -Type DWord -Value 1

    $rtpPol = "$defenderPol\Real-Time Protection"
    If (!(Test-Path $rtpPol)) { New-Item -Path $rtpPol -Force | Out-Null }
    Set-ItemProperty -Path $rtpPol -Name "DisableRealtimeMonitoring"   -Type DWord -Value 1
    Set-ItemProperty -Path $rtpPol -Name "DisableBehaviorMonitoring"   -Type DWord -Value 1
    Set-ItemProperty -Path $rtpPol -Name "DisableOnAccessProtection"   -Type DWord -Value 1
    Set-ItemProperty -Path $rtpPol -Name "DisableScanOnRealtimeEnable" -Type DWord -Value 1
    Set-ItemProperty -Path $rtpPol -Name "DisableIOAVProtection"       -Type DWord -Value 1

    $spynetPol = "$defenderPol\Spynet"
    If (!(Test-Path $spynetPol)) { New-Item -Path $spynetPol -Force | Out-Null }
    Set-ItemProperty -Path $spynetPol -Name "SpynetReporting"     -Type DWord -Value 0
    Set-ItemProperty -Path $spynetPol -Name "SubmitSamplesConsent" -Type DWord -Value 2

    $mpePol = "$defenderPol\MpEngine"
    If (!(Test-Path $mpePol)) { New-Item -Path $mpePol -Force | Out-Null }
    Set-ItemProperty -Path $mpePol -Name "MpCloudBlockLevel" -Type DWord -Value 0

    $repPol = "$defenderPol\Reporting"
    If (!(Test-Path $repPol)) { New-Item -Path $repPol -Force | Out-Null }
    Set-ItemProperty -Path $repPol -Name "DisableEnhancedNotifications" -Type DWord -Value 1

    $scanPol = "$defenderPol\Scan"
    If (!(Test-Path $scanPol)) { New-Item -Path $scanPol -Force | Out-Null }
    Set-ItemProperty -Path $scanPol -Name "DisableArchiveScanning"        -Type DWord -Value 1
    Set-ItemProperty -Path $scanPol -Name "DisableRemovableDriveScanning" -Type DWord -Value 1
    Set-ItemProperty -Path $scanPol -Name "DisableScanningNetworkFiles"   -Type DWord -Value 1

    Write-Host "  Group Policy keys applied."
}

Function DisableDefenderDirectRegistry {
    Write-Host ""
    Write-Host "[Layer 5] Direct Defender registry (best-effort - protected by TrustedInstaller ACL)..."
    # Note: HKLM:\SOFTWARE\Microsoft\Windows Defender is owned by TrustedInstaller.
    # Even with Tamper Protection OFF and running as Administrator, write access is denied.
    # This layer will silently fail on most systems - that is expected and OK.
    Try {
        $defenderKey = "HKLM:\SOFTWARE\Microsoft\Windows Defender"
        Set-ItemProperty -Path $defenderKey -Name "DisableAntiSpyware" -Type DWord -Value 1 -ErrorAction Stop
        Set-ItemProperty -Path $defenderKey -Name "DisableAntiVirus"   -Type DWord -Value 1
        Write-Host "  Direct registry keys applied (rare - TrustedInstaller allowed write)."
    } Catch {
        Write-Host "  Skipped - TrustedInstaller ACL blocks write (expected behavior, not a failure)."
    }
}

Function ShowDefenderStatus {
    Write-Host ""
    Write-Host "============================================"
    Write-Host " RESULT"
    Write-Host "============================================"
    Try {
        $status = Get-MpComputerStatus -ErrorAction Stop
        $running = $status.AMRunningMode -ne "Not running"
        Write-Host "  AMRunningMode      : $($status.AMRunningMode)$(if (-not $running) { ' [OK - not running]' } else { ' [WARNING - still active]' })"
        Write-Host "  AntivirusEnabled   : $($status.AntivirusEnabled)"
        Write-Host "  RealTimeProtection : $($status.RealTimeProtectionEnabled)"
        Write-Host "  BehaviorMonitor    : $($status.BehaviorMonitorEnabled)"
    } Catch {
        Write-Host "  Defender status unavailable (service is stopped - this means it worked)."
    }
    $tp = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features" `
                             -Name "TamperProtection" -ErrorAction SilentlyContinue).TamperProtection
    Write-Host "  TamperProtection   : $tp (5=on / 4 or 1=off)"
    Write-Host "============================================"
    Write-Host ""
    Write-Host "A reboot is recommended. Group Policy changes only take full effect after restart."
    Write-Host "After rebooting, Windows Update may attempt to re-enable Defender."
    Write-Host "The Group Policy keys (Layer 4) will prevent that on non-managed Home editions."
}

# Main - order matters: Set-MpPreference must run before services are stopped
CheckTamperProtection
DisableDefenderMpPreference
DisableDefenderScheduledTasks
DisableDefenderServices
DisableDefenderGroupPolicy
DisableDefenderDirectRegistry
ShowDefenderStatus
