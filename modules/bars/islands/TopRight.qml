import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../../assetloaders"
import "../../shapes"

CurvyBox {
    width: 100
    height: 40

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

    Text {
        anchors.centerIn: parent
        text: "LMAO3"

        font: OuterWildsUIFont.withSize(14)
        color: OuterWildsUIFont.defaultColor
    }
}
