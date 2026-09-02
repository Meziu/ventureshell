import Quickshell
import Quickshell.Wayland
import QtQuick

import "../../shapes"
import "../widgets"

CurvyBox {
    width: clock.requestedWidth + cornerRadius * 2

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

    Clock {
        anchors.centerIn: parent
        id: clock
    }
}
