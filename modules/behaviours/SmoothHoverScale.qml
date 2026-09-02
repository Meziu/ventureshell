import QtQuick

Behavior {
    property bool isHovered: false
    property real inTime: 200
    property real outTime: 120
    property real overshoot: 1.1

    NumberAnimation {
        duration: isHovered ? inTime : outTime
        easing.type: isHovered ? Easing.OutQuad : Easing.InQuad
        easing.overshoot: overshoot
    }
}
