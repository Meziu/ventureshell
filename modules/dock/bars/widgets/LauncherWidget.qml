import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../panels"
import "../../../assetloaders"

TextWidget {
    id: root
    text: "O"

    font: OuterWildsFont.logoWithSize(24)

    Component {
        id: launcherPanelComponent
        LauncherPanel {}
    }

    onClicked: {
        root.panelRequested(launcherPanelComponent)
    }
}
