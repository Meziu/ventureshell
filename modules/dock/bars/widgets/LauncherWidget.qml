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
    Layout.preferredWidth: 30

    property LauncherPanel seachBar: LauncherPanel {}
    onClicked: {
        root.panelRequested(seachBar)
    }
}
