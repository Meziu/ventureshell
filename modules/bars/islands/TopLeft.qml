import Quickshell
import Quickshell.Wayland
import QtQuick

import "../../assetloaders"
import "../../shapes"

CurvyBox {
    width: 700
    height: 40

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

    Text {
        anchors.fill: parent

        text: ToplevelManager.activeToplevel ? ToplevelManager.activeToplevel.title : ""
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter

        font: OuterWildsUIFont.withSize(14)
        color: OuterWildsUIFont.defaultColor
    }
}
