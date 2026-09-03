import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../../../config"
import "../../../assetloaders"
import "../../../shapes"
import "../../../effects"
import "../widgets"

Island {
    attached: Attach {
        top: false
        left: true
        right: false
        bottom: false
    }

    anchors {
        verticalCenter: parent.verticalCenter
        left: parent.left
    }

    TextWidget {
        id: appWidget
        text: "O"

        font: OuterWildsFont.logoWithSize(24)

        Layout.preferredHeight: 30
        Layout.fillWidth: true
    }

    IconWidget {
        id: shutdownWidget
        source: "file:assets/images/outerwilds/symbols/MinimalEye.svg"

        Layout.preferredHeight: 30
        Layout.fillWidth: true

        effect: NomaiEyeGlow {}
    }
}
