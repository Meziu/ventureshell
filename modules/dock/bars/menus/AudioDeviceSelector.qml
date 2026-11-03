import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

import "../../../services"
import "../widgets"

ColumnLayout {
    id: root

    required property string label
    required property list<PwNode> devices
    required property PwNode current
    signal selected(node: PwNode)

    property bool expanded: false

    spacing: 0

    RowLayout {
        Layout.fillWidth: true
        spacing: 4

        TextWidget {
            Layout.fillWidth: true
            text: root.label + ": " + (root.current ? AudioService.nodeLabel(root.current) : "None")
            fontSize: 12
            horizontalAlignment: Text.AlignLeft
            elide: Text.ElideRight
            onClicked: root.expanded = !root.expanded
        }

        TextWidget {
            text: root.expanded ? "▾" : "▸"
            fontSize: 12
            clickable: false
        }
    }

    // Device list
    ColumnLayout {
        visible: root.expanded
        Layout.fillWidth: true
        Layout.leftMargin: 12
        spacing: 0

        Repeater {
            model: root.devices

            TextWidget {
                required property PwNode modelData

                Layout.fillWidth: true
                text: (modelData.id === root.current?.id ? "✓ " : "   ")
                      + AudioService.nodeLabel(modelData)
                fontSize: 12
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight

                onClicked: {
                    root.selected(modelData)
                    root.expanded = false
                }
            }
        }
    }
}
