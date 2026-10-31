import QtQuick
import QtQuick.Layouts

import "../menus"
import "../../../services"

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

        TextWidget {
            id: inputLabel

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
        TextWidget {
            id: outputLabel

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
