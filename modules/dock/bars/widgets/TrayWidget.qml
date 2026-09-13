import QtQuick
import QtQuick.Layouts

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

        Repeater {
            model: ["file:assets/images/outerwilds/planets/AmberTwin.png"]

            IconWidget {
                required property string modelData
                source: modelData

                iconSize: 40
            }
        }
    }
}
