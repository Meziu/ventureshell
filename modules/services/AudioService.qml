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

    function defaultOutputVolume(): real {
        if (!Pipewire.ready) return 0

        if (Pipewire.defaultAudioSink)
           return Pipewire.defaultAudioSink.audio.volume

        return 0
    }

    function defaultInputMuted(): bool {
        if (!Pipewire.ready) return false

        if (Pipewire.defaultAudioSource)
           return Pipewire.defaultAudioSource.audio.muted

        return 0
    }

    function defaultInputVolume(): real {
        if (!Pipewire.ready) return 0

        if (Pipewire.defaultAudioSource)
           return Pipewire.defaultAudioSource.audio.volume

        console.warn("No default audio input")
        return 0
    }
}
