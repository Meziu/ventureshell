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

    attached: Attach {
        top: true
        left: true
        right: false
        bottom: false
    }

    WindowNameWidget {
        id: windowName
        Layout.leftMargin: root.cornerRadius
        Layout.fillWidth: true
        Layout.fillHeight: true
        horizontalAlignment: Text.AlignLeft // so it doesn't jump when resizing
    }
}
