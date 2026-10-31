import QtQuick
import QtQuick.Layouts

import "../menus"
import "../../../services"
import "../../../controls"

Widget {
    id: root

    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight

    Component {
        id: menuComponent

        AudioMenu {}
    }

    WidgetContainer {
        id: container

        anchors.fill: parent
        horizontal: root.horizontal
        margins: 0

        Widget {
            Layout.fillWidth: true

            implicitHeight: outputSlider.implicitHeight + outputLabel.implicitHeight

            Slider {
                id: inputSlider
                visible: !root.horizontal

                implicitHeight: 60
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                enabled: !AudioService.defaultInputMuted()
                wheelEnabled: true
                value: AudioService.defaultInputVolume()
                stepSize: 0.05
                snapMode: Slider.SnapOnRelease
                onValueChanged: AudioService.setDefaultInputVolume(value)

                orientation: root.horizontal ? Qt.Horizontal : Qt.Vertical
            }
            TextWidget {
                id: inputLabel

                anchors {
                    top: inputSlider.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                horizontal: root.horizontal

                property string muteIcon: ""
                property string baseIcon: ""

                property string currentIcon: {
                    if (AudioService.defaultInputVolume() === 0 || AudioService.defaultInputMuted()) {
                        return muteIcon;
                    }

                    return baseIcon;
                }
                text: {
                    if (AudioService.defaultInputVolume() === 0 || AudioService.defaultInputMuted() || !horizontal) {
                        return currentIcon;
                    }

                    return Math.round(AudioService.defaultInputVolume() * 100) + "% " + currentIcon;
                }

                onClicked: root.togglePopup(menuComponent)
                onAltClicked: AudioService.toggleDefaultInputMuted()
            }
        }

        Widget {
            Layout.fillWidth: true

            implicitHeight: outputSlider.implicitHeight + outputLabel.implicitHeight

            Slider {
                id: outputSlider
                visible: !root.horizontal

                implicitHeight: 60
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                enabled: !AudioService.defaultOutputMuted()
                wheelEnabled: true
                value: AudioService.defaultOutputVolume()
                stepSize: 0.05
                snapMode: Slider.SnapOnRelease
                onValueChanged: AudioService.setDefaultOutputVolume(value)

                orientation: root.horizontal ? Qt.Horizontal : Qt.Vertical
            }
            TextWidget {
                id: outputLabel

                anchors {
                    top: outputSlider.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                horizontal: root.horizontal

                property string muteIcon: ""
                property list<string> audioIcons: ["", "", ""]

                property string currentIcon: {
                    let volumeClamp = Math.min(AudioService.defaultOutputVolume(), 0.999999);

                    if (volumeClamp === 0 || AudioService.defaultOutputMuted()) {
                        return muteIcon;
                    }

                    return audioIcons[Math.floor(volumeClamp * audioIcons.length)];
                }
                text: {
                    if (AudioService.defaultOutputVolume() === 0 || AudioService.defaultOutputMuted() || !horizontal) {
                        return currentIcon;
                    }

                    return Math.round(AudioService.defaultOutputVolume() * 100) + "% " + currentIcon;
                }

                onClicked: root.togglePopup(menuComponent)
                onAltClicked: AudioService.toggleDefaultOutputMuted()
            }
        }
    }
}
