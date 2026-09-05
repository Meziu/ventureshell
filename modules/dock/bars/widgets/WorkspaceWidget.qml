import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "../../../assetloaders"
import "../../../behaviours"

Widget {
    id: root

    Layout.preferredWidth: layout.implicitWidth
    Layout.preferredHeight: layout.implicitHeight

    property HyprlandMonitor monitor: Hyprland.monitorFor(screen)
    property list<HyprlandWorkspace> monitorWorkspaces: {
        let ws = [];
        for (let i = 0; i < Hyprland.workspaces.values.length; i++) {
            const current = Hyprland.workspaces.values[i];

            if (current.monitor === root.monitor) {
                ws.push(current);
            }
        }
        return ws;
    }
    property HyprlandWorkspace activeWorkspace: monitor?.activeWorkspace

    GridLayout {
        id: layout
        anchors.fill: parent

        // The cell width is the "limiting" size
        property real cellSize: root.horizontal ? height : width

        rows: root.horizontal ? 1 : -1
        columns: root.horizontal ? -1 : 1
        uniformCellHeights: true
        uniformCellWidths: true
        rowSpacing: -2
        columnSpacing: -2

        Repeater {
            model: monitorWorkspaces

            Text {
                id: workspaceLabel
                required property HyprlandWorkspace modelData
                property bool focused: modelData === activeWorkspace
                property real letterSpacing: -4

                Layout.preferredWidth: layout.cellSize
                Layout.preferredHeight: layout.cellSize

                text: modelData.id
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                color: OuterWildsFont.lightColor
                font: OuterWildsFont.logoWithOverrides({
                    pointSize: 18,
                    letterSpacing: letterSpacing
                })
                leftPadding: letterSpacing

                Rectangle {
                    anchors.fill: parent

                    color: OuterWildsFont.lightColor

                    opacity: {
                        let opacity = 0
                        if (workspaceLabel.focused) {
                            opacity += 0.2
                        }
                        if (mouseArea.containsMouse) {
                            opacity += 0.1
                        }
                        return opacity
                    }
                    radius: width / 2
                    visible: true

                    MouseArea {
                        id: mouseArea
                        hoverEnabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        onClicked: workspaceLabel.modelData.activate()
                    }

                    SmoothHoverOpacity on opacity {
                        isHovered: mouseArea.containsMouse
                    }
                }
            }
        }
    }
}
