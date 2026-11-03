import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "../../../theme"
import "../../../assetloaders"
import "../../../behaviours"

Widget {
    id: root

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
    property HyprlandWorkspace activeWorkspace: monitor?.activeWorkspace || null

    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight

    WidgetContainer {
        id: container

        anchors.fill: parent
        horizontal: root.horizontal
        margins: 0

        Repeater {
            model: monitorWorkspaces

            TextWidget {
                id: workspaceLabel
                required property HyprlandWorkspace modelData
                property bool focused: workspaceLabel.modelData === root.activeWorkspace
                property real letterSpacing: -2
                horizontal: root.horizontal

                clickable: false
                text: modelData.id

                font: OuterWildsFont.logoWithOverrides({
                    pointSize: 18,
                    letterSpacing: letterSpacing
                })

                Rectangle {
                    anchors.fill: parent

                    color: Theme.text.lightColor

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
