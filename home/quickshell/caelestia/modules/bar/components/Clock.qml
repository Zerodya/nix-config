import "root:/widgets"
import "root:/services"
import "root:/config"
import QtQuick

Item {
    id: root

    property color colour: Colours.palette.m3secondary

    implicitWidth: text.implicitWidth
    implicitHeight: text.implicitHeight

    StyledText {
        id: text

        anchors.centerIn: parent

        horizontalAlignment: StyledText.AlignHCenter
        text: Time.format("hh\nmm")
        font.pointSize: Appearance.font.size.smaller
        font.family: Appearance.font.family.mono
        color: root.colour
    }
}
