pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool locked: false

    function lock() {
        locked = true;
    }

    IpcHandler {
        target: "lockscreen"

        function lock() {
            root.lock()
        }
    }
}
