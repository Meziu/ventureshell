import Quickshell
import Quickshell.Io
import QtQuick

import "modules/bars"
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
            locked: false
        }
    }

    HorizontalBar {

    }

    IpcHandler {
        target: "sessionctl"

        function toggle(): void {
            sessionControlLoader.active = true;
            sessionControlLoader.item.visible = !sessionControlLoader.item.visible;
        }
    }

    IpcHandler {
        target: "lockscreen"

        function lock(): void {
            lockScreenLoader.active = true;
            lockScreenLoader.item.locked = true;
        }
    }
}
