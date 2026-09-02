import Quickshell
import Quickshell.Wayland
import QtQuick

import "../../assetloaders"
import "../../shapes"

CurvyBox {
    property bool dateAndTime: true

    width: clockText.contentWidth + cornerRadius * 2

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

    SystemClock {
        id: clock
    }

    Text {
        id: clockText

        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, dateAndTime ? "dddd, d MMMM hh:mm" : "hh:mm")

        font: OuterWildsUIFont.withSize(14)
        color: OuterWildsUIFont.defaultColor
    }
}
