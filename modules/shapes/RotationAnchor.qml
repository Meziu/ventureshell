import QtQuick

// Anchor around an item to rotate around
Item {
    id: root
    required property Item item

    width: 0
    height: 0
    x: item.x + item.width / 2
    y: item.y + item.height / 2
}
