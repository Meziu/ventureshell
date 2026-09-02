import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: root

    anchors {
        left: true
        top: true
        bottom: true
    }
    implicitWidth: 40

    color: "#00000000"

    Text {
        anchors.centerIn: parent
        text: "LMAO"
        color: "#FFFFFF"
    }
}
