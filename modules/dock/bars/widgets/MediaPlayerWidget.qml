import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Mpris

import "../../../services"
import "../menus"

ClickableWidget {
    id: root

    property real length: 200
    implicitWidth: horizontal ? length : -1
    implicitHeight: !horizontal ? length : -1

    visible: MediaPlayerService.mainPlayer

    ClippingRectangle {
        anchors.fill: parent

        color: "black"
        opacity: 0.6
        radius: root.radius
        border {
            color: "white"
            width: 1
        }

        Image {
            id: background
            anchors.fill: parent

            source: MediaPlayerService.trackArtUrl

            fillMode: Image.PreserveAspectCrop
            mipmap: true
        }
    }

    RowLayout {
        anchors.fill: parent

        IconWidget {
            id: playButton

            Layout.fillHeight: true
            Layout.topMargin: 4
            Layout.bottomMargin: 4
            Layout.leftMargin: 6

            visible: MediaPlayerService.canTogglePlaying
            clickable: MediaPlayerService.canTogglePlaying

            source: MediaPlayerService.toggleIcon
            iconSize: height
            width: height

            onClicked: MediaPlayerService.playToggle()
        }

        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 4

            TextWidget {
                id: title

                Layout.fillWidth: true
                implicitHeight: 12

                clickable: false
                text: MediaPlayerService.trackTitle
                fontSize: 12
                horizontalAlignment: Text.AlignLeft
            }

            TextWidget {
                id: artist

                Layout.fillWidth: true

                implicitHeight: 8

                clickable: false
                text: MediaPlayerService.trackArtist
                fontSize: 8
                horizontalAlignment: Text.AlignLeft
            }
        }
    }

    Component {
        id: menuComponent

        MediaPlayerMenu {}
    }

    onClicked: root.popupRequested(menuComponent)
}
