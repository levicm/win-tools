# WinTools — CLAUDE.md

## Project purpose

PowerShell toolkit for setting up a clean, debloated Windows 10/11 machine from scratch. Removes Microsoft and third-party bloatware, disables telemetry and unnecessary services, applies privacy/performance tweaks, configures the UI, enables optional features, and installs a curated set of apps — all runnable remotely via `iex (irm <url>)`.

## Entry points

| Script | Role |
|---|---|
| [win-all.ps1](win-all.ps1) | Orchestrator — runs all scripts below in order |
| [win-debloat.ps1](win-debloat.ps1) | Removes AppX bloatware (MS + third-party) |
| [win-tweaks.ps1](win-tweaks.ps1) | Privacy, telemetry, services, scheduled tasks, performance |
| [win-customize.ps1](win-customize.ps1) | UI/Explorer customization |
| [win-enable-features.ps1](win-enable-features.ps1) | Enables optional Windows features |
| [win-install-apps.ps1](win-install-apps.ps1) | Installs Chocolatey + delegates to install/* scripts |

## Script map

### Debloat ([win-debloat.ps1](win-debloat.ps1))
Two functions called at the end of the file:
- `DebloatMS` — removes Microsoft AppX packages (Teams, Xbox, Bing apps, Zune, Wallet, Maps, etc.) and uses `winget uninstall` for Teams and Xbox if winget is available.
- `DebloatThirdParty` — removes sponsored/pre-installed third-party AppX packages (CandyCrush, Facebook, Netflix, Disney, Clipchamp, etc.).

Each package is removed with three calls: per-user, provisioned (new user accounts), and all-users.

### Tweaks ([win-tweaks.ps1](win-tweaks.ps1))
Four functions called at the end:
- `CreateRestorePoint` — creates a system restore point before any changes.
- `EssentialTweaks` — disables telemetry, app suggestions, activity history, location tracking, advertising ID, error reporting, feedback, Shared Experiences, Windows Defender scheduled tasks, Storage Sense, Edge preloading, Widgets (Win11). Enables F8 boot menu, hibernation, sleep, Ultimate Performance power plan, Windows Update via PSWindowsUpdate.
- `DisableServices` — sets ~40 services from Automatic to Manual (telemetry, Xbox, HP/Dell OEM bloat, Adobe/Foxit updaters, geolocation, fax, Maps, ICS, etc.). Fully disables Windows Search (`WSearch`).
- `DisableScheduledTasks` — disables .NET NGEN background compilation, SmartScreen, CloudExperienceHost, XblGameSave scheduled tasks.

### Customize ([win-customize.ps1](win-customize.ps1))
- `Customize` — shows file operation details, hides People icon, shows all tray icons, disables News & Interests and Meet Now, sets Explorer to open "This PC", hides 3D Objects, enables dark mode, disables Cortana in Search, hides taskbar search box, disables Bing web results in search, disables live tiles, shows hidden files and file extensions, unpins all taskbar icons.
- `RestartExplorer` — kills Explorer so changes take effect immediately.

### Enable Features ([win-enable-features.ps1](win-enable-features.ps1))
Enables: TelnetClient, VirtualMachinePlatform, Hyper-V (`Microsoft-Hyper-V-All`), WSL (`Microsoft-Windows-Subsystem-Linux`), Windows Sandbox (`Containers-DisposableClientVM`). All with `-NoRestart`.

### App installation ([install/](install/))

| Script | Installs |
|---|---|
| [install/install-winget.ps1](install/install-winget.ps1) | Verifies or installs winget from GitHub releases |
| [install/install-essential-apps.ps1](install/install-essential-apps.ps1) | PowerShell, Windows Terminal, PowerToys, Notepad++, Sublime Text 4, Chrome, Firefox, Adobe Acrobat Reader, 7-Zip, Bitwarden |
| [install/install-dev-apps.ps1](install/install-dev-apps.ps1) | Git, VS Code, Python 3.10, OpenJDK 17, Eclipse (via choco) |
| [install/install-tool-apps.ps1](install/install-tool-apps.ps1) | Speedtest CLI (Etcher, scrcpy, CCleaner, HWiNFO, VirtualBox, VMware commented out) |
| [install/install-office-apps.ps1](install/install-office-apps.ps1) | MS Office 365, LibreOffice, CutePDF Writer, PDFsam, Notion |
| [install/install-media-apps.ps1](install/install-media-apps.ps1) | Spotify, WhatsApp (MS Store), Telegram, VLC |
| [install/install-oh-my-posh.ps1](install/install-oh-my-posh.ps1) | Oh My Posh, CascadiaCode Nerd Font, Terminal-Icons, PSReadLine; downloads PowerShell profile |

### Utility scripts ([scripts/](scripts/))

| Script | Purpose |
|---|---|
| [scripts/disable-defender.ps1](scripts/disable-defender.ps1) | Comprehensive Defender disable (5 layers — see below) |
| [scripts/Restart-Explorer.ps1](scripts/Restart-Explorer.ps1) | Force-kills Explorer (run after registry changes) |
| [scripts/FixHiddenTaskbarIcons.ps1](scripts/FixHiddenTaskbarIcons.ps1) | Fixes missing tray icons by minimize/restore all windows |
| [scripts/fast-indexing-disable.ps1](scripts/fast-indexing-disable.ps1) | Disables Windows Search aggressive indexing |
| [scripts/fast-indexing-enable.ps1](scripts/fast-indexing-enable.ps1) | Re-enables fast indexing |
| [scripts/former-context-menu-enable.ps1](scripts/former-context-menu-enable.ps1) | Restores Windows 10 right-click menu in Win11 |
| [scripts/former-context-menu-disable.ps1](scripts/former-context-menu-disable.ps1) | Reverts to Win11 context menu |
| [scripts/vs-code-context-menu.ps1](scripts/vs-code-context-menu.ps1) | Adds "Open with VS Code" to file and folder context menus |

### PowerShell profile ([powershell/](powershell/))
[powershell/Microsoft.PowerShell_profile.ps1](powershell/Microsoft.PowerShell_profile.ps1) — activates Oh My Posh with `jandedobbeleer` theme, Terminal-Icons, and PSReadLine on every session.

## Conventions

- **Customization via commenting**: the intended way to exclude something is to comment it out with `#`. Blocks already commented out in the repo are examples of optional or risky items.
- **winget is preferred** over Chocolatey for new installs. Chocolatey is only used where winget lacks a package (Eclipse).
- **All scripts require admin rights** — run PowerShell as Administrator.
- **Scripts are self-contained**: each can be run individually or fetched via `iex (irm <url>)` from the raw GitHub URL.
- **No mandatory restarts mid-run**: features are enabled with `-NoRestart`; a single reboot after `win-all.ps1` is expected.

## Disabling Windows Defender — layers

`scripts/disable-defender.ps1` applies five layers in order:

| Layer | Method | Works with TP on? |
|---|---|---|
| 1 | `Set-MpPreference` cmdlets (all scanning engines, MAPS, sample submission) | No — blocked by Tamper Protection |
| 2 | Scheduled tasks (4 Defender tasks) | Yes |
| 3 | Services → `Start=4` (WinDefend, WdNisSvc, WdNisDrv, WdFilter, WdBoot, Sense) | No — blocked by Tamper Protection |
| 4 | Group Policy registry (`HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender`) | Yes (takes effect on reboot) |
| 5 | Direct Defender registry (`HKLM:\SOFTWARE\Microsoft\Windows Defender`) | Blocked by TrustedInstaller ACL regardless of TP — best-effort only |

**Required step before running the script:** disable Tamper Protection manually via Windows Security > Virus & threat protection > Manage settings > Tamper Protection (toggle OFF). Without this, only layers 2 and 4 apply immediately.

**Layer order matters:** `Set-MpPreference` (layer 1) must run while `WinDefend` is still alive. The script detects if the service is already stopped and skips layer 1 gracefully in that case.

**`wscsvc` (Windows Security Center):** stopped but not fully disabled via registry — its registry key is owned by TrustedInstaller. This is cosmetic; it only reports Defender status in the system tray.

`win-tweaks.ps1` already applies layers 2 and 4 inline as part of `EssentialTweaks`. Run `disable-defender.ps1` separately after disabling Tamper Protection to complete all layers.

## What to be careful about

- `DisableServices` sets services to Manual, not Disabled — safe for most cases, but `WSearch` is fully disabled.
- `EssentialTweaks` disables Windows Defender scheduled tasks (not real-time protection itself).
- `Customize` unpins all taskbar icons — this has no undo step in the script.
- Adding packages to `DebloatMS`/`DebloatThirdParty` using exact names (not wildcards) requires the package to exist; wildcards are safer for provisioned packages.
- `install/install-everything-on-powertoys.ps1` is deprecated — do not reference it.
