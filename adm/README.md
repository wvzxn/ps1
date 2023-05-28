# Theme changing scripts collection

### YourFlyouts2

[**`Link`**](https://raw.githubusercontent.com/wvzxn/ps1/master/adm/jax_w11.ps1)

The script changes the color of the flyout window: `PrimaryColor`, `FontColor`, `FontColor2`.

### qBittorrent

[**`Link`**](https://raw.githubusercontent.com/wvzxn/ps1/master/adm/qBittorrent_theme.ps1)

**Setup**
1. Download any dark theme and put somewhere
2. Open qBittorrent Settings
3. Select _custom UI Theme_
4. Disable _qBittorrent in notification area_

___

## About `#script.ps1`

Executes all files in the `.\#ps1\` folder.

### Best way:
- **AutoDarkMode**
- **#script.ps1**
- **Scripts in `#ps1` folder**

### ADM and JaxCore (YourFlyouts2) automatic installation:

```powershell
. $([scriptblock]::Create((iwr -useb 'https://raw.githubusercontent.com/wvzxn/ps1/master/adm/%23script_installer.ps1')))
```
