import QtQuick
import QtQuick.Layouts
import Quickshell

import "../../../services"
import "../widgets"

ColumnLayout {
    id: root

    property bool expanded: false
    spacing: 0

    // Scan only while the dropdown is open
    Binding {
        target: NetworkService
        property: "scanning"
        value: root.expanded && NetworkService.wifiEnabled
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 4

        TextWidget {
            Layout.fillWidth: true
            text: "Available networks"
            fontSize: 12
            horizontalAlignment: Text.AlignLeft
            onClicked: root.expanded = !root.expanded
        }

        TextWidget {
            text: root.expanded ? "▾" : "▸"
            fontSize: 12
            clickable: false
        }
    }

    ColumnLayout {
        visible: root.expanded
        Layout.fillWidth: true
        Layout.leftMargin: 12
        spacing: 0

        Repeater {
            model: ScriptModel {
                values: NetworkService.wifiNetworks.slice(0, 8)
            }

            WifiNetworkEntry {}
        }

        TextWidget {
            visible: NetworkService.wifiNetworks.length === 0
            text: "Scanning..."
            fontSize: 12
            clickable: false
            opacity: 0.6
        }
    }
}
