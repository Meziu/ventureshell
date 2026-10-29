import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io

import "../panels"
import "../../../assetloaders"
import "../../../services"

TextWidget {
    id: root
    text: "O"

    font: OuterWildsFont.logoWithSize(24)

    property bool launcherOpen: false

    function openLauncher() {
        root.popupRequested(launcherPanelComponent);
    }

    function toggleLauncher() {
        if (!root.launcherOpen) {
            root.openLauncher();
        } else {
            root.closeLauncher()
        }
    }

    function closeLauncher() {
        root.popupClosed();
    }

    Component {
        id: launcherPanelComponent
        LauncherPanel {
            Component.onCompleted: {
                launcherOpen = true
            }
            Component.onDestruction: {
                launcherOpen = false
            }
        }
    }

    onClicked: {
        root.toggleLauncher();
    }

    Connections {
        target: LauncherService

        function onOpen() {
            // Only on the focused monitor
            if (Hyprland.monitorFor(screen) === Hyprland.focusedMonitor) {
                root.openLauncher();
            } else {
                root.closeLauncher();
            }
        }

        function onToggle() {
            // Only on the focused monitor
            if (Hyprland.monitorFor(screen) === Hyprland.focusedMonitor) {
                root.toggleLauncher();
            } else {
                root.closeLauncher();
            }
        }

        function onClose() {
            root.closeLauncher();
        }
    }
}
