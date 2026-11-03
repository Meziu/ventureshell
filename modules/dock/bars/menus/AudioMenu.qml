import QtQuick
import QtQuick.Controls as Ctls
import QtQuick.Layouts
import Quickshell

import "../../../controls"
import "../../../services"
import "../../../shapes"
import "../widgets"

Menu {
    id: root
    implicitWidth: list.implicitWidth
    implicitHeight: list.implicitHeight + list.spacing * list.children.length

    ColumnLayout {
        id: list

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        spacing: 2

        AudioDeviceSelector {
            Layout.fillWidth: true
            label: "Output"
            devices: AudioService.outputDevices
            current: AudioService.defaultAudioSink
            onSelected: node => AudioService.setDefaultOutputDevice(node)
        }

        AudioDeviceSelector {
            Layout.fillWidth: true
            label: "Input"
            devices: AudioService.inputDevices
            current: AudioService.defaultAudioSource
            onSelected: node => AudioService.setDefaultInputDevice(node)
        }

        MenuSeparator {
            Layout.fillWidth: true
        }

        AudioStreamMixer {
            Layout.bottomMargin: 8

            streams: AudioService.outputStreams
        }

        MenuSeparator {
            Layout.fillWidth: true
        }

        TextWidget {
            text: "Open PAVolumeControl"
            Layout.fillWidth: true

            onClicked: Quickshell.execDetached("pavucontrol")
        }
    }
}
