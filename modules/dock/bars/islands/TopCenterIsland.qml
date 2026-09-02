import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../../../shapes"
import "../widgets"

Island {
    attached: Attach {
        top: true
        left: false
        right: false
        bottom: false
    }

    anchors {
        horizontalCenter: parent.horizontalCenter
        top: parent.top
    }

    RowLayout {
        anchors.fill: parent

        property real requestedLength: {
            let sum = spacing;

            for (let i = 0; i < children.length; i++) {
                if (children[i].requestedLength) {
                    sum += children[i].requestedLength
                }
            }

            return sum
        }

        ClockWidget {
            id: clock
            dateAndTime: true

            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        IconWidget {
            id: shutdownWidget
            source: "file:assets/images/outerwilds/symbols/MinimalEye.svg"

            Layout.preferredWidth: 40
            Layout.fillHeight: true
        }
    }
}
