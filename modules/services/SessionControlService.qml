pragma Singleton

import Quickshell
import Quickshell.Io

import "../config"
import "../lockscreen"

Singleton {
    id: root

    property bool visible: false

    function toggle() {
        visible = !visible
    }

    function open() {
        visible = true
    }

    function close() {
        visible = false
    }

    // Actual session controls
    function lock() {
        if (Config.options.sessionctl.commands.useInternalLockscreen) {
            LockScreenService.lock()
        } else {
            Quickshell.execDetached(Config.options.sessionctl.commands.lock)
        }
    }

    function logout() {
        Quickshell.execDetached(Config.options.sessionctl.commands.logout)
    }

    function suspend() {
        Quickshell.execDetached(Config.options.sessionctl.commands.suspend)
    }

    function shutdown() {
        Quickshell.execDetached(Config.options.sessionctl.commands.shutdown)
    }

    function reboot() {
        Quickshell.execDetached(Config.options.sessionctl.commands.reboot)
    }

    function hibernate() {
        Quickshell.execDetached(Config.options.sessionctl.commands.hibernate)
    }

    IpcHandler {
        target: "sessionctl"

        function toggle() {
            root.toggle()
        }

        function open() {
            root.open()
        }

        function close() {
            root.close()
        }
    }
}
