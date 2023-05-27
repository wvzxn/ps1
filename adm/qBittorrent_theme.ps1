param($theme)

$qBTReg = "HKLM:\SOFTWARE\WOW6432Node\qBittorrent"
if (!(Test-Path $qBTReg)) { return }

$qBTPath = Join-Path ((Get-ItemProperty $qBTReg).'Installlocation') "qbittorrent.exe"
if (!(Test-Path $qBTPath)) { return }

$ini = "$env:APPDATA\qBittorrent\qBittorrent.ini"
$useTheme = if ($theme -eq "Dark") { "true" } else { "false" }

$process = Get-Process "qbittorrent" -ErrorAction SilentlyContinue
if ($process)
{
    [void]$process.CloseMainWindow()
    for ($i = 0; ($i -lt 60) -and (!$process.HasExited); $i++) { Start-Sleep 1 }
    $restart = $true
}

(Get-Content $ini) -replace "(General\\UseCustomUITheme=).*","`${1}$useTheme" | Set-Content "$ini"
if ($restart) { Start-Process $qBTPath }