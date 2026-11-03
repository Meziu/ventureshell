pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property PwNode defaultAudioSink: Pipewire.defaultAudioSink
    readonly property PwNode defaultAudioSource: Pipewire.defaultAudioSource
    readonly property list<PwNode> outputDevices: Pipewire.nodes.values.filter(n => n.audio && !n.isStream && n.isSink)
    readonly property list<PwNode> inputDevices: Pipewire.nodes.values.filter(n => n.audio && !n.isStream && !n.isSink)
    readonly property list<PwNode> outputStreams: Pipewire.nodes.values.filter(n => n.audio && n.isStream && n.isSink)

    PwObjectTracker {
        objects: [root.defaultAudioSink, root.defaultAudioSource]
    }
    PwObjectTracker {
        objects: root.outputStreams
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

                root.cavaDataFetched(bass, mids, highs);
            }
        }
    }

    function nodeMuted(node: PwNode): bool {
        if (!Pipewire.ready)
            return false;

        if (node && node.audio)
            return node.audio.muted;

        console.warn("No audio node");
        return false;
    }

    function setNodeMuted(node: PwNode, muted: bool) {
        if (!Pipewire.ready)
            return;

        if (node && node.audio)
            node.audio.muted = muted;
        else
            console.warn("No audio node");
    }

    function toggleNodeMuted(node: PwNode) {
        setNodeMuted(node, !nodeMuted(node));
    }

    function nodeVolume(node: PwNode): real {
        if (!Pipewire.ready)
            return 0;

        if (node && node.audio)
            return node.audio.volume;

        console.warn("No audio node");
        return 0;
    }

    function setNodeVolume(node: PwNode, volume: real) {
        if (!Pipewire.ready)
            return;

        if (node && node.audio)
            node.audio.volume = volume;
        else
            console.warn("No audio node");
    }

    function increaseNodeVolume(node: PwNode, increase: real) {
        setNodeVolume(node, nodeVolume(node) + increase);
    }

    function defaultOutputMuted(): bool {
        return nodeMuted(root.defaultAudioSink);
    }

    function setDefaultOutputMuted(muted: bool) {
        setNodeMuted(root.defaultAudioSink, muted);
    }

    function toggleDefaultOutputMuted() {
        toggleNodeMuted(root.defaultAudioSink);
    }

    function defaultOutputVolume(): real {
        return nodeVolume(root.defaultAudioSink);
    }

    function setDefaultOutputVolume(volume: real) {
        setNodeVolume(root.defaultAudioSink, volume);
    }

    function increaseDefaultOutputVolume(increase: real) {
        increaseNodeVolume(root.defaultAudioSink, increase);
    }

    function defaultInputMuted(): bool {
        return nodeMuted(root.defaultAudioSource);
    }

    function setDefaultInputMuted(muted: bool) {
        setNodeMuted(root.defaultAudioSource, muted);
    }

    function toggleDefaultInputMuted() {
        toggleNodeMuted(root.defaultAudioSource);
    }

    function defaultInputVolume(): real {
        return nodeVolume(root.defaultAudioSource);
    }

    function setDefaultInputVolume(volume: real) {
        setNodeVolume(root.defaultAudioSource, volume);
    }

    function increaseDefaultInputVolume(increase: real) {
        increaseNodeVolume(root.defaultAudioSource, increase);
    }

    function setDefaultOutputDevice(node: PwNode) {
        Pipewire.preferredDefaultAudioSink = node
    }

    function setDefaultInputDevice(node: PwNode) {
        Pipewire.preferredDefaultAudioSource = node
    }

    function nodeLabel(node: PwNode): string {
        const p = node.properties;

        return p["media.name"] || node.nickname || node.description || node.name
    }

    function nodeIcon(node: PwNode): string {
        const fallback = "application-x-executable";
        if (!node)
            return fallback;

        const p = node.properties;

        if (p["application.icon-name"])
            return p["application.icon-name"];

        const candidates = [
            p["application.process.binary"],
            p["application.name"],
            node.nickname,
            node.name
        ];
        for (const c of candidates) {
            if (!c)
                continue;
            const entry = DesktopEntries.heuristicLookup(c);
            if (entry && entry.icon)
                return entry.icon;
        }

        return fallback;
    }
}
