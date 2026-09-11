import QtQuick
import Quickshell.Networking

import "../menus"

TextWidget {
    property string wiredIcon: "󰈀"
    property list<string> wifiStrengthIcons: ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"]
    property string disconnectedIcon: "󰤮"
    property bool showSignalStrength: true

    property WifiDevice wifiDevice: {
        if (!Networking.wifiEnabled) return null

        for (let i = 0; i < Networking.devices.values.length; i++) {
            let device = Networking.devices.values[i]

            if (device.type === DeviceType.Wifi) return device
        }

        return null
    }

    property WiredDevice wiredDevice: {
        for (let i = 0; i < Networking.devices.values.length; i++) {
            let device = Networking.devices.values[i]

            if (device.type === DeviceType.Wired) return device
        }

        return null
    }

    function hasWifiConnection(): bool {
        return wifiDevice && wifiDevice.connected
    }

    function hasWiredConnection(): bool {
        return wiredDevice && wiredDevice.connected
    }

    text: {
        if (hasWiredConnection()) {
            return wiredIcon
        }

        if (hasWifiConnection()) {
            if (!wifiDevice.networks.values[0]) {
                return disconnectedIcon
            }

            // Between 0 and 1
            let strength = wifiDevice.networks.values[0].signalStrength

            let icon = wifiStrengthIcons[Math.floor(strength * wifiStrengthIcons.length)]

            if (showSignalStrength) {
                return Math.round(strength*100) + "% " + icon
            } else {
                return icon
            }
        }

        return disconnectedIcon
    }

    Component {
        id: menuComponent
        NetworkMenu {}
    }

    onClicked: {
        menuRequested(menuComponent)
    }
}
