pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import "../config"

Singleton {
    id: root

    property real cpu: 0
    property real ram: 0
    property real storage: 0

    property real cpuPollTimeMs: 1000
    property real diskPollTimeMs: 30000

    property real _lastTotal: 0
    property real _lastIdle: 0

    FileView {
        id: statFile
        path: "/proc/stat"
        onLoaded: {
            const f = text().split("\n")[0].trim().split(/\s+/).slice(1).map(Number);
            if (f.length < 8)
                return;
            const idle = f[3] + f[4];                               // idle + iowait
            const total = f.slice(0, 8).reduce((a, b) => a + b, 0); // user..steal
            const dTotal = total - root._lastTotal;
            const dIdle = idle - root._lastIdle;

            if (root._lastTotal > 0 && dTotal > 0)
                root.cpu = 1 - dIdle / dTotal;

            root._lastTotal = total;
            root._lastIdle = idle;
        }
    }

    FileView {
        id: memFile
        path: "/proc/meminfo"
        onLoaded: {
            const mem = text();
            const totalMatch = mem.match(/MemTotal:\s+(\d+)/);
            const availMatch = mem.match(/MemAvailable:\s+(\d+)/);
            if (!totalMatch || !availMatch)
                return;
            root.ram = 1 - Number(availMatch[1]) / Number(totalMatch[1]);
        }
    }

    Process {
        id: dfProc
        command: ["df", "--output=used,avail", "-B1", "/"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                if (lines.length < 2)
                    return;
                const [used, avail] = lines[1].trim().split(/\s+/).map(Number);
                root.storage = used / (used + avail);
            }
        }
    }

    Timer {
        interval: root.cpuPollTimeMs
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            statFile.reload();
            memFile.reload();
        }
    }

    Timer {
        interval: root.diskPollTimeMs
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: dfProc.running = true
    }

    function viewSystemInfoCPU() {
        Quickshell.execDetached(Config.options.widgets.systemInfo.commands.viewCPU);
    }
    function viewSystemInfoRAM() {
        Quickshell.execDetached(Config.options.widgets.systemInfo.commands.viewRAM);
    }
    function viewSystemInfoStorage() {
        Quickshell.execDetached(Config.options.widgets.systemInfo.commands.viewStorage);
    }
}
