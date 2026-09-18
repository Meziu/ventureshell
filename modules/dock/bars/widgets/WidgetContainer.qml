import QtQuick
import QtQuick.Layouts

GridLayout {
    id: root
    clip: true
    anchors.margins: root.margins

    required property bool horizontal
    property real spacing: 4
    property real margins: 4

    property real requestedLength: (horizontal ? implicitWidth : implicitHeight) + margins * 2

    signal popupRequested(widget: Widget, popup: Component)

    default property alias widgets: root.data

    flow: horizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom
    rows: horizontal ? 1 : Math.max(1, root.visibleChildren.length)
    columns: horizontal ? Math.max(1, root.visibleChildren.length) : 1

    rowSpacing: spacing
    columnSpacing: spacing

    uniformCellHeights: horizontal
    uniformCellWidths: !horizontal

    // Fully declarative signal wiring for all visible children
    Instantiator {
        model: root.visibleChildren

        Connections {
            required property var modelData
            target: modelData

            // Connect when possible
            ignoreUnknownSignals: true

            function onPopupRequested(panel) {
                root.popupRequested(modelData, panel)
            }
        }
    }
}
