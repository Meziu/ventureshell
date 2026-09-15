import QtQuick
import Quickshell.Services.Pipewire

import "../menus"
import "../../../services"

TextWidget {
    property string muteIcon: ""
    property list<string> audioIcons: ["", "", ""]

    text: {
        const volume = Math.min(AudioService.defaultOutputVolume(), 0.999999);

        if (volume === 0 || AudioService.defaultOutputMuted()) {
            return muteIcon
        }

        return Math.round(volume * 100) + "% " + audioIcons[Math.floor(volume * audioIcons.length)]
    }
}
