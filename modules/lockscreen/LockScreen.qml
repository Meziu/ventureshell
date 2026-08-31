import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../solarclock"

WlSessionLock {
    id: lock
    locked: true

    WlSessionLockSurface {
        id: root
        readonly property real screenMargins: 60

        color: "#00000000"

        SystemClock {
            id: clock
            precision: SystemClock.Minutes
        }

        FontLoader {
            id: uiFont
            source: "file:assets/fonts/itc-serif-gothic/itc-serif-gothic-extra-bold-588cef7e1f5d9.otf"

            property string color: "#F28B2C"
        }

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

        PamContext {
            id: pam

            onPamMessage: {
                if (pam.responseRequired) {
                    pam.respond(passwordField.text);
                }
            }

            onCompleted: result => {
                if (result === PamResult.Success) {
                    lock.locked = false;
                } else {
                    passwordField.text = "";
                    passwordField.placeholderText = "Incorrect password"
                    passwordField.placeholderTextColor = "red"
                }
            }

            onError: error => {
                console.log("PAM error:", error);
            }
        }

        ColumnLayout {
            anchors {
                right: parent.right
                rightMargin: root.screenMargins
                verticalCenter: parent.verticalCenter
            }

            spacing: 20

            Text {
                Layout.alignment: Qt.AlignRight
                Layout.bottomMargin: -50

                text: Qt.formatTime(clock.date, "hh:mm")
                color: uiFont.color
                font.family: uiFont.font.family
                font.weight: uiFont.font.weight
                font.styleName: uiFont.font.styleName
                font.pointSize: 140

                renderType: Text.CurveRendering
                renderTypeQuality: Text.VeryHighRenderTypeQuality
            }

            Text {
                id: date

                Layout.alignment: Qt.AlignRight

                text: Qt.formatDate(clock.date, "dddd, MMMM d")
                color: uiFont.color
                font.family: uiFont.font.family
                font.weight: uiFont.font.weight
                font.styleName: uiFont.font.styleName
                font.pointSize: 50

                renderType: Text.CurveRendering
                renderTypeQuality: Text.VeryHighRenderTypeQuality
            }

            TextField {
                id: passwordField

                Layout.preferredWidth: date.width + 100
                Layout.topMargin: 50

                background: Rectangle {
                    anchors.fill: parent
                    border.color: uiFont.color
                    border.width: 4

                    color: "#00000000"
                    radius: 16
                }

                font.family: uiFont.font.family
                font.weight: uiFont.font.weight
                font.styleName: uiFont.font.styleName
                font.letterSpacing: 6
                font.pointSize: 30
                padding: 16
                color: uiFont.color
                horizontalAlignment: Text.AlignLeft

                echoMode: TextInput.Password

                placeholderText: "Insert password..."
                placeholderTextColor: "gray"
                passwordCharacter: "●"

                selectByMouse: false
                cursorVisible: false

                focus: true

                onAccepted: pam.start()
            }
        }
    }
}
