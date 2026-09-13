import QtQuick
import QtQuick.Layouts

import "../widgets"
import "../panels"

GridLayout {
    id: root
    clip: true

    anchors.margins: 4

    property list<Widget> widgets
    required property bool horizontal
    property real spacing: 10

    property real requestedLength: horizontal ? implicitWidth : implicitHeight

    signal panelRequested(widget: Widget, panel: Component)
    signal menuRequested(widget: Widget, menu: Component)

    children: root.widgets

    flow: horizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom
    rows: horizontal ? 1 : root.widgets.length
    columns: horizontal ? root.widgets.length : 1

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
