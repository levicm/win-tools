# WinTools

PowerShell toolkit for setting up a clean, debloated Windows 10/11 machine from scratch. Inspired by Chris Titus Tech's debloat scripts, extended with additional tools and apps I install on every machine I use.

## Customizing

Fork the project and comment out anything you don't want. The intended way to skip something is `#` — blocks already commented out in the repo are optional or risky items.

## Running everything

Run as Administrator in PowerShell:

```powershell
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/config-all.ps1)
```

> **Before running:** disable Tamper Protection in Windows Security > Virus & threat protection > Manage settings, so `debloat-defender.ps1` can fully disable Windows Defender.

`config-all.ps1` creates a system restore point, then runs all scripts below in order.

## What it does

### Debloat

| Script | What it removes |
|---|---|
| `debloat-apps.ps1` | Microsoft AppX bloatware (Teams, Xbox, Bing apps, Zune, etc.), third-party sponsored apps (CandyCrush, Facebook, Netflix, etc.), Widgets (Win11) |
| `debloat-defender.ps1` | Windows Defender — 5 layers: Set-MpPreference, scheduled tasks, services, Group Policy registry, direct registry |
| `debloat-services.ps1` | ~45 services set to Manual (telemetry, Xbox, Google/Edge updaters, HP/Dell OEM, geolocation, push notifications, CDP, Intel Energy Server, etc.). Windows Search fully disabled. |
| `debloat-scheduled-tasks.ps1` | Orphan scheduled tasks: .NET NGEN, SmartScreen, PushToInstall, Remote Assistance, Xbox, Intel telemetry, Edge updater, Google Updater, MiniTool, WinSAT, and others |

### Tweaks

| Script | What it configures |
|---|---|
| `tweak-privacy.ps1` | Telemetry, application suggestions, activity history, location tracking, maps, feedback, tailored experiences, advertising ID, error reporting, diagnostics, shared experiences — registry settings + related scheduled tasks |
| `tweak-performance.ps1` | F8 boot menu, storage sense, hibernation, sleep, CloudStore cleanup, Ultimate Performance power plan, Edge preloading |

### UI & features

| Script | What it does |
|---|---|
| `customize.ps1` | Dark mode, Explorer opens to This PC, shows hidden files and extensions, hides taskbar search and Bing, disables Cortana, unpins taskbar icons, disables News & Interests and Meet Now |
| `enable-features.ps1` | Enables Hyper-V, WSL, Windows Sandbox, Telnet, VirtualMachinePlatform (all with `-NoRestart`) |

### App installation

`install-apps.ps1` sets up PSWindowsUpdate, installs Chocolatey, then runs:

| Script | Installs |
|---|---|
| `install/install-essential-apps.ps1` | PowerShell, Windows Terminal, PowerToys, Notepad++, Sublime Text 4, Chrome, Firefox, Adobe Acrobat Reader, 7-Zip, Bitwarden |
| `install/install-dev-apps.ps1` | Git, VS Code, Python 3.10, OpenJDK 17, Eclipse |
| `install/install-office-apps.ps1` | MS Office 365, LibreOffice, CutePDF Writer, PDFsam, Notion |
| `install/install-media-apps.ps1` | Spotify, WhatsApp, Telegram, VLC |
| `install/install-tool-apps.ps1` | Speedtest CLI |
| `install/install-oh-my-posh.ps1` | Oh My Posh, CascadiaCode Nerd Font, Terminal-Icons, PSReadLine, PowerShell profile |

### Utility scripts (`scripts/`)

Standalone helpers not part of the main pipeline — run individually when needed:

| Script | Purpose |
|---|---|
| `scripts/Restart-Explorer.ps1` | Force-restart Explorer after registry changes |
| `scripts/fix-hidden-taskbar-icons.ps1` | Fix missing tray icons |
| `scripts/fast-indexing-disable.ps1` | Disable Windows Search aggressive indexing |
| `scripts/fast-indexing-enable.ps1` | Re-enable fast indexing |
| `scripts/former-context-menu-enable.ps1` | Restore Windows 10 right-click menu in Win11 |
| `scripts/former-context-menu-disable.ps1` | Revert to Win11 context menu |
| `scripts/vs-code-context-menu.ps1` | Add "Open with VS Code" to file/folder context menus |

## Running individual scripts

Every script is self-contained and can be run alone:

```powershell
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/tweak-privacy.ps1)
iex (irm https://raw.githubusercontent.com/levicm/win-tools/master/debloat-services.ps1)
# etc.
```

All scripts require PowerShell running as Administrator. A single reboot after `config-all.ps1` is recommended.
