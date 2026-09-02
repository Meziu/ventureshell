import Quickshell
import Quickshell.Wayland
import QtQuick

import "../../shapes"
import "../widgets"

CurvyBox {
    id: root

    property real minWidth: 0
    property real maxWidth: 850

    property string titleText: ToplevelManager.activeToplevel ? ToplevelManager.activeToplevel.title : ""
    visible: titleText !== "" ? true : false

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

    WindowName {
        id: windowName
        anchors.fill: parent
    }
}
