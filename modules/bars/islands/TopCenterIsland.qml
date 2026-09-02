import Quickshell
import Quickshell.Wayland
import QtQuick

import "../../shapes"
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

    ClockWidget {
        id: clock
        dateAndTime: true
        anchors.fill: parent
    }
}
