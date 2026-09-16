import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../../../shapes"
import "../widgets"
import "../menus"

Island {
    id: root

    horizontal: true
    widgetsFillIsland: false

    anchors {
        top: parent.top
        right: parent.right
    }

    widgetContainer.anchors.rightMargin: root.cornerRadius

    attached: Attach {
        top: true
        left: false
        right: true
        bottom: false
    }

    TrayWidget {}

    AudioWidget {}

    IdleInhibitorWidget {}

    PowerWidget {}

    NetworkWidget {}
}
