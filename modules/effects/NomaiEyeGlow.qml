import QtQuick
import QtQuick.Effects

MultiEffect {
    property color eyeColor: "#6A7DFE"

    brightness: 1.0
    colorization: 1.0
    colorizationColor: eyeColor

    // glow
    shadowEnabled: true
    shadowColor: eyeColor
    shadowBlur: 0.2
    shadowScale: 1.02
    shadowHorizontalOffset: 0
    shadowVerticalOffset: 0
    shadowOpacity: 0.8
}
