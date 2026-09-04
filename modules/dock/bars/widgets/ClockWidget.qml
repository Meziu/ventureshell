import QtQuick
import Quickshell

import "../../../assetloaders"

TextWidget {
    property bool dateAndTime: false

    SystemClock {
        id: clock
    }

    text: Qt.formatDateTime(clock.date, dateAndTime ? "dddd, d MMMM hh:mm" : "hh:mm")
    font: OuterWildsFont.uiWithSize(20)
}
