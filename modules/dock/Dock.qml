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

            VerticalBar {
                id: verticalBar
                screen: modelData
            }

            HorizontalBar {
                id: horizontalBar
                screen: modelData
            }

            HyprlandFocusGrab {
                id: grab
                active: verticalBar.requiresFocusGrab || horizontalBar.requiresFocusGrab
                windows: [verticalBar, horizontalBar]

                onCleared: {
                    verticalBar.hidePopups()
                    horizontalBar.hidePopups()
                }
            }

            IdleInhibitor {
                window: horizontalBar
                enabled: IdleInhibitorService.inhibit
            }

            Connections {
                target: verticalBar

                function onPopupOpened() {
                    horizontalBar.hidePopups()
                }
            }
            Connections {
                target: horizontalBar

                function onPopupOpened() {
                    verticalBar.hidePopups()
                }
            }
            Connections {
                target: DockService

                function onHideAllPopups() {
                    horizontalBar.hidePopups()
                    verticalBar.hidePopups()
                }
            }
        }
    }
}
