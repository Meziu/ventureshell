pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property alias options: adapter
    property bool ready: false

    FileView {
        path: Qt.resolvedUrl(Quickshell.env("XDG_CONFIG_HOME") ? Quickshell.env("XDG_CONFIG_HOME") + "/ventureshell/config.json" : Quickshell.env("HOME") + "/.config/ventureshell/config.json")

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
                property real centerRadius: 260
                property real eyeScalePerHundredRadius: 0.2

                property real innerMouseOvershoot: 75
                property real outerMouseOvershoot: 75

                property JsonObject slice: JsonObject {
                    property real length: 200
                    property real lengthIncrease: 60
                }

                property JsonObject commands: JsonObject {
                    property bool useInternalLockscreen: true

                    property list<string> shutdown: ["hyprshutdown", "-p", "systemctl poweroff"]
                    property list<string> reboot: ["hyprshutdown", "-p", "systemctl reboot"]
                    property list<string> lock: ["loginctl", "lock-session"]
                    property list<string> suspend: ["systemctl", "sleep"]
                    property list<string> logout: ["hyprshutdown"]
                    property list<string> hibernate: ["systemctl", "hibernate"]
                }
            }
        }
    }
}
