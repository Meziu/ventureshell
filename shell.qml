import Quickshell
import Quickshell.Io
import QtQuick

import "modules/config"
import "modules/dock"
import "modules/sessioncontrol"
import "modules/lockscreen"

ShellRoot {
    LazyLoader {
        id: sessionControlLoader
        active: Config.ready
        loading: true

        SessionControl {
            visible: false
        }
    }

    LazyLoader {
        id: lockScreenLoader
        active: Config.ready
        loading: true

        LockScreen {
            locked: false
        }
    }

    LazyLoader {
        id: dockLoader
        active: Config.ready
        loading: true

        Dock {}
    }

    IpcHandler {
        target: "sessionctl"

        function toggle(): void {
            sessionControlLoader.item.visible = !sessionControlLoader.item.visible;
        }
    }

    IpcHandler {
        target: "lockscreen"

        function lock(): void {
            lockScreenLoader.item.locked = true;
        }
    }
}
