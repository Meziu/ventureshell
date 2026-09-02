import QtQuick

Behavior {
    property bool isHovered: false

    NumberAnimation {
        duration: isHovered ? 120 : 200
        easing.type: isHovered ? Easing.OutQuad : Easing.InQuad
        easing.overshoot: 1.1
    }
}
