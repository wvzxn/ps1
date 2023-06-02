#  ADM #scripts_loader installer (PowerShell)
#  
#  [Author]
#    wvzxn | https://github.com/wvzxn
#  
#  [Credits]
#    AutoDarkMode | https://github.com/AutoDarkMode/Windows-Auto-Night-Mode

#Requires -Version 5

$urlADM = "https://github.com/AutoDarkMode/AutoDarkModeVersion/releases/download/10.4_migration/AutoDarkModeX_Setup_10.4_RC2_migration_installer.exe"
$urlPS1 = "https://github.com/wvzxn/ps1/raw/master/adm/%23script_loader.ps1"
$urlRepoZip = "https://github.com/wvzxn/ps1/archive/refs/heads/master.zip"

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
    Write-Host -NoNewline " = Installing ADM scripts_loader..."
    if (!(Test-Path "$ADMData\#scripts")) { mkdir "$ADMData\#scripts" | Out-Null }
    Invoke-WebRequest $urlPS1 -OutFile "$ADMData\#scripts_loader.ps1"
    @(
        "Enabled: true",
        "Component:",
        "  Scripts:",
        "  - Name: scripts_loader",
        "    Command: powershell",
        "    WorkingDirectory: $ADMData",
        "    ArgsLight: [-ExecutionPolicy, Bypass, -File, .\#scripts_loader.ps1, Light]",
        "    ArgsDark: [-ExecutionPolicy, Bypass, -File, .\#scripts_loader.ps1, Dark]",
        "    AllowedSources: [Any]",
        ""
    ) | Set-Content "$ADMData\scripts.yaml"
    Write-Host -for Green " Done"
}

#   #scripts Download
Write-Host "Press [Y] to Download ADM scripts"
if (([Console]::ReadKey($true).Key) -eq "Y")
{
    Write-Host -NoNewline " = Downloading ADM scripts..."
    if (!(Test-Path "$ADMData\#scripts")) { mkdir "$ADMData\#scripts" | Out-Null }
    Invoke-WebRequest $urlRepoZip -OutFile "$ADMData\ps1-master.zip"
    Expand-Archive "$ADMData\ps1-master.zip" $ADMData -Force
    $files = Get-ChildItem "$ADMData\ps1-master\adm" -File | Where-Object { $_.Name -match '^(?!\#).*\.ps1$' }
    foreach ($file in $files)
    {
        if (Test-Path "$ADMData\#scripts\$($file.Name)") { continue }
        Copy-Item ($file.FullName) -Destination "$ADMData\#scripts\$($file.Name)"
    }
    "$ADMData\ps1-master", "$ADMData\ps1-master.zip" | Remove-Item -Recurse -Force
    Write-Host -for Green " Done"
}

return