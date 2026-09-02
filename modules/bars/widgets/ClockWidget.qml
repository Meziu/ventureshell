import QtQuick
import Quickshell

TextWidget {
    property bool dateAndTime: false

    SystemClock {
        id: clock
    }

    text: Qt.formatDateTime(clock.date, dateAndTime ? "dddd, d MMMM hh:mm" : "hh:mm")
    horizontalAlignment: Text.AlignHCenter
}
