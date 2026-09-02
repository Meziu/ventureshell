import QtQuick
import QtQuick.Layouts

import "../../../behaviours"

Item {
    property bool horizontal: true
    property real requestedLength: horizontal ? childrenRect.width : childrenRect.height

    Rectangle {
        id: background
        anchors.fill: parent
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        opacity: mouseArea.containsMouse ? 0.2 : 0
        radius: 12

        MouseArea {
            id: mouseArea
            hoverEnabled: true
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
        }

        SmoothHoverOpacity on opacity {
            isHovered: mouseArea.containsMouse
        }
    }
}
