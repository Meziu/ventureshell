import Quickshell
import QtQuick
import QtQuick.Layouts

import "../../../shapes"
import "../widgets"

Island {
    id: root

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

    LauncherWidget {}

    WindowNameWidget {
        id: windowName
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignLeft // so it doesn't jump when resizing
    }
}
