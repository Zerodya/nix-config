import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import App from 'resource:///com/github/Aylur/ags/app.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
const { GLib } = imports.gi

const SettingButton = (label, setup, on_clicked, on_secondary_click = () => { }) => Widget.Button({
  class_name: "panel-button",
  label: label,
  on_clicked: on_clicked,
  on_secondary_click: on_secondary_click,
  hpack: "center",
  vpack: "center",
  setup: setup
})

export default () => Widget.Box({
  spacing: 10,
  class_name: "panel-buttons",
  homogeneous: true,
  vertical: false,
  children: [
    SettingButton("󰤨", (self) => {
      self.hook(Network, self => {
        if (Network.wifi.internet == "connected") {
          self.class_name = "panel-buttonactive"
        } else {
          self.class_name = "panel-button"
        }
      })
    }, () => {
      Network.toggleWifi()
    }, () => {
      App.toggleWindow("wifimenu")
    }),

    SettingButton("󰂯", (self) => {
      self.hook(Bluetooth, self => {
        if (Bluetooth.connected) {
          self.class_name = "panel-buttonactive"
        } else {
          self.class_name = "panel-button"
        }
      })
    }, () => {
      Bluetooth.toggle()
    }, () => {
      App.toggleWindow("bluetoothmenu")
    }),

    SettingButton("󰍶", (self) => {
      self.hook(Notifications, self => {
        if (Notifications.dnd) {
          self.class_name = "panel-buttonactive"
        } else {
          self.class_name = "panel-button"
        }
      })
    }, () => {
      Notifications.dnd = !Notifications.dnd
    }),

    SettingButton("󰍬", (self) => {
      self.hook(Audio, self => {
        if (!Audio.microphone?.is_muted) {
          self.class_name = "panel-buttonactive"
        } else {
          self.class_name = "panel-button"
        }
      })
    }, () => {
      Audio.microphone.is_muted = !Audio.microphone?.is_muted
    }),

    SettingButton("󰆟", () => {
    }, () => {
      let date = new Date().toJSON();
      App.toggleWindow("panel")
      Utils.execAsync(`sh -c 'hyprshot -m region --clipboard-only' `)
    }, () => {
      let date = new Date().toJSON();
      App.toggleWindow("panel")
      Utils.execAsync(`sh -c 'hyprshot -m region --clipboard-only' `)
    }),

    SettingButton("󰖺", () => {
    }, () => {
      let date = new Date().toJSON();
      App.toggleWindow("panel")
      Utils.execAsync(`sh -c '${App.configDir}/scripts/gamemode.sh'`)
    }, () => {
      let date = new Date().toJSON();
      App.toggleWindow("panel")
      Utils.execAsync(`sh -c '${App.configDir}/scripts/gamemode.sh'`)
    }),
  ]
})

