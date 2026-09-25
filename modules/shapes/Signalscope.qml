import QtQuick
import Quickshell

import "../services"

Item {
    id: root
    width: 400
    height: 200

    property real bass: 0
    property real mids: 0
    property real highs: 0

    property real phase: 0.0

    readonly property color waveColor: "#4cc9f0"    // Bright signal cyan
    readonly property color glowColor: "#2a7590"    // Deep wave glow

    Connections {
        target: AudioService

        function onCavaDataFetched(bass: real, mids: real, highs: real) {
            root.bass = bass
            root.mids = mids
            root.highs = highs
            scopeCanvas.requestPaint();
        }
    }

    // Phase animation timer (~60 FPS fallback/drive)
    NumberAnimation on phase {
        from: 0
        to: Math.PI * 2
        duration: 2000
        loops: Animation.Infinite
        running: true
    }

    Canvas {
        id: scopeCanvas
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            let ctx = getContext("2d");
            let w = width;
            let h = height;
            let centerY = h / 2;

            ctx.clearRect(0, 0, w, h);

            let points = 80; // Small point count keeps CPU usage minimal
            let step = w / points;

            // Composite Wave Function (Outer Wilds Style Summation)
            function getWaveY(x) {
                let normX = (x / w) * Math.PI * 2;

                let waveBass = Math.sin(normX * 1.5 + root.phase) * (root.bass * h * 0.35);

                let waveMids = Math.sin(normX * 4.0 - root.phase * 2.0) * (root.mids * h * 0.20);

                let waveHighs = Math.sin(normX * 12.0 + root.phase * 4.0) * (root.highs * h * 0.15);

                return centerY + waveBass + waveMids + waveHighs;
            }

            ctx.strokeStyle = root.glowColor;
            ctx.lineWidth = 4;
            ctx.beginPath();
            ctx.moveTo(0, getWaveY(0));
            for (let i = 1; i <= points; i++) {
                let x = i * step;
                ctx.lineTo(x, getWaveY(x));
            }
            ctx.stroke();

            ctx.strokeStyle = root.waveColor;
            ctx.lineWidth = 1.5;
            ctx.beginPath();
            ctx.moveTo(0, getWaveY(0));
            for (let i = 1; i <= points; i++) {
                let x = i * step;
                ctx.lineTo(x, getWaveY(x));
            }
            ctx.stroke();

            ctx.strokeStyle = root.glowColor;
            ctx.lineWidth = 3;
            ctx.beginPath();
            ctx.moveTo(1, 0); // 2 to avoid cutting off the line from the canvas
            ctx.lineTo(1, h);
            ctx.moveTo(w-1, 0);
            ctx.lineTo(w-1, h);
            ctx.stroke();

            ctx.strokeStyle = root.waveColor;
            ctx.lineWidth = 1.5;
            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.lineTo(0, h);
            ctx.moveTo(w-1, 0);
            ctx.lineTo(w-1, h);
            ctx.stroke();
        }
    }
}
