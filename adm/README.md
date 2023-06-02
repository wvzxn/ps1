# Theme changing scripts collection

### YourFlyouts2

[**`Link`**](https://github.com/wvzxn/ps1/raw/master/adm/jaxcore_yf2_w11.ps1)

1. Install _JaxCore_
2. Install and Enable _YourFlyouts2_

### qBittorrent

[**`Link`**](https://github.com/wvzxn/ps1/raw/master/adm/qBittorrent.ps1)

1. Download any dark theme and put somewhere
2. Open qBittorrent Settings
3. Select _custom UI Theme_
4. Uncheck _Show qBittorrent in notification area_

___

## About `#script_loader.ps1`

Executes all files in `.\#scripts\`, except those that start with `#`.

### AutoDarkMode scripts automatic installation:

```powershell
. $([scriptblock]::Create((iwr -useb 'https://github.com/wvzxn/ps1/raw/master/adm/%23script_loader_installer.ps1')))
```
