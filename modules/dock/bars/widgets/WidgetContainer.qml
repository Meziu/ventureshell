import QtQuick
import QtQuick.Layouts

import "../widgets"
import "../panels"

GridLayout {
    id: root
    clip: true

    anchors.margins: 4

    required property bool horizontal
    property real spacing: 10

    property real requestedLength: horizontal ? implicitWidth : implicitHeight

    signal panelRequested(widget: Widget, panel: Component)
    signal menuRequested(widget: Widget, menu: Component)

    flow: horizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom
    rows: horizontal ? 1 : widgets.length
    columns: horizontal ? widgets.length : 1

    rowSpacing: spacing
    columnSpacing: spacing

    uniformCellHeights: horizontal
    uniformCellWidths: !horizontal

    Repeater {
        model: root.widgets

        Connections {
            target: modelData // current widget

            function onPanelRequested(panel) {
                root.panelRequested(modelData, panel)
            }

            function onMenuRequested(menu) {
                root.menuRequested(modelData, menu)
            }
        }
    }
}
