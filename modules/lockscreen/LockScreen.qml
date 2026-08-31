import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls

import "../solarclock"

WlSessionLock {
    id: lock

    WlSessionLockSurface {
        id: root
        readonly property real screenMargins: 40

        SystemClock {
            id: clock
            precision: SystemClock.Minutes
        }

        Button {
            text: "unlock me"
            onClicked: lock.locked = false
            z: 1
        }

        color: "#00000000"

        Image {
            source: "file:assets/images/outerwilds/backgrounds/StarrySky.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
        }

        SolarClock {
            anchors {
                left: parent.left
                leftMargin: root.screenMargins
                verticalCenter: parent.verticalCenter
            }
            scale: 0.5
            transformOrigin: Item.Left
        }

        Column {
            anchors {
                right: parent.right
                rightMargin: root.screenMargins
                verticalCenter: parent.verticalCenter
            }

            spacing: 2

            Text {
                anchors {
                    left: parent.left
                    right: parent.right
                }

                text: Qt.formatTime(clock.date, "hh:mm")
                color: "white"
                font.pointSize: 120
                horizontalAlignment: Text.AlignRight

                renderType: Text.CurveRendering
                renderTypeQuality: Text.VeryHighRenderTypeQuality
            }

            Text {
                text: Qt.formatDate(clock.date, "dddd MMMM d yy")
                color: "white"
                font.pointSize: 40
                horizontalAlignment: Text.AlignRight

                renderType: Text.CurveRendering
                renderTypeQuality: Text.VeryHighRenderTypeQuality
            }
        }
    }
}
