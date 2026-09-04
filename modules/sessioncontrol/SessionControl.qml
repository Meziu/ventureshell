import Quickshell
import Quickshell.Hyprland
import QtQuick

Item {
    HyprlandFocusGrab {
        id: grab
        windows: sessionctlScreens.instances
    }

    Variants {
        id: sessionctlScreens
        model: Quickshell.screens

        SessionControlWindow {
            required property ShellScreen modelData

            screen: modelData
        }
    }
}
