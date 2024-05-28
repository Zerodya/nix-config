import App from 'resource:///com/github/Aylur/ags/app.js'
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'

import { bar } from "./widgets/bar/Bar.js"
import { launcher } from './widgets/launcher/Launcher.js'
import { panel } from "./widgets/panel/Panel.js"

import { calendarbox } from "./widgets/calendar/Calendar.js"
import { osd } from './widgets/popups/Osd.js'

import { wifimenu } from './widgets/popups/Wifi.js'
import { bluetoothmenu } from './widgets/popups/Bluetooth.js'

import { notif } from './widgets/popups/Notifications.js'

let loadCSS = () => {
  // generate _colors.scss from stylix
  Utils.exec(`bash ${App.configDir}/generate_color_scss.sh`, () => {
    const scss = `${App.configDir}/style/_style.scss`
    const css = `${App.configDir}/finalcss/style.css`
    Utils.exec(`sassc ${scss} ${css}`)
    App.resetCss() // reset if need
    App.applyCss(`${css}`)
  })
}

loadCSS()

Utils.monitorFile(
  `${App.configDir}/style/`,
  function() {
    loadCSS()
  }
)

App.config({
  windows: [bar, launcher, panel, calendarbox, osd, wifimenu, bluetoothmenu, notif],
  style: `${App.configDir}/finalcss/style.css`
})
