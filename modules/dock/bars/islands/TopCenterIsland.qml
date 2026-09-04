import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../../../config"
import "../../../assetloaders"
import "../../../shapes"
import "../../../effects"
import "../../../sessioncontrol"
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
    }

    ClockWidget {
        id: clock
        dateAndTime: false
    }

    IconWidget {
        id: shutdownWidget
        source: "file:assets/images/outerwilds/symbols/MinimalEye.svg"

        Layout.preferredWidth: 30

        effect: NomaiEyeGlow {}

        onClicked: SessionControlService.show()
    }
}
