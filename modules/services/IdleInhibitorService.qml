pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property bool inhibit: false

    function toggle() {
        inhibit = !inhibit
    }
}
