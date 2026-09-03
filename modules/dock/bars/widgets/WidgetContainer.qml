import QtQuick
import QtQuick.Layouts

GridLayout {
    id: root
    anchors.fill: parent

    property bool horizontal: true
    property real spacing: 10

    rows: horizontal ? 1 : -1
    columns: horizontal ? -1 : 1

    property real requestedLength: {
        let sum = spacing;

        for (let i = 0; i < children.length; i++) {
            if (children[i].requestedLength) {
                sum += children[i].requestedLength;
            }
        }

        return sum;
    }
}
