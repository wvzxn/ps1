#  ADM #scripts_loader installer (PowerShell)
#  
#  [Author]
#    wvzxn | https://github.com/wvzxn
#  
#  [Credits]
#    AutoDarkMode | https://github.com/AutoDarkMode/Windows-Auto-Night-Mode

$urlADM = "https://github.com/AutoDarkMode/AutoDarkModeVersion/releases/download/10.4_migration/AutoDarkModeX_Setup_10.4_BETA_migration_installer.exe"
$urlPS1 = "https://github.com/wvzxn/ps1/raw/master/adm/%23script_loader.ps1"
$urlRepoZip = "https://github.com/wvzxn/ps1/archive/refs/heads/master.zip"
$urlExtract = "https://gist.githubusercontent.com/wvzxn/8f326deb99c3267ecf741a21fa73becb/raw/ebb82b5257d49f4e35869ff513aa6412a375ed81/ExtractArchive.ps1"

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
        "  - Name: script_loader",
        "    Command: powershell",
        "    WorkingDirectory: $ADMData",
        "    ArgsLight: [-ExecutionPolicy, Bypass, -File, .\#script_loader.ps1, Light]",
        "    ArgsDark: [-ExecutionPolicy, Bypass, -File, .\#script_loader.ps1, Dark]",
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
    Invoke-WebRequest -useb "$urlExtract" | Invoke-Expression
    Invoke-WebRequest $urlRepoZip -OutFile "$ADMData\ps1-master.zip"
    ExtractArchive "$ADMData\ps1-master.zip"
    $files = Get-ChildItem "$ADMData\ps1-master\adm" -File | Where-Object { $_.name -match '^(?!\#).*\.ps1$' }
    Copy-Item $files "$ADMData\#scripts"
    "$ADMData\ps1-master", "$ADMData\ps1-master.zip" | Remove-Item -Recurse -Force
    Write-Host -for Green " Done"
}

return