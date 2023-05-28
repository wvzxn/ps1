param ([string]$Theme)

function RestartExplorer
{
    $openTabs = (New-Object -ComObject 'Shell.Application').Windows() | ForEach-Object { ($_.Document.Folder.Self.Path) }
    taskkill.exe /f /im explorer.exe
    Start-Sleep 1
    Start-Process explorer.exe
    $openTabs | ForEach-Object { Start-Process explorer.exe $_ -WindowStyle Minimized }
}

Get-ChildItem ".\#ps1\*.ps1" | ForEach-Object { . "$($_.fullname)" $Theme }

RestartExplorer

exit

<#
Enabled: true
Component:
  Scripts:
  - Name: ps1
    Command: powershell
    WorkingDirectory: %APPDATA%\AutoDarkMode
    ArgsLight: [-ExecutionPolicy, Bypass, -File, .\#script.ps1, Light]
    ArgsDark: [-ExecutionPolicy, Bypass, -File, .\#script.ps1, Dark]
    AllowedSources: [Any]

Any
TimeSwitchModule
NightLightTrackerModule
BatteryStatusChanged
SystemResume
Manual
ExternalThemeSwitch
Startup
SystemUnlock
Api

Any - permits all sources (default)
TimeSwitchModule - permits script to run if the source is a timed switch (at sunrise/sunset)
NightLightTrackerModule - permits script to run if the source is windows night light
BatteryStatusChanged - permits script to run if the source was a battery charge state event
SystemResume - permits script to run if the source was a system resume event (wakeup from sleep)
Manual - permits script to run if the source was a manual user-invoked event (hotkeys, notifications, in the UI, via shell on --switch)
ExternalThemeSwitch - permits script to run if the source is an external switch not invoked by ADM
Startup - permits script to run if the source is the first switch when ADM starts up
SystemUnlock - permit script to run if the source is a system unlock event
Api - permit script to run if the source is a theme swap, force or explicit theme set (light or dark) via the shell
#>