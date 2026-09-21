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

    function toggleLauncher() {
        root.popupRequested(launcherPanelComponent);
    }

    Component {
        id: launcherPanelComponent
        LauncherPanel {}
    }

    onClicked: {
        root.toggleLauncher();
    }

    Connections {
        target: LauncherService

        function onToggle() {
            // Only on the focused monitor
            if (Hyprland.monitorFor(screen) === Hyprland.focusedMonitor) {
                root.toggleLauncher();
            }
        }
    }
}
