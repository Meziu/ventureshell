pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property alias options: adapter
    property bool ready: false

    FileView {
        path: Quickshell.env("XDG_CONFIG_HOME") ? Quickshell.env("XDG_CONFIG_HOME") + "/ventureshell/config.json" : Quickshell.env("HOME") + "/.config/ventureshell/config.json"

        watchChanges: true
        blockLoading: true

        onFileChanged: reload()
        //onAdapterUpdated: writeAdapter()
        onLoaded: root.ready = true

        // All available options! Have a feast :P
        JsonAdapter {
            id: adapter

            property JsonObject bar: JsonObject {
                property real size: 40
                property real cornerRadius: 16
            }

            property JsonObject sessionctl: JsonObject {
                property real centerRadius: 180
                property real eyeScalePerHundredRadius: 0.2

                property real innerMouseOvershoot: 70
                property real outerMouseOvershoot: 20

                property JsonObject slice: JsonObject {
                    property real length: 180
                    property real lengthIncrease: 60
                }

                property JsonObject commands: JsonObject {
                    property bool useInternalLockscreen: true

                    property list<string> shutdown:     ["systemd-run", "--user", "--scope", "hyprshutdown", "-p", "systemctl poweroff"]
                    property list<string> reboot:       ["systemd-run", "--user", "--scope", "hyprshutdown", "-p", "systemctl reboot"]
                    property list<string> logout:       ["systemd-run", "--user", "--scope", "hyprshutdown"]
                    property list<string> suspend:      ["systemctl", "suspend"]
                    property list<string> lock:         ["loginctl", "lock-session"]
                    property list<string> hibernate:    ["systemctl", "hibernate"]
                }
            }
        }
    }
}
