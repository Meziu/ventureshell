import Quickshell
import Quickshell.Wayland
import QtQuick

import "../../shapes"
import "../widgets"

CurvyBox {
    id: root

    property real centerIslandWidth: 0
    property real minWidth: 0
    property real maxWidth: (parent.width - centerIslandWidth) / 2 - cornerRadius * 2

    visible: windowName.text !== "" ? true : false

    width: Math.max(minWidth, Math.min(windowName.requestedWidth + cornerRadius * 2, maxWidth))

    Behavior on width {
        NumberAnimation {
            duration: 100
            easing.type: Easing.OutCubic
        }
    }

    attached: Attach {
        top: true
        left: true
        right: false
        bottom: false
    }

    anchors {
        left: parent.left
        top: parent.top
    }

    WindowNameWidget {
        id: windowName
        anchors.leftMargin: root.cornerRadius
        anchors.fill: parent
    }
}
