pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    signal open()
    signal toggle()
    signal close()

    IpcHandler {
        target: "launcher"

        function open() {
            root.open()
        }

        function toggle() {
            root.toggle()
        }

        function close() {
            root.close()
        }
    }
}
