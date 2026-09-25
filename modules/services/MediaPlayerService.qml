pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
    id: root

    property string playIcon: "media-playback-start-symbolic"
    property string pauseIcon: "media-playback-pause-symbolic"
    property string toggleIcon: MediaPlayerService.isPlaying ? MediaPlayerService.pauseIcon : MediaPlayerService.playIcon
    property string nextIcon: "media-skip-backward-symbolic-rtl"
    property string backIcon: "media-skip-backward-symbolic"

    // First player or the first one found currently playing
    property MprisPlayer mainPlayer: {
        const list = Mpris.players.values;
        return (list.find(p => p.isPlaying) ?? list[0]) ?? null
    }

    readonly property bool canControl: mainPlayer?.canControl || false
    readonly property bool canTogglePlaying: root.canControl && mainPlayer.canTogglePlaying
    readonly property bool canNext: root.canControl && mainPlayer.canGoNext
    readonly property bool canBack: root.canControl && mainPlayer.canGoPrevious
    readonly property alias canStop: root.canControl

    readonly property string trackTitle: mainPlayer?.trackTitle || "Unknown Track"
    readonly property string trackArtUrl: mainPlayer?.trackArtUrl || ""
    readonly property string trackArtist: mainPlayer?.trackArtist || "Unknown Artist"
    readonly property string trackAlbum: mainPlayer?.trackAlbum || "Unknown Album"

    readonly property bool positionSupported: mainPlayer?.positionSupported || false
    readonly property bool lengthSupported: mainPlayer?.lengthSupported || false
    readonly property bool canSeek: root.canControl && mainPlayer?.canSeek || false
    readonly property real position: mainPlayer?.position || 0
    readonly property real length: mainPlayer?.length || 0

    readonly property bool isPlaying: mainPlayer?.isPlaying || false

    signal trackChanged

    Connections {
        target: mainPlayer

        function onPostTrackChanged() {
            root.trackChanged()
        }
    }

    // Position updater
    Timer {
      running: root.isPlaying
      interval: 500
      repeat: true
      onTriggered: mainPlayer.positionChanged()
    }

    function playToggle() {
        if (root.canTogglePlaying) {
            mainPlayer.togglePlaying()
        }
    }
    function next() {
        if (root.canNext) {
            mainPlayer.next()
        }
    }
    function back() {
        if (root.canBack) {
            mainPlayer.previous()
        }
    }
    function stop() {
        if (root.canControl) {
            mainPlayer.stop()
        }
    }
    function seek(position: real) {
        if (root.canSeek && root.positionSupported) {
            mainPlayer.position = position
        }
    }

    IpcHandler {
        target: "mediaplayer"

        function playToggle() {
            root.playToggle()
        }

        function next() {
            root.next()
        }

        function back() {
            root.back()
        }

        function stop() {
            root.stop()
        }
    }
}
