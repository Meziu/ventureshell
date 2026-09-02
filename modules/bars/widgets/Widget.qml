import QtQuick

Item {
    anchors {
        top: parent.top
        bottom: parent.bottom
    }

    property real requestedWidth: childrenRect.width
}
