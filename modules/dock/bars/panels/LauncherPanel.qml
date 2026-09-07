import QtQuick
import QtQuick.Layouts

import "../../../assetloaders"
import "../widgets"

Panel {
    fillSpace: true
    implicitWidth: 400
    implicitHeight: 80

    Text {
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        text: "LMAO"

        font: OuterWildsFont.uiWithSize(26)
    }

    Rectangle {
        anchors.fill: parent
        opacity: 0.2
        radius: 16
    }
}
