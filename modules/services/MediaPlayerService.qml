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

    signal playToggle()
    signal next()
    signal back()
    signal stop()

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
