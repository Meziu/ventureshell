import QtQuick

// Anchor around an item to rotate around
Item {
    id: root
    required property Item item

    width: 0
    height: 0

    FrameAnimation {
        running: root.item !== null
        onTriggered: {
            if (root.item) {
                const p = root.item.mapToItem(root.parent, root.item.width / 2, root.item.height / 2);
                root.x = p.x;
                root.y = p.y;
            }
        }
    }
}
