import QtQuick

import "../shapes"

RotationAnchor {
    id: root

    property real orbitDistance: 0
    property real size: 40
    property real imageScale: 1
    property alias imageRotation: image.rotation
    property alias source: image.source

    // The visual body itself.
    property alias body: image

    // Plain content parented directly to the body image (see note above).
    property alias bodyChildren: image.data

    Image {
        id: image
        fillMode: Image.PreserveAspectFit
        width: root.size
        height: root.size
        scale: root.imageScale

        // `orbitDistance` out from the edge of `item`, along the
        // anchor's local +x axis. The anchor's own `rotation` is what
        // carries this point around in a circle.
        x: root.item ? root.item.width / 2 + root.orbitDistance - width / 2 : 0
        y: -height / 2
    }
}
