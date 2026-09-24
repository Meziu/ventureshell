pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
    id: root

    // First player or the first one found currently playing
    property MprisPlayer mainPlayer: {
        const list = Mpris.players.values;
        return (list[0] ?? list.find(p => p.isPlaying)) ?? null
    }

    property bool canControl: mainPlayer?.canControl || false
    property bool canTogglePlaying: root.canControl && mainPlayer.canTogglePlaying
    property bool canNext: root.canControl && mainPlayer.canGoNext
    property bool canBack: root.canControl && mainPlayer.canGoPrevious
    property alias canStop: root.canControl

    property string trackTitle: mainPlayer?.trackTitle || "Unknown Track"
    property string trackArtUrl: mainPlayer?.trackArtUrl || ""
    property string trackArtist: mainPlayer?.trackArtist || "Unknown Artist"
    property string trackAlbum: mainPlayer?.trackAlbum || "Unknown Album"

    property bool isPlaying: mainPlayer?.isPlaying || false

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
