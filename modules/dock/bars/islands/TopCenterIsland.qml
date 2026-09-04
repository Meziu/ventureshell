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
        top: true
        left: false
        right: false
        bottom: false
    }

    anchors {
        horizontalCenter: parent.horizontalCenter
        top: parent.top
    }

    TextWidget {
        id: appWidget
        text: "O"

        font: OuterWildsFont.logoWithSize(24)

        Layout.preferredWidth: 30
        Layout.fillHeight: true
    }

    ClockWidget {
        id: clock
        dateAndTime: false

        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    IconWidget {
        id: shutdownWidget
        source: "file:assets/images/outerwilds/symbols/MinimalEye.svg"

        Layout.preferredWidth: 30
        Layout.fillHeight: true

        effect: NomaiEyeGlow {}
    }
}
