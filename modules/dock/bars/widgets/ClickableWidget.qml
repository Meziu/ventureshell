import QtQuick

import "../../../behaviours"

Widget {
    id: root

    property bool clickable: true
    property bool isHovered: mouseArea.containsMouse
    signal clicked()
    signal altClicked()

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
