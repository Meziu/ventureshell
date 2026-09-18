pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    signal toggle()

    IpcHandler {
        target: "launcher"

        function toggle() {
            root.toggle()
        }
    }
}
