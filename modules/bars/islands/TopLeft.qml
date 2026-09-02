import Quickshell
import Quickshell.Wayland
import QtQuick

import "../../assetloaders"
import "../../shapes"

CurvyBox {
    id: root

    property real minWidth: 0
    property real maxWidth: 850

    property string titleText: ToplevelManager.activeToplevel ? ToplevelManager.activeToplevel.title : ""
    visible: titleText !== "" ? true : false

    width: Math.max(minWidth, Math.min(textMetrics.width + cornerRadius * 2, maxWidth))

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

    // To avoid binding loops
    TextMetrics {
        id: textMetrics
        font: OuterWildsUIFont.withSize(14)
        text: root.titleText
    }

    Text {
        id: windowName
        anchors.fill: parent

        text: root.titleText
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

        font: textMetrics.font
        color: OuterWildsUIFont.defaultColor
    }
}
