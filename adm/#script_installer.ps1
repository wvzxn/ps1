$urlADM = "https://github.com/AutoDarkMode/AutoDarkModeVersion/releases/download/10.4_migration/AutoDarkModeX_Setup_10.4_BETA_migration_installer.exe"
$urlPS = "https://raw.githubusercontent.com/wvzxn/ps1/master/CoreInstaller.ps1"
$urlPSjax = "https://raw.githubusercontent.com/wvzxn/ps1/master/CoreInstaller.ps1"
$urlJAX = "https://raw.githubusercontent.com/Jax-Core/JaxCore/master/CoreInstaller.ps1"

#   Auto Dark Mode
Write-Host "Downloading AutoDarkMode..."
(New-Object System.Net.WebClient).DownloadFile($urlADM, "$env:TMP\adm_10.4b.exe")
Write-Host "Installing AutoDarkMode..."
Start-Process "$env:TMP\adm_10.4b.exe" -Wait -Verb runAs -ArgumentList "/SILENT"
Write-Host "- AutoDarkMode is installed, but you still need to customize it"
Pause

#   ADM Enable scripts
Write-Host "Enabling ADM scripts..."
(New-Object System.Net.WebClient).DownloadFile($urlPS, "$env:APPDATA\AutoDarkMode\#script.ps1")
mkdir "$env:APPDATA\AutoDarkMode\ps1"
(New-Object System.Net.WebClient).DownloadFile($urlPSjax, "$env:APPDATA\AutoDarkMode\ps1\jax_w11.ps1")
@(
    "Enabled: true",
    "Component:",
    "  Scripts:",
    "  - Name: ps1",
    "    Command: powershell",
    "    WorkingDirectory: $env:APPDATA\AutoDarkMode",
    "    ArgsLight: [-ExecutionPolicy, Bypass, -File, .\#script.ps1, Light]",
    "    ArgsDark: [-ExecutionPolicy, Bypass, -File, .\#script.ps1, Dark]",
    "    AllowedSources: [Any]",
    "",
    ""
) | Set-Content "$env:APPDATA\AutoDarkMode\scripts.yaml"
Pause

#   JaxCore
Write-Host "- Complete the JaxCore installation, select YourFlyouts, and return to this window"
Pause
Write-Host "Installing JaxCore..."
Start-Process PowerShell -Wait -NoNewWindow -ArgumentList "-ExecutionPolicy", "Bypass", "-NoExit", "-Command", "iwr -useb $urlJAX | iex"
Pause

#   Check for Rainmeter
$RainmeterReg = "HKLM:\SOFTWARE\WOW6432Node\Rainmeter"
if (!(Test-Path $RainmeterReg)) { return }
$RainmeterPath = Join-Path ((Get-ItemProperty $RainmeterReg).'(default)') "Rainmeter.exe"
if (!(Test-Path $RainmeterPath)) { return }

#   Add JaxCore to Start Menu
$Shortcut = (New-Object -comObject WScript.Shell).CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\JaxCore.lnk")
$Shortcut.TargetPath = "$RainmeterPath"
$Shortcut.Arguments = "[!DeactivateConfig #JaxCore\Main][!ActivateConfig #JaxCore\Main Home.ini]"
$Shortcut.IconLocation = "%APPDATA%\JaxCore\InstalledComponents\#JaxCore\@Resources\Images\Logo.ico"
$Shortcut.Description = "Launch JaxCore"
$Shortcut.Save()

#   Activate Flyouts
$file = "$env:APPDATA\Rainmeter\Rainmeter.ini"
$text = Get-Content $file;
$line = ($text | Select-String 'flyouts').LineNumber
$text[$line] = $text[$line] -replace '(active=).*','${1}1'
$text | Set-Content $file

#   Set Layout
$ini = "$env:APPDATA\JaxCore\InstalledComponents\YourFlyouts\@Resources\Vars.inc"
$text = Get-Content $ini
$text = $text -replace '(Media=).*','${1}0'
$text = $text -replace '(Ani=).*','${1}1'
$text = $text -replace '(AniDir=).*','${1}Bottom'
$text = $text -replace '(AniSteps=).*','${1}18'
$text = $text -replace '(Easetype=).*','${1}InOutCubic'
$text = $text -replace '(AnimationDisplacement=).*','${1}3'
$text = $text -replace '(Position=).*','${1}BC'
$text = $text -replace '(XPad=).*','${1}0'
$text = $text -replace '(YPad=).*','${1}44'
$text = $text -replace '(MediaType=).*','${1}Modern'
$text = $text -replace '(FetchImage=).*','${1}0'
$text = $text -replace '(Layout=).*','${1}Win11'
$text | Set-Content $ini

. $RainmeterPath !RefreshApp

Pause
exit