import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../../shapes"
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

        anchors.fill: parent
        anchors.rightMargin: root.cornerRadius

        text: "LMAO3"
    }
}
