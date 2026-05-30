# WinTools — CLAUDE.md

## Project purpose

PowerShell toolkit for setting up a clean, debloated Windows 10/11 machine from scratch. Removes Microsoft and third-party bloatware, disables telemetry and unnecessary services, applies privacy/performance tweaks, configures the UI, enables optional features, and installs a curated set of apps — all runnable remotely via `iex (irm <url>)`.

## Entry points

| Script | Role |
|---|---|
| [config-all.ps1](config-all.ps1) | Orchestrator — creates restore point, then runs all scripts below in order |
| [debloat-apps.ps1](debloat-apps.ps1) | Removes AppX bloatware (MS + third-party) and Widgets |
| [debloat-defender.ps1](debloat-defender.ps1) | Disables Windows Defender (5 layers) |
| [debloat-services.ps1](debloat-services.ps1) | Sets ~45 services to Manual; fully disables WSearch |
| [debloat-scheduled-tasks.ps1](debloat-scheduled-tasks.ps1) | Disables orphan scheduled tasks (no thematic group) |
| [tweak-privacy.ps1](tweak-privacy.ps1) | Telemetry, location, advertising, feedback, CEIP, shared experiences |
| [tweak-performance.ps1](tweak-performance.ps1) | F8, hibernate, sleep, power plan, storage sense, Edge preloading |
| [customize.ps1](customize.ps1) | UI/Explorer customization |
| [enable-features.ps1](enable-features.ps1) | Enables optional Windows features |
| [install-apps.ps1](install-apps.ps1) | PSWindowsUpdate setup + Chocolatey + delegates to install/* scripts |

## Script map

### Debloat — apps ([debloat-apps.ps1](debloat-apps.ps1))
Three functions called at the end:
- `DebloatMS` — removes Microsoft AppX packages (Teams, Xbox, Bing apps, Zune, Wallet, Maps, etc.) and uses `winget uninstall` for Teams and Xbox if winget is available.
- `DebloatThirdParty` — removes sponsored/pre-installed third-party AppX packages (CandyCrush, Facebook, Netflix, Disney, Clipchamp, etc.).
- `DebloatWidgets` — hides Widgets taskbar button via registry and uninstalls the "Windows web experience pack" via winget (Win11).

Each AppX package is removed with three guarded calls: per-user, provisioned (new user accounts), and all-users. The result of `Get-AppxPackage` is stored in a variable before piping to prevent PowerShell from prompting when the package is not installed.

### Debloat — Defender ([debloat-defender.ps1](debloat-defender.ps1))
Applies five layers in order — see **Disabling Windows Defender** section below.

### Debloat — services ([debloat-services.ps1](debloat-services.ps1))
`DisableServices` — sets ~45 services from Automatic to Manual. Supports wildcards for per-user services (e.g. `cbdhsvc_*`, `CDPUserSvc_*`). Handles both single matches and multi-match wildcards with an inner `foreach`. Fully disables `WSearch` (Windows Search) since setting it to Manual causes it to restart itself.

Categories covered: telemetry/diagnostics, Xbox, Google/Edge updaters, HP/Dell OEM bloat, Adobe/Foxit updaters, geolocation, fax, Maps, ICS, push notifications, CDP, Intel Energy Server, Defender-related (MDCoreSvc, webthreatdefusersvc).

### Debloat — scheduled tasks ([debloat-scheduled-tasks.ps1](debloat-scheduled-tasks.ps1))
`DisableScheduledTasks` — disables tasks that have no natural thematic group. Themed tasks (telemetry, location, feedback, etc.) are disabled inline in `tweak-privacy.ps1` and `tweak-performance.ps1` next to their registry counterparts.

Orphan tasks covered: .NET NGEN (4), SmartScreen, Mobile Broadband, PushToInstall, Remote Assistance, Speech model, Windows Media Sharing, WinSAT, Xbox Game Save, Intel telemetry (4 root-level tasks), Edge auto-update (2), MiniTool. Google Updater tasks disabled by path (GUID in name varies per install).

Uses a `DisableTask` helper that correctly splits `\Path\To\TaskName` into `-TaskPath` and `-TaskName`, including root-level tasks (`\TaskName` → `TaskPath = '\'`).

### Tweaks — privacy ([tweak-privacy.ps1](tweak-privacy.ps1))
`TweakPrivacy` — registry settings + related scheduled tasks, grouped by topic:
- Telemetry (AllowTelemetry registry + 17 CEIP/AppExp/Flighting tasks)
- Application suggestions (ContentDeliveryManager, CloudContent policy)
- Activity History
- Location Tracking (registry + 2 tasks)
- Maps (registry + 1 task)
- Feedback (registry + 2 tasks)
- Tailored Experiences
- Advertising ID
- Error Reporting (registry + 1 task)
- Scheduled Diagnostics (5 tasks)
- Shared Experiences / CDP (registry + 2 tasks)

### Tweaks — performance ([tweak-performance.ps1](tweak-performance.ps1))
`TweakPerformance`:
- F8 legacy boot menu (`bcdedit`)
- Storage Sense (registry removal + 1 task)
- Hibernation and Sleep (registry + FlyoutMenuSettings)
- CloudStore registry removal
- Ultimate Performance power plan (`powercfg -duplicatescheme`)
- Edge Preloading (Group Policy registry)

### Customize ([customize.ps1](customize.ps1))
- `Customize` — shows file operation details, hides People icon, shows all tray icons, disables News & Interests and Meet Now, sets Explorer to open "This PC", hides 3D Objects, enables dark mode, disables Cortana in Search, hides taskbar search box, disables Bing web results, disables live tiles, shows hidden files and extensions, unpins all taskbar icons.
- `RestartExplorer` — kills Explorer so changes take effect immediately.

### Enable Features ([enable-features.ps1](enable-features.ps1))
`EnableOptionalFeatures` — enables: TelnetClient, VirtualMachinePlatform, Hyper-V (`Microsoft-Hyper-V-All`), WSL (`Microsoft-Windows-Subsystem-Linux`), Windows Sandbox (`Containers-DisposableClientVM`). All with `-NoRestart`.

### App installation ([install-apps.ps1](install-apps.ps1) + [install/](install/))
`install-apps.ps1` — sets up PSWindowsUpdate module, installs Chocolatey, then delegates to:

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
Standalone helper scripts with no relation to the debloat/tweak pipeline:

| Script | Purpose |
|---|---|
| [scripts/Restart-Explorer.ps1](scripts/Restart-Explorer.ps1) | Force-kills Explorer (run after registry changes) |
| [scripts/fix-hidden-taskbar-icons.ps1](scripts/fix-hidden-taskbar-icons.ps1) | Fixes missing tray icons by minimize/restore all windows |
| [scripts/fast-indexing-disable.ps1](scripts/fast-indexing-disable.ps1) | Disables Windows Search aggressive indexing |
| [scripts/fast-indexing-enable.ps1](scripts/fast-indexing-enable.ps1) | Re-enables fast indexing |
| [scripts/former-context-menu-enable.ps1](scripts/former-context-menu-enable.ps1) | Restores Windows 10 right-click menu in Win11 |
| [scripts/former-context-menu-disable.ps1](scripts/former-context-menu-disable.ps1) | Reverts to Win11 context menu |
| [scripts/vs-code-context-menu.ps1](scripts/vs-code-context-menu.ps1) | Adds "Open with VS Code" to file and folder context menus |

### PowerShell profile ([powershell/](powershell/))
[powershell/Microsoft.PowerShell_profile.ps1](powershell/Microsoft.PowerShell_profile.ps1) — activates Oh My Posh with `jandedobbeleer` theme, Terminal-Icons, and PSReadLine on every session.

## Conventions

- **Customization via commenting**: the intended way to exclude something is to comment it out with `#`. Blocks already commented out in the repo are examples of optional or risky items.
- **Naming scheme**: `debloat-*.ps1` for removal/disabling, `tweak-*.ps1` for registry configuration, no prefix for UI/features/install orchestration.
- **Themed tasks inline**: scheduled task disabling lives next to its related registry block (e.g., location tasks disabled inside the Location Tracking block of `tweak-privacy.ps1`). Only orphan tasks go in `debloat-scheduled-tasks.ps1`.
- **winget is preferred** over Chocolatey for new installs. Chocolatey is only used where winget lacks a package (Eclipse).
- **All scripts require admin rights** — run PowerShell as Administrator.
- **Scripts are self-contained**: each can be run individually or fetched via `iex (irm <url>)` from the raw GitHub URL.
- **No mandatory restarts mid-run**: features are enabled with `-NoRestart`; a single reboot after `config-all.ps1` is expected.

## Disabling Windows Defender — layers

`debloat-defender.ps1` applies five layers in order (order matters — Set-MpPreference must run before services are stopped):

| Layer | Method | Works with TP on? |
|---|---|---|
| 1 | `Set-MpPreference` cmdlets (all scanning engines, MAPS, sample submission) | No — blocked by Tamper Protection |
| 2 | Scheduled tasks (4 Defender tasks) | Yes |
| 3 | Services → `Start=4` (WinDefend, WdNisSvc, WdNisDrv, WdFilter, WdBoot, Sense) | No — blocked by Tamper Protection |
| 4 | Group Policy registry (`HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender`) | Yes (takes effect on reboot) |
| 5 | Direct Defender registry (`HKLM:\SOFTWARE\Microsoft\Windows Defender`) | Blocked by TrustedInstaller ACL regardless of TP — best-effort only |

**Required step before running:** disable Tamper Protection manually via Windows Security > Virus & threat protection > Manage settings > Tamper Protection (toggle OFF). Without this, only layers 2 and 4 apply immediately.

**Layer order matters:** `Set-MpPreference` (layer 1) must run while `WinDefend` is still alive. The script detects if the service is already stopped and skips layer 1 gracefully.

**`wscsvc` (Windows Security Center):** stopped but registry key is owned by TrustedInstaller — `sc.exe` is used as fallback. Cosmetic only; it reports Defender status in the tray.

## What to be careful about

- `debloat-services.ps1` sets services to Manual, not Disabled — `WSearch` is the exception (fully Disabled).
- `customize.ps1` unpins all taskbar icons — no undo step in the script.
- Adding packages to `DebloatMS`/`DebloatThirdParty` with exact names (not wildcards) requires the package to exist; wildcards are safer for provisioned packages.
- `install/install-everything-on-powertoys.ps1` is deprecated — do not reference it.
