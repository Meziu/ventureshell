import QtQuick
import QtQuick.Layouts
import Quickshell

import "../menus"
import "../../../assetloaders"

TextWidget {
    property bool dateAndTime: false

    elide: false

    SystemClock {
        id: clock
    }

    text: Qt.formatDateTime(clock.date, dateAndTime ? "dddd, d MMMM hh:mm" : "hh:mm")
    font: OuterWildsFont.uiWithSize(20)
}
