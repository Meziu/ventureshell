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

        FontLoader {
            id: uiFont
            source: "file:assets/fonts/itc-serif-gothic/itc-serif-gothic-extra-bold-588cef7e1f5d9.otf"

            property string color: "#F28B2C"
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
                rightMargin: root.screenMargins * 2
                verticalCenter: parent.verticalCenter
            }

            spacing: 2

            Text {
                anchors {
                    left: parent.left
                    right: parent.right
                }

                text: Qt.formatTime(clock.date, "hh:mm")
                color: uiFont.color
                font.family: uiFont.font.family
                font.weight: uiFont.font.weight
                font.styleName: uiFont.font.styleName
                font.pointSize: 140
                horizontalAlignment: Text.AlignRight

                renderType: Text.CurveRendering
                renderTypeQuality: Text.VeryHighRenderTypeQuality
            }

            Text {
                text: Qt.formatDate(clock.date, "dddd, MMMM d")
                color: uiFont.color
                font.family: uiFont.font.family
                font.weight: uiFont.font.weight
                font.styleName: uiFont.font.styleName
                font.pointSize: 50
                horizontalAlignment: Text.AlignRight

                renderType: Text.CurveRendering
                renderTypeQuality: Text.VeryHighRenderTypeQuality
            }
        }
    }
}
