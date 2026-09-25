import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "../../../assetloaders"
import "../../../services"
import "../../../shapes"
import "../widgets"

Menu {
    implicitWidth: 350
    implicitHeight: 300

    RowLayout {
        id: controlZone

        anchors {
            top: parent.top
            bottom: signaloscopeScreen.top
            left: parent.left
            right: parent.right
            bottomMargin: 6
        }

        IconWidget {
            Layout.fillHeight: true
            Layout.fillWidth: true

            iconSize: 32
            source: MediaPlayerService.backIcon
            baseOpacity: 0.1

            onClicked: MediaPlayerService.back()
        }

        Item {
            Layout.fillHeight: true
            implicitWidth: height

            ClippingRectangle {
                anchors.fill: parent
                anchors.margins: 1 // to avoid slight pixel overshoot

                implicitWidth: 200
                implicitHeight: 200

                color: "black"
                opacity: 0.8
                radius: toggleButton.radius

                Image {
                    id: background
                    anchors.fill: parent

                    source: MediaPlayerService.trackArtUrl

                    fillMode: Image.PreserveAspectCrop
                    mipmap: true
                }
            }

            // Separate border because clipping rectangle shows artifacts
            Rectangle {
                anchors.fill: parent
                radius: root.radius
                color: "transparent"
                antialiasing: true
                border.color: "white"
                opacity: 0.8
                border.width: 2
            }

            IconWidget {
                id: toggleButton
                anchors.fill: parent

                hideWidgetWithoutHover: true
                iconSize: 32
                source: MediaPlayerService.toggleIcon

                onClicked: MediaPlayerService.playToggle()
            }
        }

        IconWidget {
            Layout.fillHeight: true
            Layout.fillWidth: true

            iconSize: 32
            source: MediaPlayerService.nextIcon
            baseOpacity: 0.1

            onClicked: MediaPlayerService.next()
        }
    }

    Rectangle {
        id: signaloscopeScreen
        property real borderWidth: 10

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        implicitHeight: 120

        color: "#242E37"

        border {
            color: "#4E5065"
            width: borderWidth
        }

        radius: 16

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: signaloscopeScreen.borderWidth + 6

            TextWidget {
                Layout.fillWidth: true

                clickable: false
                text: MediaPlayerService.trackArtist
                font: OuterWildsFont.signalscopeWithSize(10)
                color: "#ADE1E5"
                horizontalAlignment: Text.AlignHCenter
            }

            Signalscope {
                Layout.fillHeight: true
                Layout.fillWidth: true
                implicitHeight: 60
            }

            TextWidget {
                Layout.fillWidth: true

                clickable: false
                text: MediaPlayerService.trackTitle
                font: OuterWildsFont.signalscopeWithSize(10)
                color: OuterWildsFont.defaultColor
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
