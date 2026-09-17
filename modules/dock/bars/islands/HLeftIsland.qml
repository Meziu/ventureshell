import Quickshell
import QtQuick
import QtQuick.Layouts

import "../../../shapes"
import "../widgets"

Island {
    id: root

    horizontal: true
    widgetsFillIsland: true

    anchors {
        left: parent.left
        top: parent.top
    }

    widgetContainer.anchors.leftMargin: root.cornerRadius

    attached: Attach {
        top: true
        left: true
        right: false
        bottom: false
    }

    NotificationWidget {}

    WindowNameWidget {
        id: windowName
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignLeft // so it doesn't jump when resizing
    }
}
