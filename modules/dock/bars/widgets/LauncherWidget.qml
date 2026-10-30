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

    Component {
        id: launcherPanelComponent
        LauncherPanel {}
    }

    onClicked: {
        root.togglePopup(launcherPanelComponent);
    }

    Connections {
        target: LauncherService

        function onOpen() {
            // Only on the focused monitor
            if (Hyprland.monitorFor(screen) === Hyprland.focusedMonitor) {
                root.openPopup(launcherPanelComponent);
            } else {
                root.closePopup();
            }
        }

        function onToggle() {
            // Only on the focused monitor
            if (Hyprland.monitorFor(screen) === Hyprland.focusedMonitor) {
                root.togglePopup(launcherPanelComponent);
            } else {
                root.closePopup();
            }
        }

        function onClose() {
            root.closePopup();
        }
    }
}
