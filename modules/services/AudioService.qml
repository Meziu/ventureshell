pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
    id: root

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    // Frequency group averages (normalized 0.0 - 1.0)
    signal cavaDataFetched(bass: real, mids: real, highs: real)

    Process {
        id: cavaProc
        command: ["cava", "-p", Quickshell.shellPath("cava.conf")]
        running: true

        stdout: SplitParser {
            onRead: data => {
                // Parse line of semicolon-separated bar values: "20;45;80;10;..."
                let values = data.trim().split(';').map(v => parseInt(v) || 0);
                if (values.length < 12)
                    return;

                // Group 16 CAVA bars into Bass, Mids, Highs
                let bSum = 0, mSum = 0, hSum = 0;

                for (let i = 0; i < 4; i++)
                    bSum += values[i];         // Bars 0-3: Bass
                for (let i = 4; i < 10; i++)
                    mSum += values[i];        // Bars 4-9: Mids
                for (let i = 10; i < values.length; i++)
                    hSum += values[i]; // Bars 10+: Highs

                // Smoothly weight and normalize values
                let bass = (bSum / 400.0);
                let mids = (mSum / 600.0);
                let highs = (hSum / 600.0);

                root.cavaDataFetched(bass, mids, highs)
            }
        }
    }

    function defaultOutputMuted(): bool {
        if (!Pipewire.ready) return false

        if (Pipewire.defaultAudioSink)
           return Pipewire.defaultAudioSink.audio.muted

        console.warn("No default audio output")
        return false
    }

    function setDefaultOutputMuted(muted: bool) {
        if (!Pipewire.ready) return

        if (Pipewire.defaultAudioSink) {
            Pipewire.defaultAudioSink.audio.muted = muted
        } else {
            console.warn("No default audio output")
        }
    }

    function toggleDefaultOutputMuted() {
        setDefaultOutputMuted(!defaultOutputMuted())
    }

    function defaultOutputVolume(): real {
        if (!Pipewire.ready) return 0

        if (Pipewire.defaultAudioSink)
           return Pipewire.defaultAudioSink.audio.volume

        return 0
    }

    function setDefaultOutputVolume(volume: real) {
        if (!Pipewire.ready) return 0

        if (Pipewire.defaultAudioSink)
           Pipewire.defaultAudioSink.audio.volume = volume
    }

    function defaultInputMuted(): bool {
        if (!Pipewire.ready) return false

        if (Pipewire.defaultAudioSource)
           return Pipewire.defaultAudioSource.audio.muted

        return 0
    }

    function setDefaultInputMuted(muted: bool) {
        if (!Pipewire.ready) return

        if (Pipewire.defaultAudioSource) {
            Pipewire.defaultAudioSource.audio.muted = muted
        } else {
            console.warn("No default audio output")
        }
    }

    function toggleDefaultInputMuted() {
        setDefaultInputMuted(!defaultInputMuted())
    }

    function defaultInputVolume(): real {
        if (!Pipewire.ready) return 0

        if (Pipewire.defaultAudioSource)
           return Pipewire.defaultAudioSource.audio.volume

        console.warn("No default audio input")
        return 0
    }

    function setDefaultInputVolume(volume: real) {
        if (!Pipewire.ready) return 0

        if (Pipewire.defaultAudioSource)
           Pipewire.defaultAudioSource.audio.volume = volume
    }

    function increaseDefaultInputVolume(increase: real) {
        setDefaultInputVolume(defaultInputVolume() + increase)
    }
}
