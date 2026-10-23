import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

import "../widgets"

Menu {
    id: menu

    required property Item trayItemWidget
    property SystemTrayItem trayItem: trayItemWidget.modelData

    Connections {
        target: trayItemWidget

        function onExited() {
            menu.exited()
        }
    }

    QsMenuOpener {
        id: opener
        menu: menu.trayItem ? menu.trayItem.menu : null
    }

    implicitWidth: Math.max(160, contentLayout.implicitWidth)
    implicitHeight: Math.max(40, contentLayout.implicitHeight)

    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: 4

        Repeater {
            model: opener.children

            RowLayout {
                Layout.preferredHeight: modelData.isSeparator ? 4 : -1
                spacing: 4

                IconWidget {
                    clickable: false
                    visible: modelData.icon !== ""
                    source: modelData.icon
                    iconSize: 16
                }

                TextWidget {
                    Layout.fillWidth: true

                    text: modelData.text
                    fontSize: 12
                    horizontalAlignment: Text.AlignLeft

                    clickable: !modelData.isSeparator && modelData.enabled

                    onClicked: modelData.triggered()
                }
            }
        }
    }
}
