import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../../../config"
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

    IconWidget {
        id: appWidget
        source: "file:assets/images/outerwilds/symbols/OuterWildsVentures.png"

        Layout.preferredWidth: 40
        Layout.fillHeight: true
    }

    ClockWidget {
        id: clock
        dateAndTime: true

        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    IconWidget {
        id: shutdownWidget
        source: "file:assets/images/outerwilds/symbols/MinimalEye.svg"

        Layout.preferredWidth: 40
        Layout.fillHeight: true

        effect: NomaiEyeGlow {}
    }
}
