import QtQuick
import QtQuick.Layouts

import "../../../assetloaders"
import "../widgets"

Panel {
    fillSpace: true
    requestedLength: 400
    requestedSize: 80

    Text {
        anchors.fill: parent
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter

        text: "LMAO"

        font: OuterWildsFont.uiWithSize(26)
        clip: true

        onWidthChanged: console.log("TEXT w", width, "x", x, Date.now())
        onXChanged: console.log("TEXT x", x, Date.now())
    }

    Rectangle {
        anchors.fill: parent
        opacity: 0.2
        radius: 16
        clip: true

        onWidthChanged: console.log("TEXT w", width, "x", x, Date.now())
        onXChanged: console.log("TEXT x", x, Date.now())
    }

    onWidthChanged: console.log("PANEL", "w", width, "x", x, "rightEdge(local)", x + width, Date.now())
    onXChanged: console.log("PANEL x", x, Date.now())
}
