import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../../assetloaders"
import "../../shapes"

CurvyBox {
    implicitWidth: 100
    implicitHeight: 40

    anchors {
        right: parent.right
        top: parent.top
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

    color: "#FFFFFF"
}
