#  ADM #script_installer (PowerShell)
#  
#  [Author]
#    wvzxn | https://github.com/wvzxn/
#  
#  [Credits]
#    Jax-Core     | https://github.com/Jax-Core/JaxCore
#    AutoDarkMode | https://github.com/AutoDarkMode/Windows-Auto-Night-Mode
#  
#  [Description]
#    The script installs and configures ADM, JaxCore for comfortable use of Windows themes.

$urlADM = "https://github.com/AutoDarkMode/AutoDarkModeVersion/releases/download/10.4_migration/AutoDarkModeX_Setup_10.4_BETA_migration_installer.exe"
$urlPS1 = "https://raw.githubusercontent.com/wvzxn/ps1/master/adm/%23script.ps1"
$urlPS1jax = "https://raw.githubusercontent.com/wvzxn/ps1/master/adm/jax_w11.ps1"
$urlJAX = "https://raw.githubusercontent.com/Jax-Core/JaxCore/master/CoreInstaller.ps1"

function ADMinstall
{
    Write-Host -for Green "#    Downloading AutoDarkMode..."
    (New-Object System.Net.WebClient).DownloadFile($urlADM, "$env:TMP\adm_10.4b.exe")
    Write-Host -for Green "#    Installing AutoDarkMode..."
    Start-Process "$env:TMP\adm_10.4b.exe" -Wait -ArgumentList "/VERYSILENT"
}

function ADMscripts
{
    Write-Host -for Green "#    Installing AutoDarkMode scripts..."

    if (!(Test-Path "$env:APPDATA\AutoDarkMode\ps1")) { mkdir "$env:APPDATA\AutoDarkMode\ps1" | Out-Null }
    (New-Object System.Net.WebClient).DownloadFile($urlPS1, "$env:APPDATA\AutoDarkMode\#script.ps1")
    (New-Object System.Net.WebClient).DownloadFile($urlPS1jax, "$env:APPDATA\AutoDarkMode\ps1\jax_w11.ps1")
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
}

function JaxCoreInstall
{
    Write-Host -for Green "#    Installing JaxCore..."
    Start-Process PowerShell -ArgumentList "-ExecutionPolicy", "Bypass", "-NoExit", "-Command", "iwr -useb $urlJAX | iex"    
}

function JaxCoreSet
{
    Write-Host -for Green "#    Setting up JaxCore W11..."

    #   Check for Rainmeter
    $RainmeterReg = "HKLM:\SOFTWARE\WOW6432Node\Rainmeter"
    if (!(Test-Path $RainmeterReg)) { return }
    $RainmeterPath = Join-Path ((Get-ItemProperty $RainmeterReg).'(default)') "Rainmeter.exe"
    if (!(Test-Path $RainmeterPath)) { return }

    #   Add JaxCore to Start Menu
    if (!(Test-Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\JaxCore.lnk"))
    {
        $Shortcut = (New-Object -comObject WScript.Shell).CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\JaxCore.lnk")
        $Shortcut.TargetPath = "$RainmeterPath"
        $Shortcut.Arguments = "[!DeactivateConfig #JaxCore\Main][!ActivateConfig #JaxCore\Main Home.ini]"
        $Shortcut.IconLocation = "%APPDATA%\JaxCore\InstalledComponents\#JaxCore\@Resources\Images\Logo.ico"
        $Shortcut.Description = "Launch JaxCore"
        $Shortcut.Save()
    }

    #   Activate Flyouts
    $file = "$env:APPDATA\Rainmeter\Rainmeter.ini"
    $text = Get-Content $file;
    $line = ($text | Select-String 'flyouts').LineNumber
    if ($line)
    {
        $text[$line] = $text[$line] -replace '(active=).*','${1}1'
        $text | Set-Content $file
    }

    #   Set Layout
    $ini = "$env:APPDATA\JaxCore\InstalledComponents\YourFlyouts\@Resources\Vars.inc"
    if (Test-Path $ini)
    {
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
    }

    . $RainmeterPath !RefreshApp
}

do {
    Clear-Host
    Write-Host -for Green "#    1. Install AutoDarkMode"
    Write-Host -for Green "#    2. Install AutoDarkMode scripts"
    Write-Host -for Green "#    3. Install JaxCore"
    Write-Host -for Green "#    4. JaxCore configuration"
    $kkk = [Console]::ReadKey($true)
    switch ($kkk)
    {
        "D1" { ADMinstall; Pause }
        "D2" { ADMscripts; Pause }
        "D3" { JaxCoreInstall; Pause }
        "D4" { JaxCoreSet; Pause }
    }
} until ($kkk -eq "Q")