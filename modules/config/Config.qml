pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property alias options: adapter
    property bool ready: false

    FileView {
        path: Qt.resolvedUrl(Quickshell.env("XDG_CONFIG_HOME")
              ? Quickshell.env("XDG_CONFIG_HOME") + "/ventureshell/config.json"
              : Quickshell.env("HOME") + "/.config/ventureshell/config.json")

        watchChanges: true
        blockLoading: true

        onFileChanged: reload()
        //onAdapterUpdated: writeAdapter()
        onLoaded: root.ready = true

        JsonAdapter {
            id: adapter
            property int barSize: 40
        }
    }
}
