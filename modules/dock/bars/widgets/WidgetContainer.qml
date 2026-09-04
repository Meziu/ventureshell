import QtQuick
import QtQuick.Layouts

GridLayout {
    id: root
    anchors.fill: parent
    anchors.margins: 4
    clip: true

    property bool horizontal: true
    property real spacing: 10

    rowSpacing: spacing
    columnSpacing: spacing

    rows: horizontal ? 1 : -1
    columns: horizontal ? -1 : 1

    property real requestedLength: {
        let sum = 0;

        for (let i = 0; i < children.length; i++) {
            if (children[i].requestedLength) {
                sum += children[i].requestedLength + spacing;
            }
        }

        return sum;
    }
}
