import QtQuick
import Quickshell

import "../../assetloaders"

Widget {
    property bool dateAndTime: false
    requestedWidth: clockText.contentWidth

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
