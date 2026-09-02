import QtQuick

Behavior {
    property bool isHovered: false
    property real inTime: 200
    property real outTime: 120

    NumberAnimation {
        duration: isHovered ? outTime : inTime
        easing.type: isHovered ? Easing.OutQuad : Easing.InQuad
    }
}
