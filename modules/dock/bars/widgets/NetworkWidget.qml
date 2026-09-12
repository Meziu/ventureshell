import QtQuick

import "../../../services"
import "../menus"

TextWidget {
    property string wiredIcon: "󰈀"
    property list<string> wifiStrengthIcons: ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"]
    property string disconnectedIcon: "󰤮"
    property string vpnConnectedIcon: ""
    property string vpnDisconnectedIcon: ""
    property string vpnInactiveIcon: "󰂭"

    property bool showSignalStrength: true

    readonly property string vpnIcon: {
        if (NetworkService.vpnStatus === NetworkService.VpnStatus.Inactive) {
            return vpnInactiveIcon
        } else if (NetworkService.vpnStatus === NetworkService.VpnStatus.Connected) {
            return vpnConnectedIcon
        } else if (NetworkService.vpnStatus === NetworkService.VpnStatus.Unreachable) {
            return vpnDisconnectedIcon
        }

        return "" // unreachable, if the enum is exhaustively checked
    }

    text: {
        if (NetworkService.hasWiredConnection()) {
            return wiredIcon + vpnIcon
        }

        if (NetworkService.hasWifiConnection()) {
            if (!NetworkService.activeNetwork) {
                return disconnectedIcon
            }

            // Between 0 and 1
            let strength = NetworkService.activeNetwork.signalStrength

            let icon = wifiStrengthIcons[Math.floor(strength * wifiStrengthIcons.length)]

            if (showSignalStrength) {
                return Math.round(strength*100) + "% " + icon + vpnIcon
            } else {
                return icon + vpnIcon
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
