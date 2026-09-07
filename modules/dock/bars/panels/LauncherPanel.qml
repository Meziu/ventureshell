import QtQuick
import QtQuick.Layouts

import "../../../assetloaders"
import "../widgets"

Panel {
    fillSpace: true
    implicitWidth: 500
    implicitHeight: 60

    Text {
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        text: "LMAO"

        font: OuterWildsFont.uiWithSize(26)
        clip: true
    }

    Rectangle {
        anchors.fill: parent
        opacity: 0.2
        radius: 16
    }
}
