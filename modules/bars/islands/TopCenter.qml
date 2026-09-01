import Quickshell
import Quickshell.Wayland
import QtQuick

import "../../assetloaders"
import "../../shapes"

CurvyBox {
    implicitWidth: 100
    implicitHeight: 40

    attached: Attach {
        top: true
        left: false
        right: false
        bottom: false
    }

    anchors {
        horizontalCenter: parent.horizontalCenter
        top: parent.top
    }

    Text {
        anchors.centerIn: parent
        text: "LMAO2"

        font: OuterWildsUIFont.withSize(14)
        color: OuterWildsUIFont.defaultColor
    }

    color: "#FFFFFF"
}
