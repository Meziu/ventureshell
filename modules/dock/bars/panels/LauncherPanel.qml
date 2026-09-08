import QtQuick
import QtQuick.Controls

import "../../../assetloaders"
import "../widgets"

Panel {
    fillSpace: true
    requestedLength: 500
    requestedSize: 60

    TextField {
        id: passwordField

        anchors.fill: parent

        background: Rectangle {
            anchors.fill: parent

            color: OuterWildsFont.darkColor
            opacity: 0.7
            radius: 16
        }

        font: OuterWildsFont.uiWithSize(18)
        padding: 10
        color: OuterWildsFont.lightColor
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft

        placeholderText: "Search..."
        placeholderTextColor: "gray"

        selectByMouse: true
        cursorVisible: false

        focus: true

        Component.onCompleted: {
            forceActiveFocus();
        }

        onAccepted: exited()
    }
}
