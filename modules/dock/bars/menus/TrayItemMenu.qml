import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Menu {
    id: menu

    required property Item trayItemWidget
    property SystemTrayItem trayItem: trayItemWidget.modelData

    Connections {
        target: trayItemWidget
        function onExited() {
            menu.exited();
        }
    }

    QsMenuOpener {
        id: opener
        menu: menu.trayItem && menu.trayItem.hasMenu ? menu.trayItem.menu : null
    }

    implicitWidth: Math.max(160, contentLayout.implicitWidth)
    implicitHeight: Math.max(40, contentLayout.implicitHeight)

    ColumnLayout {
        id: contentLayout
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        anchors.margins: 4
        spacing: 0

        Repeater {
            model: opener.children

            TrayMenuEntry {
                required property var modelData

                Layout.fillWidth: true
                Layout.fillHeight: false
                entry: modelData
            }
        }
    }
}
