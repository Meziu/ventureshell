import Quickshell
import Quickshell.Wayland
import QtQuick

import "../solarclock"

PanelWindow {
    id: root
    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    color: "#00000000"

    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore

    Image {
        source: "file:assets/images/outerwilds/backgrounds/StarrySky.png"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        opacity: 0.9
    }

    SolarClock {
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
        scale: 0.5
        transformOrigin: Item.Center
    }
}
