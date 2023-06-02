#  ADM #scripts_loader installer (PowerShell)
#  
#  [Author]
#    wvzxn | https://github.com/wvzxn
#  
#  [Credits]
#    AutoDarkMode | https://github.com/AutoDarkMode/Windows-Auto-Night-Mode

$urlADM = "https://github.com/AutoDarkMode/AutoDarkModeVersion/releases/download/10.4_migration/AutoDarkModeX_Setup_10.4_BETA_migration_installer.exe"
$urlPS1 = "https://raw.githubusercontent.com/wvzxn/ps1/master/adm/%23script.ps1"

$ADMExe = Join-Path $env:LOCALAPPDATA "Programs\AutoDarkMode\adm-app\AutoDarkModeSvc.exe"
$ADMData = Join-Path $env:APPDATA "AutoDarkMode"

#   ADM Install
if (!(Test-Path $ADMExe))
{
    Write-Host -NoNewline " = Installing Auto Dark Mode..."
    (New-Object System.Net.WebClient).DownloadFile($urlADM, "$env:TMP\adm_10.4b.exe")
    Start-Process "$env:TMP\adm_10.4b.exe" -Wait -ArgumentList "/VERYSILENT"
    Remove-Item "$env:TMP\adm_10.4b.exe"
    Start-Process $ADMExe; Start-Sleep 2
    Write-Host -for Green " Done"
}

#   #scripts_loader Setup
if (!(Test-Path "$ADMData\#scripts_loader.ps1"))
{
    if (!(Test-Path "$ADMData\#scripts")) { mkdir "$ADMData\#scripts" | Out-Null }
    (New-Object System.Net.WebClient).DownloadFile($urlPS1, "$ADMData\#scripts_loader.ps1")
    @(
        "Enabled: true",
        "Component:",
        "  Scripts:",
        "  - Name: ps1",
        "    Command: powershell",
        "    WorkingDirectory: $ADMData",
        "    ArgsLight: [-ExecutionPolicy, Bypass, -File, .\#script.ps1, Light]",
        "    ArgsDark: [-ExecutionPolicy, Bypass, -File, .\#script.ps1, Dark]",
        "    AllowedSources: [Any]",
        ""
    ) | Set-Content "$ADMData\scripts.yaml"
}

return