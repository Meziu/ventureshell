pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
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
}
