import QtQuick

import "../../../behaviours"

Widget {
    id: root

    property bool clickable: true
    property bool isHovered: mouseArea.containsMouse
    property real baseOpacity: 0
    property real hoverOpacity: 0.2
    property real radius: 12
    signal clicked()
    signal altClicked()

    Rectangle {
        id: background
        anchors.fill: parent
        opacity: mouseArea.containsMouse ? hoverOpacity : baseOpacity
        radius: root.radius
        visible: clickable

        MouseArea {
            id: mouseArea
            hoverEnabled: true
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: (mouseEvent) => {
                if (mouseEvent.button === Qt.LeftButton) {
                    root.clicked()
                } else if (mouseEvent.button === Qt.RightButton) {
                    root.altClicked()
                }
            }
        }

        SmoothHoverOpacity on opacity {
            isHovered: mouseArea.containsMouse
        }
    }
}
