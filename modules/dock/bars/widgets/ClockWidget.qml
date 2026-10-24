import QtQuick
import Quickshell

import "../menus"

TextWidget {
    property bool dateAndTime: false

    function toggleDateAndTime() {
        dateAndTime = !dateAndTime
    }

    elide: false

    SystemClock {
        id: clock
    }

    text: Qt.formatDateTime(clock.date, dateAndTime ? "dddd, d MMM hh:mm" : "hh:mm")
    fontSize: 20

    onAltClicked: toggleDateAndTime()
}
