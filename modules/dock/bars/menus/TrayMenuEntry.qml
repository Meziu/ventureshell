import QtQuick
import QtQuick.Layouts
import Quickshell

import "../../../shapes"
import "../widgets"

ColumnLayout {
    id: root

    required property QsMenuEntry entry
    property int depth: 0
    property bool expanded: false

    spacing: 0

    QsMenuOpener {
        id: childOpener
        menu: root.entry.hasChildren ? root.entry : null
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: root.entry.isSeparator ? 4 : -1
        Layout.leftMargin: root.depth * 12
        spacing: 4

        MenuSeparator {
            visible: root.entry.isSeparator
            Layout.fillWidth: true
        }

        IconWidget {
            clickable: false
            visible: !root.entry.isSeparator && root.entry.icon !== ""
            source: root.entry.icon
            iconSize: 16
        }

        TextWidget {
            visible: !root.entry.isSeparator
            Layout.fillWidth: true
            text: root.entry.text
            fontSize: 12
            horizontalAlignment: Text.AlignLeft
            opacity: root.entry.enabled ? 1 : 0.5
            clickable: !root.entry.isSeparator && root.entry.enabled

            onClicked: {
                if (root.entry.hasChildren)
                    root.expanded = !root.expanded
                else
                    root.entry.triggered()
            }
        }

        // Arrow indicator for submenus
        TextWidget {
            visible: root.entry.hasChildren
            text: root.expanded ? "▾" : "▸"
            fontSize: 12
            clickable: false
        }
    }

    ColumnLayout {
        visible: root.expanded && root.entry.hasChildren
        Layout.fillWidth: true
        spacing: 0

        Repeater {
            model: childOpener.children

            Loader {
                id: childLoader
                required property var modelData

                Layout.fillWidth: true

                Component.onCompleted: setSource("TrayMenuEntry.qml", {
                    entry: childLoader.modelData,
                    depth: root.depth + 1
                })
            }
        }
    }
}
