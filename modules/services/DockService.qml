pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    signal hideAllPopups()

    IpcHandler {
        target: "dock"

        function hideAllPopups() {
            root.hideAllPopups()
        }
    }
}
