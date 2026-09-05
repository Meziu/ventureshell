import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../../../shapes"
import "../widgets"

Island {
    id: root

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

    IdleInhibitorWidget {}

    PowerWidget {}

    NetworkWidget {}

    NotificationsWidget {}
}
