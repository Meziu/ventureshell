import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

import "../menus"
import "../../../services"

Widget {
    id: root

    requestedLength: container.requestedLength

    WidgetContainer {
        id: container

        anchors.fill: parent
        horizontal: root.horizontal
        margins: 2
        spacing: 4

        Repeater {
            model: SystemTray.items

            IconWidget {
                required property SystemTrayItem modelData
                source: modelData.icon

                iconSize: 20
            }
        }
    }

    Rectangle {
        anchors.fill: container
        anchors.margins: -2
        opacity: 0.15
        radius: height/2
    }
}
