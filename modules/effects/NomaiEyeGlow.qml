import QtQuick
import QtQuick.Effects

import "../theme"

MultiEffect {
    property color eyeColor: Theme.nomaiColor

    brightness: 1.0
    colorization: 1.0
    colorizationColor: eyeColor

    // glow
    shadowEnabled: true
    shadowColor: eyeColor
    shadowBlur: 0.2
    shadowScale: 1.0
    shadowHorizontalOffset: 0
    shadowVerticalOffset: 0
    shadowOpacity: 0.8
}
