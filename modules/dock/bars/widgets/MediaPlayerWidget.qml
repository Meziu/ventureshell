import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import Quickshell.Services.Mpris

import "../../../services"
import "../menus"

ClickableWidget {
    id: root

    property string playIcon: "media-playback-start-symbolic"
    property string pauseIcon: "media-playback-pause-symbolic"

    property real length: 160
    implicitWidth: horizontal ? length : -1
    implicitHeight: !horizontal ? length : -1

    visible: MediaPlayerService.mainPlayer

    Image {
        id: background
        anchors.fill: parent

        source: MediaPlayerService.trackArtUrl

        clip: true
        opacity: 0.7
        fillMode: Image.PreserveAspectCrop
        mipmap: true

        Rectangle {
            id: mask

            anchors.fill: parent
            visible: false
            layer.enabled: true

            radius: root.radius
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: mask
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }
    }

    IconWidget {
        id: playButton
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            margins: 4
        }

        visible: MediaPlayerService.canTogglePlaying
        clickable: MediaPlayerService.canTogglePlaying

        source: MediaPlayerService.isPlaying ? pauseIcon : playIcon
        iconSize: height
        width: height

        onClicked: MediaPlayerService.playToggle()
    }

    TextWidget {
        id: title
        anchors {
            top: playButton.top
            left: playButton.right
            right: parent.right
        }

        implicitHeight: 12

        clickable: false
        text: MediaPlayerService.trackTitle
        fontSize: 12
        horizontalAlignment: Text.AlignLeft
    }
    TextWidget {
        id: artist
        anchors {
            top: title.bottom
            bottom: parent.bottom
            left: title.left
            right: title.right
        }

        implicitHeight: 8

        clickable: false
        text: MediaPlayerService.trackArtist
        fontSize: 8
        horizontalAlignment: Text.AlignLeft
    }

    Component {
        id: menuComponent

        MediaPlayerMenu {}
    }

    onClicked: root.popupRequested(menuComponent)
}
