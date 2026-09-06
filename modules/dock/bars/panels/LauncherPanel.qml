import QtQuick
import QtQuick.Layouts

import "../widgets"

Panel {
    fillSpace: true
    Layout.preferredWidth: 300
    Layout.preferredHeight: 40

    Text {
        anchors.fill: parent
        text: "LMAO"
    }

    Rectangle {
        anchors.fill: parent
        opacity: 0.2
    }
}
