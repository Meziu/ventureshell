import Quickshell
import QtQuick
import QtQuick.Layouts

import "../../../shapes"
import "../widgets"

Island {
    id: root

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

    WindowNameWidget {
        id: windowName
        horizontalAlignment: Text.AlignLeft // so it doesn't jump when resizing
    }
}
