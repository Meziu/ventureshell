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

    TextWidget {
        id: textWidget

        Layout.rightMargin: root.cornerRadius

        text: "I'm at the top left? No wait, right, top right"
    }
}
