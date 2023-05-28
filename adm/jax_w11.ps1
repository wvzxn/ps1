param($theme)
$RainmeterReg = "HKLM:\SOFTWARE\WOW6432Node\Rainmeter"
if (!(Test-Path $RainmeterReg)) { return }

$RainmeterPath = Join-Path ((Get-ItemProperty $RainmeterReg).'(default)') "Rainmeter.exe"
if (!(Test-Path $RainmeterPath)) { return }

$ini = "$env:APPDATA\JaxCore\InstalledComponents\YourFlyouts\Main\Vars\WIn11.inc"
$text = Get-Content $ini

$Primary = if ($theme -eq "Dark") { "40,35,42" } else { "230,225,235" }
$Font = if ($theme -eq "Dark") { "255,255,255" } else { "0,0,0" }
$Font2 = if ($theme -eq "Dark") { "125,125,125" } else { "150,150,150" }

$text = $text -replace '(PrimaryColor=).*',"`${1}$Primary"
$text = $text -replace '(FontColor=).*',"`${1}$Font"
$text = $text -replace '(FontColor2=).*',"`${1}$Font2"
$text | Set-Content $ini

. $RainmeterPath !RefreshApp