import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import "../services"
import "bars"

Item {
    Variants {
        model: Quickshell.screens

        Item {
            required property var modelData

            readonly property alias verticalBar: verticalLoader.item

            HorizontalBar {
                id: horizontalBar
                screen: modelData
            }

            LazyLoader {
                id: verticalLoader
                active: false

                VerticalBar {
                    screen: modelData
                }
            }

            Timer {
                interval: 50          // horrifying heuristic solution to the race condition for exclusionZone
                running: true
                repeat: false
                onTriggered: verticalLoader.active = true
            }

            HyprlandFocusGrab {
                id: grab
                active: verticalBar?.requiresFocusGrab || horizontalBar.requiresFocusGrab
                windows: [verticalBar, horizontalBar]

                onCleared: {
                    verticalBar.hidePopups();
                    horizontalBar.hidePopups();
                }
            }

            IdleInhibitor {
                window: horizontalBar
                enabled: IdleInhibitorService.inhibit
            }

            Connections {
                target: verticalBar

                function onPopupOpened() {
                    horizontalBar.hidePopups();
                }
            }
            Connections {
                target: horizontalBar

                function onPopupOpened() {
                    verticalBar.hidePopups();
                }
            }
            Connections {
                target: DockService

                function onHideAllPopups() {
                    horizontalBar.hidePopups();
                    verticalBar.hidePopups();
                }
            }

            Connections {
                target: Hyprland

                function onRawEvent(event) {
                    switch (event.name) {
                    case "openwindow":          // a new window mapped, so the launch is done
                    //case "activewindowv2":    // focus moved to another window
                    case "workspacev2":         // workspace switched
                    case "focusedmonv2":        // focus moved to another monitor
                        verticalBar.hidePopups();
                        horizontalBar.hidePopups();
                        break;
                    }
                }
            }
        }
    }
}
