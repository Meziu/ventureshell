import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

import "../../../controls"
import "../../../services"
import "../widgets"

ColumnLayout {
    id: root

    required property list<PwNode> streams

    spacing: 2

    TextWidget {
        Layout.fillWidth: true

        text: "Mixer"
        fontSize: 12

        elide: Text.ElideRight
        clickable: false
    }

    // Stream list with volume sliders
    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 12

        Repeater {
            model: root.streams

            ColumnLayout {
                required property PwNode modelData

                Slider {
                    id: inputSlider
                    visible: !root.horizontal

                    Layout.alignment: Qt.AlignHCenter
                    implicitHeight: 100

                    enabled: !AudioService.nodeMuted(modelData)
                    wheelEnabled: true
                    value: AudioService.nodeVolume(modelData)
                    stepSize: 0.05
                    snapMode: Slider.SnapOnRelease
                    onValueChanged: AudioService.setNodeVolume(modelData, value)

                    orientation: Qt.Vertical
                }

                TextWidget {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.maximumWidth: 120

                    text: AudioService.nodeLabel(modelData)

                    fontSize: 12
                    elide: Text.ElideRight

                    onClicked: {
                        AudioService.toggleNodeMuted(modelData)
                    }
                }

                IconWidget {
                    Layout.alignment: Qt.AlignHCenter

                    source: AudioService.nodeIcon(modelData)

                    iconSize: 20
                    clickable: false
                }
            }
        }
    }
}
