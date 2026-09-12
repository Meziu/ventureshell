pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Networking
import Quickshell.Io

Singleton {
    id: root
    readonly property bool wifiEnabled: Networking.wifiEnabled

    readonly property WifiDevice wifiDevice: {
        if (!Networking.wifiEnabled)
            return null;

        for (let i = 0; i < Networking.devices.values.length; i++) {
            let device = Networking.devices.values[i];

            if (device.type === DeviceType.Wifi)
                return device;
        }

        return null;
    }
    readonly property WiredDevice wiredDevice: {
        for (let i = 0; i < Networking.devices.values.length; i++) {
            let device = Networking.devices.values[i];

            if (device.type === DeviceType.Wired)
                return device;
        }

        return null;
    }
    readonly property Network activeNetwork: {
        if (NetworkService.hasWiredConnection()) {
            return wiredDevice.network;
        }

        if (NetworkService.hasWifiConnection()) {
            for (let i = 0; i < wifiDevice.networks.values.length; i++) {
                let network = wifiDevice.networks.values[i];

                if (network.connected) return network;
            }
        }

        return null;
    }

    property string targetVpnName: "wireguardvpn"
    property string remoteHost: "10.214.101.1"
    property int pingTimeoutSeconds: 2

    enum VpnStatus {
        Inactive,
        Connected,
        Unreachable
    }

    readonly property alias vpnStatus: internal.status
    readonly property bool vpnActive: vpnStatus !== NetworkService.VpnStatus.Inactive
    readonly property alias vpnIp: internal.ip

    QtObject {
        id: internal
        property int status: NetworkService.VpnStatus.Inactive
        property string ip: ""
        property string cachedVpnName: ""
        property string cachedDevice: ""
    }

    Timer {
        interval: pingTimeoutSeconds * 1500
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: updateVpnStatus()
    }

    Component.onCompleted: {
        initProc.exec(["nmcli", "-t", "-f", "NAME,TYPE", "connection", "show"]);
    }

    function updateVpnStatus() {
        if (!statusProc.running) {
            statusProc.exec(["nmcli", "-t", "-f", "NAME,TYPE,DEVICE", "connection", "show", "--active"]);
        }
    }

    function setVpn(enabled: bool) {
        if (!internal.cachedVpnName || toggleProc.running)
            return;

        if (!enabled && vpnActive) {
            toggleProc.exec(["nmcli", "connection", "down", internal.cachedVpnName]);
        } else if (enabled && !vpnActive) {
            toggleProc.exec(["nmcli", "connection", "up", internal.cachedVpnName]);
        }
    }

    function toggleVpn() {
        setVpn(!vpnActive)
    }

    Process {
        id: initProc
        stdout: StdioCollector {
            onStreamFinished: {
                if (targetVpnName !== "") {
                    internal.cachedVpnName = targetVpnName;
                    return;
                }

                // Fallback to search
                const lines = this.text.trim().split("\n");
                for (let i = 0; i < lines.length; i++) {
                    const parts = lines[i].split(":");
                    if (parts.length >= 2 && parts[1] === "wireguard") {
                        internal.cachedVpnName = parts[0];
                        break;
                    }
                }
            }
        }
    }

    Process {
        id: statusProc
        stdout: StdioCollector {
            onStreamFinished: {
                let activeDevice = "";
                let activeName = "";

                const lines = this.text.trim().split("\n");
                for (let i = 0; i < lines.length; i++) {
                    const parts = lines[i].split(":");
                    if (parts.length >= 3) {
                        if (parts[0] === internal.cachedVpnName) {
                            activeName = parts[0];
                            activeDevice = parts[2];
                            break;
                        }
                    }
                }

                if (!activeDevice) {
                    internal.status = NetworkService.VpnStatus.Inactive;
                    internal.ip = "";
                    return;
                }

                internal.cachedDevice = activeDevice;
                if (internal.cachedVpnName === "")
                    internal.cachedVpnName = activeName;

                pingProc.exec(["ping", "-c", "1", "-W", pingTimeoutSeconds.toString(), remoteHost]);
            }
        }
    }

    Process {
        id: pingProc
        onExited: exitCode => {
            if (exitCode !== 0) {
                internal.status = NetworkService.VpnStatus.Unreachable;
                internal.ip = "";
            } else {
                ipProc.exec(["nmcli", "-g", "IP4.ADDRESS", "device", "show", internal.cachedDevice]);
            }
        }
    }

    Process {
        id: ipProc
        stdout: StdioCollector {
            onStreamFinished: {
                const rawIp = this.text.trim();
                internal.ip = rawIp ? rawIp.split("/")[0] : "";
                internal.status = NetworkService.VpnStatus.Connected;
            }
        }
    }

    Process {
        id: toggleProc
        onExited: updateVpnStatus()
    }

    function setWifi(enabled: bool) {
        Networking.wifiEnabled = enabled;
    }
    function hasWifiConnection(): bool {
        return wifiDevice && wifiDevice.connected;
    }
    function hasWiredConnection(): bool {
        return wiredDevice && wiredDevice.connected;
    }
}
