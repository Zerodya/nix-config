import "root:/widgets"
import "root:/services"
import "root:/utils"
import "root:/config"
import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property int index
    required property var occupied
    required property int groupOffset

    readonly property bool isWorkspace: true
    readonly property int ws: groupOffset + index + 1
    readonly property bool isOccupied: occupied[ws] ?? false

    // Pills height
    readonly property real targetHeight: {
        if (Hyprland.activeWsId === root.ws)
            return BarConfig.sizes.innerHeight * 3.8; // Active workspace (taller)
        else if (root.isOccupied)
            return BarConfig.sizes.innerHeight * 2.6; // Used workspace
        else
            return BarConfig.sizes.innerHeight * 1.3; // Unused workspace
    }

    Layout.preferredWidth: childrenRect.width
    Layout.preferredHeight: targetHeight

    Rectangle {
        id: pill

        width: BarConfig.sizes.innerHeight * 0.23 // Skinnier width
        height: root.targetHeight
        radius: width / 2

        color: {
            if (Hyprland.activeWsId === root.ws)
                return Colours.palette.m3primary;
            else
                return Colours.palette.m3surfaceVariant;
        }

        Behavior on height {
            Anim {}
        }
    }

    Behavior on Layout.preferredHeight {
        Anim {}
    }

    Behavior on Layout.preferredWidth {
        Anim {}
    }

    component Anim: NumberAnimation {
        duration: Appearance.anim.durations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.anim.curves.standard
    }
}
