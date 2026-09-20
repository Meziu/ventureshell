import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

import "../menus"

Widget {
    id: root

    visible: SystemTray.items.values.length > 0

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
                id: iconWidget
                required property SystemTrayItem modelData

                signal exited()

                source: modelData.icon
                iconSize: 22

                onClicked: {
                    if (modelData.hasMenu) {
                        root.popupRequested(menuComponent);
                    }
                }
                onAltClicked: modelData.activate()

                Component.onDestruction: iconWidget.exited()

                Component {
                    id: menuComponent

                    TrayItemMenu {
                        trayItemWidget: iconWidget
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.fill: container
        anchors.margins: -2
        opacity: 0.15
        radius: height / 2
    }
}
