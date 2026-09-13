import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../../../shapes"
import "../widgets"

Island {
    horizontal: true
    widgetsFillIsland: false

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

    LauncherWidget {}

    ClockWidget {
        id: clock
        dateAndTime: false

        Layout.fillWidth: true
    }

    SessionControlWidget {
        iconSize: 40
    }
}
