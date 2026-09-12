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

    property bool showSignalStrength: false

    readonly property string wifiIcon: {
        if (NetworkService.activeNetwork) {
            const strength = Math.min(NetworkService.activeNetwork.signalStrength, 0.999999);
            return wifiStrengthIcons[Math.floor(strength * wifiStrengthIcons.length)]
        }

        return wifiStrengthIcons[0]
    }
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

            if (showSignalStrength) {
                return Math.round(NetworkService.activeNetwork.signalStrength*100) + "% " + wifiIcon + vpnIcon
            } else {
                return wifiIcon + vpnIcon
            }
        }

        return disconnectedIcon
    }

    Component {
        id: menuComponent
        NetworkMenu {}
    }

    onClicked: menuRequested(menuComponent)
    onAltClicked: NetworkService.toggleVpn()
}
