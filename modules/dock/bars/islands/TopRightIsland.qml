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

    attached: Attach {
        top: true
        left: false
        right: true
        bottom: false
    }

    IdleInhibitorWidget {}

    PowerWidget {}

    NetworkWidget {}

    NotificationsWidget {
        Layout.rightMargin: root.cornerRadius
    }
}
