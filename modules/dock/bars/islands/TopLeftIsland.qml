import Quickshell
import QtQuick

import "../../../shapes"
import "../widgets"

Island {
    id: root

    anchors {
        left: parent.left
        top: parent.top
    }

    attached: Attach {
        top: true
        left: true
        right: false
        bottom: false
    }

    WindowNameWidget {
        id: windowName
        anchors.leftMargin: root.cornerRadius
        anchors.fill: parent
    }
}
