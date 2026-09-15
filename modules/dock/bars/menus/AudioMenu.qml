import QtQuick
import QtQuick.Controls as Ctls
import QtQuick.Layouts
import Quickshell

import "../widgets"
import "../../../controls"
import "../../../services"

Menu {
    id: root
    implicitWidth: 260
    implicitHeight: list.implicitHeight + list.spacing * list.children.length

    ColumnLayout {
        id: list

        anchors.fill: parent
        spacing: 2

        RowLayout {
            Layout.fillWidth: true

            TextWidget {
                text: "Volume"
                clickable: false
            }

            Slider {
                id: volumeSlider
                value: AudioService.defaultOutputVolume()

                Layout.margins: 8
                Layout.fillWidth: true

                stepSize: 0.05
                snapMode: Slider.SnapOnRelease
                onValueChanged: AudioService.setDefaultOutputVolume(volumeSlider.value)
            }
        }

        Rectangle {
            Layout.fillWidth: true

            color: "#FFFFFF"
            opacity: 0.2
            height: 1
        }

        TextWidget {
            text: "Open PAVolumeControl"
            Layout.fillWidth: true

            onClicked: Quickshell.execDetached("pavucontrol")
        }
    }
}
