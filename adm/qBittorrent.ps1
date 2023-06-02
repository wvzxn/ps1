#  qBittorrent Theme Change (PowerShell)
#  
#  [Author]
#    wvzxn | https://github.com/wvzxn
#  
#  [Credits]
#    qBittorrent | https://github.com/qbittorrent/qBittorrent
#  
#  [Description]
#    1. Download any dark theme and put somewhere
#    2. Open qBittorrent Settings
#    3. Select custom UI Theme
#    4. Uncheck "Show qBittorrent in notification area"
#    
#    Pass one of these parameters: "Light" or "Dark".
#    Example (PS): . '.\qBittorrent_theme.ps1' Light; . '.\qBittorrent_theme.ps1' "Dark"

param($theme)

$qBTReg = "HKLM:\SOFTWARE\WOW6432Node\qBittorrent"
if (!(Test-Path $qBTReg)) { return }
$qBTPath = Join-Path ((Get-ItemProperty $qBTReg).'Installlocation') "qbittorrent.exe"
if (!(Test-Path $qBTPath)) { return }

$ini = "$env:APPDATA\qBittorrent\qBittorrent.ini"
$useTheme = if ($theme -eq "Light") { "false" } else { "true" }

$process = Get-Process "qbittorrent" -ErrorAction SilentlyContinue
if ($process)
{
    [void]$process.CloseMainWindow()
    for ($i = 0; ($i -lt 60) -and (!$process.HasExited); $i++) { Start-Sleep 1 }
    $restart = $true
}

(Get-Content $ini) -replace "(General\\UseCustomUITheme=).*","`${1}$useTheme" | Set-Content "$ini"
if ($restart) { Start-Process $qBTPath }