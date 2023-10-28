Function DebloatMS {
    $Bloatware = @(
        #Unnecessary Windows 10 AppX Apps
        "Microsoft.Teams"
        "Microsoft.3DBulder"
        "Microsoft.AppConnector"
        "Microsoft.BingFinance"
        "Microsoft.BingNews"
        "Microsoft.BingSports"
        "Microsoft.BingTranslator"
        "Microsoft.BingWeather"
        "Microsoft.GetHelp"
        "Microsoft.Getstarted"
        "Microsoft.Messaging"
        "Microsoft.Microsoft3DViewer"
        "Microsoft.MicrosoftOfficeHub"
        "Microsoft.MicrosoftSolitaireCollection"
        "Microsoft.NetworkSpeedTest"
        "Microsoft.News"
        "Microsoft.Office.Lens"
        "Microsoft.Office.OneNote"
        "Microsoft.Office.Sway"
        "Microsoft.Office.Todo.List"
        "Microsoft.OneConnect"
        "Microsoft.People"
        "Microsoft.PPIProjection"
        "Microsoft.Print3D"
        "Microsoft.SkypeApp"
        "Microsoft.StorePurchaseApp"
        "Microsoft.Todos"
        "Microsoft.Wallet"
        "Microsoft.Whiteboard"
        "Microsoft.WindowsAlarms"
        "microsoft.windowscommunicationsapps"
        "Microsoft.WindowsFeedbackHub"
        "Microsoft.WindowsMaps"
        "Microsoft.WindowsSoundRecorder"
        "Microsoft.Xbox.TCUI"
        "Microsoft.XboxApp"
        #"Microsoft.XboxGameCallableUI"
        "Microsoft.XboxGameOverlay"
        "Microsoft.XboxGamingOverlay"
        "Microsoft.XboxIdentityProvider"
        "Microsoft.XboxSpeechToTextOverlay"
        "Microsoft.ZuneMusic"
        "Microsoft.ZuneVideo"
        "Microsoft.YourPhone"

        #Optional: Typically not removed but you can if you need to for some reason
        #"*Microsoft.Advertising.Xaml_10.1712.5.0_x64__8wekyb3d8bbwe*"
        #"*Microsoft.Advertising.Xaml_10.1712.5.0_x86__8wekyb3d8bbwe*"
        "*Microsoft.BingWeather*"
        #"*Microsoft.MSPaint*"
        "*Microsoft.MicrosoftStickyNotes*"
        "*Microsoft.MixedReality*"
        #"*Microsoft.Windows.Photos*"
        #"*Microsoft.WindowsCalculator*"
        #"*Microsoft.WindowsStore*"
    )
    Write-Host "Debloating MS Apps..."
    foreach ($Bloat in $Bloatware) {
        Get-AppxPackage -Name $Bloat| Remove-AppxPackage
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online
        Get-AppxPackage -AllUsers -Name $Bloat| Remove-AppxPackage
        Write-Host "Trying to remove $Bloat."
    }
    if (Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe){
        Write-Output "Uninstalling MSTeams..."
        winget uninstall "Microsoft.Teams"
        winget uninstall "Microsoft Teams"
        Write-Output "Uninstalling XBox..."
        winget uninstall "Xbox"
        # Webview seems to be used by programs like Citrix
        #Write-Output "Uninstalling Windows 11 Edge Web View..."
        #winget uninstall "Microsoft Edge WebView2 Runtime"
    }

    #Write-Host "Uninstalling Edge..."
    #curl.exe -s "https://raw.githubusercontent.com/AveYo/fox/main/Edge_Removal.bat" -o edge_removal.bat
    #Start-Process edge_removal.bat
}

Function DebloatThirdParty {
    $Bloatware = @(
        #Sponsored Windows 10 AppX Apps
        #Add sponsored/featured apps to remove in the "*AppName*" format
        "*EclipseManager*"
        "*ActiproSoftwareLLC*"
        "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
        "*Duolingo-LearnLanguagesforFree*"
        "*PandoraMediaInc*"
        "*CandyCrush*"
        "*BubbleWitch3Saga*"
        "*Wunderlist*"
        "*Flipboard*"
        "*Twitter*"
        "*Pinterest*"
        "*Facebook*"
        "*Minecraft*"
        "*Royal Revolt*"
        "*Sway*"
        "*Roblox*"
        "*Speed Test*"
        "*Dolby*"
        "*Viber*"
        "*ACGMediaPlayer*"
        "*Netflix*"
        "*OneCalendar*"
        "*LinkedInforWindows*"
        "*HiddenCityMysteryofShadows*"
        "*Hulu*"
        "*HiddenCity*"
        "*AdobePhotoshopExpress*"
        "*Disney*"
        "Clipchamp.Clipchamp*"
    )
    Write-Host "Debloating Third Apps..."
    foreach ($Bloat in $Bloatware) {
        Get-AppxPackage -Name $Bloat| Remove-AppxPackage
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online
        Get-AppxPackage -AllUsers -Name $Bloat| Remove-AppxPackage
        Write-Host "Trying to remove $Bloat."
    }
}

DebloatMS;
DebloatThirdParty;
