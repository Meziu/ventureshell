pragma Singleton

import QtQuick
import QtQuick.Shapes
import Quickshell

import "../gradients"

Singleton {
    id: theme

    readonly property color nomaiColor: "#6A7DFE"

    readonly property QtObject text: QtObject {
        readonly property color accentColor: "#F28B2C"
        readonly property color lightColor: "#F5EAD9"
        readonly property color darkColor: "#2A1B12"
        readonly property color placeholderColor: "gray"
        readonly property color failedInputColor: "red" // used for password fields and others that can fail input
        readonly property color signalscopeColor: "#ADE1E5"
    }

    readonly property QtObject shapes: QtObject {
        readonly property QtObject curvyBox: QtObject {
            readonly property color fillColor: "#9C4A1C"
            readonly property color borderColor: Qt.rgba(250 / 255, 179 / 255, 135 / 255, 0.28)
            readonly property Component fillGradient: RustyMetal {}
        }

        readonly property QtObject signalscope: QtObject {
            readonly property color waveColor: "#4cc9f0" // Bright signal cyan
            readonly property color glowColor: "#2a7590" // Deep wave glow
            readonly property color screenBorderColor: "#4E5065"
            readonly property color screenColor: "#242E37"
        }

        readonly property QtObject radialSlice: QtObject {
            readonly property color baseColor: theme.nomaiColor
        }

        readonly property QtObject menuSeparator: QtObject {
            readonly property color baseColor: "white"
        }

        readonly property QtObject completionCircle: QtObject {
            readonly property color baseColor: theme.text.lightColor
        }
    }
}
