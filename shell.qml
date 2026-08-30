import Quickshell
import Quickshell.Io
import QtQuick

import "modules/sessioncontrol"
import "modules/lockscreen"

ShellRoot {
    LazyLoader {
        id: sessionControlLoader
        loading: true

        SessionControl {
            visible: false
        }
    }

    LazyLoader {
        id: lockScreenLoader
        loading: true

        LockScreen {
            visible: true
        }
    }

    IpcHandler {
        target: "sessionctl"

        function toggle(): void {
            sessionControlLoader.active = true;
            sessionControlLoader.item.visible = !sessionControlLoader.item.visible;
        }
    }
}
