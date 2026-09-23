import QtQuick
import QtQuick.Effects
import Quickshell.Services.Mpris

import "../../../services"

ClickableWidget {
    id: root

    property real length: 160
    implicitWidth: horizontal ? length : -1
    implicitHeight: !horizontal ? length : -1

    Image {
        anchors.fill: parent

        source: MediaPlayerService.mainPlayer?.trackArtUrl ?? ""

        clip: true
        opacity: 0.7
        fillMode: Image.PreserveAspectCrop
        mipmap: true

        Rectangle {
            id: mask

            anchors.fill: parent
            visible: false
            layer.enabled: true

            radius: root.radius
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: mask
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }
    }
}
