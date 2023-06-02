#  JaxCore YourFlyouts2 Win11 Color Change (PowerShell)
#  
#  [Author]
#    wvzxn | https://github.com/wvzxn
#  
#  [Credits]
#    Jax-Core | https://github.com/Jax-Core/JaxCore
#  
#  [Description]
#    1. Install JaxCore
#    2. Install and Enable YourFlyouts2
#    
#    Pass one of these parameters: "Light" or "Dark".
#    Example (PS): . '.\jaxcore_yf2_w11.ps1' Light; . '.\jaxcore_yf2_w11.ps1' "Dark"

param($theme)

#   Rainmeter and YourFlyouts2 check
$RainmeterReg = "HKLM:\SOFTWARE\WOW6432Node\Rainmeter"
if (!(Test-Path $RainmeterReg)) { return }
$RainmeterPath = Join-Path ((Get-ItemProperty $RainmeterReg).'(default)') "Rainmeter.exe"
if (!(Test-Path $RainmeterPath)) { return }
$YourFlyoutsPath = Join-Path $env:APPDATA "JaxCore\InstalledComponents\YourFlyouts"
if (!(Test-Path $YourFlyoutsPath)) { return }

<#
#   Add JaxCore Shortcut to Start Menu
$JaxCoreShortcutPath = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\JaxCore.lnk"
if (!(Test-Path $JaxCoreShortcutPath))
{
    $Shortcut = (New-Object -comObject WScript.Shell).CreateShortcut($JaxCoreShortcutPath)
    $Shortcut.TargetPath = $RainmeterPath
    $Shortcut.Arguments = "[!DeactivateConfig #JaxCore\Main][!ActivateConfig #JaxCore\Main Home.ini]"
    $Shortcut.IconLocation = Join-Path $env:APPDATA "JaxCore\InstalledComponents\#JaxCore\@Resources\Images\Logo.ico"
    $Shortcut.Description = "Launch JaxCore"
    $Shortcut.Save()
}
#>

#   Set Flyouts General Layout
$YourFlyoutsVars = Join-Path $YourFlyoutsPath "@Resources\Vars.inc"
if (Test-Path $YourFlyoutsVars)
{
    $text = Get-Content $YourFlyoutsVars
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
    $text | Set-Content $YourFlyoutsVars
}

#   Set Flyouts Win11 skin appearance
$YourFlyoutsInc = Join-Path $YourFlyoutsPath "Main\Vars\WIn11.inc"
if (Test-Path $YourFlyoutsInc)
{
    $text = Get-Content $YourFlyoutsInc

    $Primary = if ($theme -eq "Light") { "230,225,235" } else { "40,35,42" }
    $Font = if ($theme -eq "Light") { "0,0,0" } else { "255,255,255" }
    $Font2 = if ($theme -eq "Light") { "150,150,150" } else { "125,125,125" }
    
    $text = $text -replace '(PrimaryColor=).*',"`${1}$Primary"
    $text = $text -replace '(FontColor=).*',"`${1}$Font"
    $text = $text -replace '(FontColor2=).*',"`${1}$Font2"
    $text = $text -replace '(PrimaryOpacity=).*','${1}253'
    $text = $text -replace '(Width=).*','${1}246'
    $text = $text -replace '(Scale=).*','${1}1.05'
    $text = $text -replace '(Blur=).*','${1}None'
    $text = $text -replace '(BlurCorner=).*','${1}Round'
    $text = $text -replace '(Border=).*','${1}1'
    
    $text | Set-Content $YourFlyoutsInc
}

#   Rainmeter: Refresh All
. $RainmeterPath !RefreshApp