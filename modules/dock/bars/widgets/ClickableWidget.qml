import QtQuick

import "../../../behaviours"

Widget {
    id: root

    property bool clickable: true
    signal clicked()

    Rectangle {
        id: background
        anchors.fill: parent
        opacity: mouseArea.containsMouse ? 0.2 : 0
        radius: 12
        visible: clickable

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
