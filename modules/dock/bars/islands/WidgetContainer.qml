import QtQuick
import QtQuick.Layouts

import "../widgets"
import "../panels"

GridLayout {
    id: root
    clip: true

    anchors.margins: 4

    default property list<Widget> widgets
    property bool horizontal: true
    property real spacing: 10

    property real requestedLength: horizontal ? implicitWidth : implicitHeight

    signal panelRequested(widget: Widget, panel: Component)
    signal menuRequested(widget: Widget, menu: Component)

    rows: root.horizontal ? 1 : widgets.length
    columns: root.horizontal ? widgets.length : 1

    rowSpacing: spacing
    columnSpacing: spacing
    children: widgets

    uniformCellHeights: horizontal
    uniformCellWidths: !horizontal

    function syncWidgets() {
        for (let i = 0; i < widgets.length; i++) {
            const w = widgets[i]
            w.Layout.row = Qt.binding(() => root.horizontal ? 0 : i)
            w.Layout.column = Qt.binding(() => root.horizontal ? i : 0)
            w.panelRequested.connect(pc => panelRequested(w, pc))
            w.menuRequested.connect(mc => menuRequested(w, mc))
        }
    }

    onWidgetsChanged: syncWidgets()
}
