import Widget from 'resource:///com/github/Aylur/ags/widget.js';

import Buttons from "./mods/Buttons.js"
import Sliders from "./mods/Sliders.js"
import Profile from "./mods/Profile.js"
import NotificationCenter from "./mods/NotificationCenter.js"

const Box = Widget.Box({
  spacing: 20,
  class_name: "panel",
  homogeneous: false,
  vertical: true,
  children: [Profile(), Buttons(), Sliders(), NotificationCenter()]
})

const panel = Widget.Window({
  name: 'panel',
  visible: false,
  popup: true,
  keymode: "exclusive",
  anchor: ['top', 'right', 'bottom'],
  margins: [0, 0],
  child: Box,
})

export { panel }

