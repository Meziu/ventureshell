import QtQuick

// Anchor around an item to rotate around
Item {
    id: root
    required property Item item
    property real rotationPeriod: 1000
    property real angleFrom: 0
    property real angleTo: 360
    property int direction: RotationAnimation.Clockwise

    width: 0
    height: 0
    x: item.x + item.width / 2
    y: item.y + item.height / 2

    RotationAnimation on rotation {
        from: root.angleFrom
        to: root.angleTo
        duration: root.rotationPeriod
        loops: Animation.Infinite
        direction: root.direction
    }
}
