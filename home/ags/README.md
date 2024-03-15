My AGS configuration, forked from [chadcat7](https://github.com/chadcat7/crystal/tree/freosan). 

Includes status bar, app launcher, notifications, and other widgets.

Dependencies: 
- `sassc` to convert `style/_style.scss` to `finalcss/style.css`
- `inotifywait` for notifications
- `papirus-icon-theme` for launcher icons
- `matugen` generates colors (not working rn)
- `services.upower` for battery support

TO FIX:
- Notifications popups not working
- Show battery only in laptop (done? test...)
- Matugen colors based on wallpaper

TODO:
- Add media control in bar
- Highlight top/selected app in Launcher