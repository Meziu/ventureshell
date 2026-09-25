import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "../../../assetloaders"
import "../../../services"
import "../../../controls"
import "../../../shapes"
import "../widgets"

Menu {
    id: root

    implicitWidth: 360
    implicitHeight: 320

    function formatSeconds(totalSeconds) {
        var minutes = Math.floor(totalSeconds / 60)
        var seconds = Math.floor(totalSeconds % 60)
        return (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds
    }

    ColumnLayout {
        id: controlZone

        anchors {
            top: parent.top
            bottom: signaloscopeScreen.top
            left: parent.left
            right: parent.right
            bottomMargin: 6
        }

        RowLayout {
            IconWidget {
                Layout.fillHeight: true
                Layout.fillWidth: true

                clickable: MediaPlayerService.canBack
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
                    radius: toggleButton.radius
                    color: "transparent"
                    antialiasing: true
                    border.color: "white"
                    opacity: 0.8
                    border.width: 2
                }

                IconWidget {
                    id: toggleButton
                    anchors.fill: parent

                    clickable: MediaPlayerService.canTogglePlaying
                    hideWidgetWithoutHover: true
                    iconSize: 32
                    source: MediaPlayerService.toggleIcon

                    onClicked: MediaPlayerService.playToggle()
                }
            }

            IconWidget {
                Layout.fillHeight: true
                Layout.fillWidth: true

                clickable: MediaPlayerService.canNext
                iconSize: 32
                source: MediaPlayerService.nextIcon
                baseOpacity: 0.1

                onClicked: MediaPlayerService.next()
            }
        }

        RowLayout {
            visible: MediaPlayerService.positionSupported && MediaPlayerService.lengthSupported
            Layout.fillWidth: true

            TextWidget {
                Layout.fillHeight: false
                implicitWidth: 60

                clickable: false
                horizontalAlignment: Text.AlignRight

                text: root.formatSeconds(MediaPlayerService.position)
                fontSize: 10
            }

            Slider {
                Layout.fillWidth: true
                live: false

                enabled: MediaPlayerService.canSeek

                from: 0
                to: MediaPlayerService.length
                value: MediaPlayerService.position

                onPressedChanged: {
                    if (pressed) {
                        value = value
                    } else {
                        MediaPlayerService.seek(value)
                        value = Qt.binding(() => MediaPlayerService.position)
                    }
                }
            }

            TextWidget {
                Layout.fillHeight: false
                implicitWidth: 60

                clickable: false
                horizontalAlignment: Text.AlignLeft

                text: root.formatSeconds(MediaPlayerService.length)
                fontSize: 10
            }
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
                id: lyrics
                Layout.fillWidth: true

                clickable: false
                text: "Like the wind gonna breeze fires will burn"
                font: OuterWildsFont.signalscopeWithSize(6)
                color: "#ADE1E5"
                horizontalAlignment: Text.AlignHCenter
            }

            Signalscope {
                Layout.fillHeight: true
                Layout.fillWidth: true
                implicitHeight: 60
            }

            TextWidget {
                id: trackInfo
                Layout.fillWidth: true

                clickable: false
                text: MediaPlayerService.trackArtist + " - " + MediaPlayerService.trackTitle
                font: OuterWildsFont.signalscopeWithSize(10)
                color: OuterWildsFont.defaultColor
                horizontalAlignment: Text.AlignHCenter
                slide: true
            }
        }
    }

    Connections {
        target: MediaPlayerService

        function onMainPlayerChanged() {
            if (!MediaPlayerService.mediaPlayer) {
                root.exited()
            }
        }
    }
}
