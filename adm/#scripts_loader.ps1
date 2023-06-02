#  #scripts_loader (PowerShell)
#  
#  [Author]
#    wvzxn | https://github.com/wvzxn

param ([string]$Theme)

function RestartExplorer
{
    $openTabs = (New-Object -ComObject 'Shell.Application').Windows() | ForEach-Object { ($_.Document.Folder.Self.Path) }
    taskkill.exe /f /im explorer.exe
    Start-Sleep 1
    Start-Process explorer.exe
    $openTabs | ForEach-Object { Start-Process explorer.exe $_ -WindowStyle Minimized }
}

$scripts = Get-ChildItem ".\#scripts\*.ps1" | Where-Object {$_.name -notmatch '^\#.*$'}
foreach ($script in $scripts) { . "$($script.fullname)" $Theme }

RestartExplorer

return