import QtQuick

import "../menus"
import "../../../services"

Widget {
    id: root

    requestedLength: container.requestedLength

    WidgetContainer {
        id: container

        horizontal: root.horizontal

        Repeater {
            model: ["file:assets/images/outerwilds/planets/AmberTwin.png"]

            IconWidget {
                required property string modelData
                source: modelData
            }
        }
    }
}
