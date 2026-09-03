import QtQuick
import QtQuick.Layouts

import "../../../behaviours"

Item {
    id: root

    property bool horizontal: true
    property real requestedLength: horizontal ? childrenRect.width : childrenRect.height
    signal clicked()

    Rectangle {
        id: background
        anchors.fill: parent
        opacity: mouseArea.containsMouse ? 0.2 : 0
        radius: 12

        MouseArea {
            id: mouseArea
            hoverEnabled: true
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: root.clicked()
        }

        SmoothHoverOpacity on opacity {
            isHovered: mouseArea.containsMouse
        }
    }
}
