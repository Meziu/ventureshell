import QtQuick

import "../shapes"

/*
  A single body (planet, moon, station...) placed a fixed distance
  from `item`'s center, free to orbit it.

  How the orbit actually happens:
  - RotationAnchor (the base type) already tracks `item`'s center
    position every frame and reports it via x/y.
  - This component also inherits Item's native `rotation` property.
    Rotating the anchor swings everything positioned relative to it
    around that tracked center point — that IS the orbit. Drive
    `rotation` with a clock expression (+ SmoothRotation) or with
    ContinuousSpin to make the body move.

  Composition slots:
  - Declaring content directly inside an OrbitingBody (no property
    name) makes it a SIBLING of the body image — this is how a moon
    orbits a planet: `OrbitingBody { item: parentOrbit.body ... }`.
    This matters structurally: an orbit anchor must never be
    parented to the body it's tracking, or its position math
    (item.mapToItem(parent, ...)) becomes degenerate.
  - `bodyChildren` is a separate, explicit slot for plain visuals
    parented to the image itself, simply inheriting its rotation
    (e.g. two moons fixed to opposite ends of a spinning pivot).
    Use this only when independent orbit-tracking isn't needed.
  - `body` exposes the image directly, for animations or nested
    orbits that need to reference it by id.
*/
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
