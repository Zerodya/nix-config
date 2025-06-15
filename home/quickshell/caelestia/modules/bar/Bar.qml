import "root:/widgets"
import "root:/services"
import "root:/config"
import "root:/modules/bar/popouts" as BarPopouts
import "components"
import "components/workspaces"
import Quickshell
import QtQuick

Item {
    id: root

    required property ShellScreen screen
    required property BarPopouts.Wrapper popouts

    function checkPopout(y: real): void {
        const spacing = Appearance.spacing.small;

        const ty = tray.y;
        const th = tray.implicitHeight;
        const trayItems = tray.items;

        const n = statusIconsInner.network;
        const ny = statusIcons.y + statusIconsInner.y + n.y - spacing / 2;

        const bls = statusIcons.y + statusIconsInner.y + statusIconsInner.bs - spacing / 2;
        const ble = statusIcons.y + statusIconsInner.y + statusIconsInner.be + spacing / 2;

        const b = statusIconsInner.battery;
        const by = statusIcons.y + statusIconsInner.y + b.y - spacing / 2;

        if (y > ty && y < ty + th) {
            const index = Math.floor(((y - ty) / th) * trayItems.count);
            const item = trayItems.itemAt(index);

            popouts.currentName = `traymenu${index}`;
            popouts.currentCenter = Qt.binding(() => tray.y + item.y + item.implicitHeight / 2);
            popouts.hasCurrent = true;
        } else if (y >= ny && y <= ny + n.implicitHeight + spacing) {
            popouts.currentName = "network";
            popouts.currentCenter = Qt.binding(() => statusIcons.y + statusIconsInner.y + n.y + n.implicitHeight / 2);
            popouts.hasCurrent = true;
        } else if (y >= bls && y <= ble) {
            popouts.currentName = "bluetooth";
            popouts.currentCenter = Qt.binding(() => statusIcons.y + statusIconsInner.y + statusIconsInner.bs + (statusIconsInner.be - statusIconsInner.bs) / 2);
            popouts.hasCurrent = true;
        } else if (y >= by && y <= by + b.implicitHeight + spacing) {
            popouts.currentName = "battery";
            popouts.currentCenter = Qt.binding(() => statusIcons.y + statusIconsInner.y + b.y + b.implicitHeight / 2);
            popouts.hasCurrent = true;
        } else {
            popouts.hasCurrent = false;
        }
    }

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left

    implicitWidth: child.implicitWidth + BorderConfig.thickness * 2

    Item {
        id: child

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        implicitWidth: Math.max(osIcon.implicitWidth, workspaces.implicitWidth, tray.implicitWidth, clock.implicitWidth, statusIcons.implicitWidth, power.implicitWidth)

        OsIcon {
            id: osIcon

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: Appearance.padding.large
        }

        StyledRect {
            id: workspaces

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: osIcon.bottom
            anchors.topMargin: Appearance.spacing.normal

            radius: Appearance.rounding.full
            color: Colours.palette.m3surfaceContainer

            implicitWidth: workspacesInner.implicitWidth + Appearance.padding.small * 2
            implicitHeight: workspacesInner.implicitHeight + Appearance.padding.small * 2

            MouseArea {
                anchors.fill: parent
                anchors.leftMargin: -BorderConfig.thickness
                anchors.rightMargin: -BorderConfig.thickness

                onWheel: event => {
                    const activeWs = Hyprland.activeClient?.workspace?.name;
                    const maxWorkspaces = 6;
                    
                    if (activeWs?.startsWith("special:")) {
                        Hyprland.dispatch(`togglespecialworkspace ${activeWs.slice(8)}`);
                    } else if (event.angleDelta.y > 0 && Hyprland.activeWsId > 1) {
                        // Scroll up: move to previous workspace
                        Hyprland.dispatch("workspace r-1");
                    } else if (event.angleDelta.y < 0 && Hyprland.activeWsId < maxWorkspaces) {
                        // Scroll down: move to next workspace only if not at max
                        Hyprland.dispatch("workspace r+1");
                    }
                }
            }

            Workspaces {
                id: workspacesInner

                anchors.centerIn: parent
            }
        }


        Tray {
            id: tray

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: statusIcons.top
            anchors.bottomMargin: Appearance.spacing.larger
        }

        StyledRect {
            id: statusIcons

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: clock.top
            anchors.bottomMargin: Appearance.spacing.normal

            radius: Appearance.rounding.full
            color: Colours.palette.m3surfaceContainer

            implicitHeight: statusIconsInner.implicitHeight + Appearance.padding.normal * 2

            StatusIcons {
                id: statusIconsInner

                anchors.centerIn: parent
            }
        }

        Clock {
            id: clock

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: power.top
            anchors.bottomMargin: Appearance.spacing.normal
        }

        Power {
            id: power

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Appearance.padding.large
        }
    }
}
