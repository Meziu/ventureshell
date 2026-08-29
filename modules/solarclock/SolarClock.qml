import Quickshell
import Quickshell.Wayland
import QtQuick

Item {
    id: root
    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
        bottom: parent.bottom
    }

    Image {
        source: "file:assets/images/outerwilds/backgrounds/StarrySky.png"
        fillMode: Image.PreserveAspectCrop
        opacity: 1
    }

    Image {
        anchors.centerIn: parent
    }
}
