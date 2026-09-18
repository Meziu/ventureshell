import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../services"
import "../solarclock"
import "../assetloaders"

WlSessionLock {
    id: lock
    locked: LockScreenService.locked

    WlSessionLockSurface {
        id: root
        readonly property real screenMargins: 60

        color: "#00000000"

        SystemClock {
            id: clock
            precision: SystemClock.Minutes
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
                    LockScreenService.unlock()
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
                color: OuterWildsFont.defaultColor
                font: OuterWildsFont.uiWithSize(140)

                renderType: Text.CurveRendering
                renderTypeQuality: Text.VeryHighRenderTypeQuality
            }

            Text {
                id: date

                Layout.alignment: Qt.AlignRight

                text: Qt.formatDate(clock.date, "dddd, MMMM d")
                color: OuterWildsFont.defaultColor
                font: OuterWildsFont.uiWithSize(40)

                renderType: Text.CurveRendering
                renderTypeQuality: Text.VeryHighRenderTypeQuality
            }

            TextField {
                id: passwordField

                Layout.preferredWidth: date.width + 100
                Layout.topMargin: 40

                background: Rectangle {
                    anchors.fill: parent
                    border.color: OuterWildsFont.defaultColor
                    border.width: 4

                    color: "#00000000"
                    radius: 16
                }

                font: OuterWildsFont.uiWithSize(30)
                padding: 16
                color: OuterWildsFont.defaultColor
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
