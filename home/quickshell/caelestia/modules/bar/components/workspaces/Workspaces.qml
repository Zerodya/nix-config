pragma ComponentBehavior: Bound

import "root:/widgets"
import "root:/services"
import "root:/config"
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    readonly property list<Workspace> workspaces: layout.children.filter(c => c.isWorkspace).sort((w1, w2) => w1.ws - w2.ws)
    readonly property var occupied: Hyprland.workspaces.values.reduce((acc, curr) => {
        acc[curr.id] = curr.lastIpcObject.windows > 0;
        return acc;
    }, {})
    readonly property int groupOffset: Math.floor((Hyprland.activeWsId - 1) / BarConfig.workspaces.shown) * BarConfig.workspaces.shown

    // Single pill width definition
    readonly property real pillWidth: BarConfig.sizes.innerHeight * 0.23
    // Padding proportional to pill width
    readonly property real sidePadding: pillWidth * 0.3

    implicitWidth: layout.implicitWidth + 2 * sidePadding
    implicitHeight: layout.implicitHeight

    // Main container for vertical pills
    ColumnLayout {
        id: layout

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            leftMargin: sidePadding
            rightMargin: sidePadding
        }

        // Add spacing between pills
        spacing: 8
        layer.enabled: true
        layer.smooth: true

        Repeater {
            model: BarConfig.workspaces.shown

            Workspace {
                occupied: root.occupied
                groupOffset: root.groupOffset
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        onPressed: event => {
            const ws = layout.childAt(event.x, event.y).index + root.groupOffset + 1;
            if (Hyprland.activeWsId !== ws)
                Hyprland.dispatch(`workspace ${ws}`);
        }
    }
}
