# win10script
This Windows Scripts is a creation from multiple debloat scripts and gists from github. The main origin was a Chris Titus repo. I also added other tools to the script that I install on every machine I use.

## Modifications
I encourage people to fork this project and comment out things they don't like! 
Comment any thing you don't want out... 

## Running all
To do all tweaks, debloats and installations you just have to run the win-tools.ps1 script and a new Windows 10/11 machine will be prepered to use as I like, with the execution of the scripts:
* **win-tweaks.ps1**: lot of tweaks for Windows 10/11;
* **win-customize.ps1**: personalize Windows options such as showing task manager details, showing file operations details, disable news and interest, and so on...; 
* **win-debloat.ps1**: uninstall Microsoft and third-party bloatwares;
* **win-enable-features.ps1**: enable Windows optional features such as Hyper-V and WSL; 
* **install-winget.ps1**: Instalation of WinGet Package Manager;
* Instalation of Chocolatey Package Manager;
* **install-essential-apps.ps1**: Instalation of some essential apps (windows-terminal, autohotkey, GoogleChrome, Firefox, NotepadPlusPlus, FoxitReader, Adobereader, 7zip,  Bitwarden, powertoys);
* **install-tool-apps.ps1**: Instalation of some tool apps (virtualbox, vmware-workstation-player, etcher, scrcpy, ccleaner, hwinfo, speedtest, ext2fsd);
* **install-office-apps.ps1**: Instalation of some office apps (MS Office 365, LibreOffice);
* **install-dev-apps.ps1**: Instalation of some develop apps (VS Code, Eclipse);
* **install-media-apps.ps1**: Instalation of some media apps (VLC, BSPlayer);

Copy and paste this line on a PowerShell screen with admin rights, press ENTER and all the magic will be done:
```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/levicm/win10script/master/prepare-windows.ps1'));
```
