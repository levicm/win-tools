Function DisableServices {
    Write-Host "Disabling services..."

    $services = @(
        "ALG"                                          # Application Layer Gateway Service
        "AJRouter"                                     # AllJoyn Router Service
        "AxInstSV"                                     # ActiveX Installer
        "BcastDVRUserService_*"                        # GameDVR and Broadcast (per-user, wildcard for suffix)
        "cbdhsvc_*"                                    # Clipboard History Service (per-user, wildcard for suffix)
        "CDPSvc"                                       # Connected Devices Platform (cross-device continuity)
        "CDPUserSvc_*"                                 # Connected Devices Platform User Service (per-user)
        "DeviceAssociationService"                     # Device Association (pairing new devices)
        "diagnosticshub.standardcollector.service"     # Diagnostics Hub Standard Collector
        "DiagTrack"                                    # Diagnostics Tracking / Connected User Experiences
        "dmwappushservice"                             # WAP Push Message Routing
        "DoSvc"                                        # Delivery Optimization (P2P Windows Update distribution)
        "DPS"                                          # Diagnostic Policy Service
        "DusmSvc"                                      # Data Usage subscription management
        "edgeupdate"                                   # Microsoft Edge Update Service
        "edgeupdatem"                                  # Microsoft Edge Update Service (on-demand)
        "EntAppSvc"                                    # Enterprise Application Management
        "ESRV_SVC_QUEENCREEK"                          # Intel Energy Server Service (telemetry/perf reporting)
        "Fax"                                          # Fax Service
        "fhsvc"                                        # File History Service
        "GoogleUpdaterService*"                        # Google Updater (current format, wildcard for version)
        "GoogleUpdaterInternalService*"                # Google Updater Internal (current format)
        "gupdate"                                      # Google Update (legacy format)
        "gupdatem"                                     # Google Update on-demand (legacy format)
        "iphlpsvc"                                     # IP Helper / IPv6 tunneling
        "lfsvc"                                        # Geolocation Service
        "lmhosts"                                      # TCP/IP NetBIOS Helper
        "MapsBroker"                                   # Downloaded Maps Manager
        "MDCoreSvc"                                    # Microsoft Defender Core Service
        "MicrosoftEdgeElevationService"                # Microsoft Edge Elevation Service
        "MSDTC"                                        # Distributed Transaction Coordinator
        #"ndu"                                         # Network Data Usage Monitor (breaks Task Manager network tab)
        "NetTcpPortSharing"                            # Net.Tcp Port Sharing
        "OneSyncSvc_*"                                 # Sync Host - email/contacts/calendar sync (per-user)
        "PcaSvc"                                       # Program Compatibility Assistant
        "PerfHost"                                     # Performance Counter DLL Host
        "PhoneSvc"                                     # Phone Service / telephony
        "RemoteAccess"                                 # Routing and Remote Access
        "RemoteRegistry"                               # Remote Registry
        "RetailDemo"                                   # Retail Demo Mode
        "SCardSvr"                                     # Smart Card Service
        "SEMgrSvc"                                     # Payments and NFC/SE Manager
        "SharedAccess"                                 # Internet Connection Sharing (ICS)
        "SysMain"                                      # Superfetch / memory preloading
        "TrkWks"                                       # Distributed Link Tracking Client
        "webthreatdefusersvc_*"                        # Defender Web Threat Defense User Service (per-user)
        "WerSvc"                                       # Windows Error Reporting
        #"wisvc"                                       # Windows Insider (disable only if not in Insider program)
        "WMPNetworkSvc"                                # Windows Media Player Network Sharing
        "WpcMonSvc"                                    # Parental Controls
        "WPDBusEnum"                                   # Portable Device Enumerator
        "WpnService"                                   # Windows Push Notifications System Service
        "WpnUserService_*"                             # Windows Push Notifications User Service (per-user)
        "wscsvc"                                       # Windows Security Center (cosmetic tray reporting only)
        "W32Time"                                      # Windows Time sync (NTP; on-demand is enough)
        "XblAuthManager"                               # Xbox Live Auth Manager
        "XblGameSave"                                  # Xbox Live Game Save
        "XboxNetApiSvc"                                # Xbox Live Networking
        "XboxGipSvc"                                   # Xbox Accessory Management
         # HP services
        "HPAppHelperCap"
        "HPDiagsCap"
        "HPNetworkCap"
        "HPSysInfoCap"
        "HpTouchpointAnalyticsService"
         # Dell services
        "dcpm-notify"                                  # Dell Command | Power Manager Notify
        "DDVCollectorSvcApi"                           # Dell Data Vault API
        "DDVDataCollector"                             # Dell Data Vault Collector
        "DDVRulesProcessor"                            # Dell Data Vault Processor
        "Dell.CommandPowerManager.Service"
        "DellClientManagementService"
        "DellTechHub"
        "DPMService"                                   # Dell Peripheral Manager
        "SupportAssistAgent"                           # Dell SupportAssist
         # Hyper-V services (uncomment if not using Hyper-V)
        #"HvHost"
        #"vmicguestinterface"
        #"vmicheartbeat"
        #"vmickvpexchange"
        #"vmicrdv"
        #"vmicshutdown"
        #"vmictimesync"
        #"vmicvmsession"
        "AdobeARMservice"                              # Adobe Acrobat Update Service
        "FoxitReaderUpdateService"                     # Foxit PDF Reader Update Service
        "StateRepository"                              # State Repository (UWP apps)
        "StorSvc"                                      # Storage Service
    )

    # Inner foreach handles both exact names and wildcard patterns that match multiple services
    foreach ($pattern in $services) {
        $matched = @(Get-Service -Name $pattern -ErrorAction SilentlyContinue)
        if ($matched.Count -eq 0) {
            Write-Host "Service not found: $pattern"
            continue
        }
        foreach ($thisService in $matched) {
            Write-Host "Service $($thisService.Name) ($($thisService.DisplayName)) is $($thisService.StartType)"
            if ($thisService.StartType -eq 'Automatic') {
                Write-Host "  Stopping and setting to Manual: $($thisService.Name)"
                Stop-Service -Name $thisService.Name -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
                Set-Service  -Name $thisService.Name -ErrorAction SilentlyContinue -StartupType Manual
            }
        }
    }

    # Windows Search must be set to Disabled, otherwise it restarts itself
    Write-Output "Stopping and disabling Windows Search Service..."
    Stop-Service "WSearch" -WarningAction SilentlyContinue
    Set-Service "WSearch" -StartupType Disabled
}

DisableServices
