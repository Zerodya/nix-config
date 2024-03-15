import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import { range } from "../../../utils.js"
const hyprland = await Service.import('hyprland');

// Define the maximum number of workspaces
const maxWorkspaces = 6; 

const dispatch = (arg) => hyprland.messageAsync(`dispatch workspace ${arg}`);

export default () => Widget.EventBox({
  // Stop when reaching the last workspace defined above
  onScrollDown: () => (hyprland.active.workspace.id < maxWorkspaces) ? dispatch('+1') : null,
  onScrollUp: () => dispatch('-1'),
  child: Widget.Box({
    class_name: 'bar-ws',
    vertical: true,
    children: Array.from({ length: maxWorkspaces }, (_, i) =>
        Widget.Button({
            setup: (btn) => {
                btn.id = i + 1; // Workspace IDs start from 1 in Hyprland
                btn.hook(hyprland, () => {
                    const ws = hyprland.workspaces.find(ws => ws.id === btn.id);
                    if (ws) {
                        btn.class_names = [...btn.class_names.filter(cn => cn !== 'bar-ws-empty'), 'bar-ws-occupied'];
                    } else {
                        btn.class_names = [...btn.class_names.filter(cn => cn !== 'bar-ws-occupied'), 'bar-ws-empty'];
                    }
                });
                btn.hook(hyprland.active.workspace, () => {
                    btn.toggleClassName('bar-ws-active', hyprland.active.workspace.id === btn.id);
                });
            },
            on_clicked: () => dispatch(i + 1),
            child: Widget.Label({
                label: ``,
                class_name: 'bar-ws-indicator',
                vpack: 'center',
            }),
        })
    ),
  })
});
