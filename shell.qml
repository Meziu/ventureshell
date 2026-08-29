import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import "modules/sessioncontrol"
import "modules/solarclock"

ShellRoot {
    LazyLoader {
          id: sessionControlLoader
          loading: true

          SessionControl {
              visible: false
          }
    }

    PanelWindow {
        id: root
        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        color: "#00000000"

        WlrLayershell.layer: WlrLayer.Overlay
        exclusionMode: ExclusionMode.Ignore

        SolarClock {

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
