import QtQuick
import QtQuick.Layouts 1.3

import "../widgets"
import "../panels"

GridLayout {
    id: root
    clip: true

    default property list<Widget> widgets
    property bool horizontal: true
    property real spacing: 10
    property real requestedLength: {
        let sum = 0;

        for (let i = 0; i < widgets.length; i++) {
            if (widgets[i].requestedLength) {
                sum += widgets[i].requestedLength + spacing;
            }
        }

        return sum
    }

    signal panelRequested(widget: Widget, panel: Component)

    rows: root.horizontal ? 1 : widgets.length
    columns: root.horizontal ? widgets.length : 1

    rowSpacing: spacing
    columnSpacing: spacing

    children: widgets

    onWidgetsChanged: syncWidgets()

    function syncWidgets() {
        for (let i = 0; i < widgets.length; i++) {
            const w = widgets[i]
            w.Layout.row = Qt.binding(() => root.horizontal ? 0 : i)
            w.Layout.column = Qt.binding(() => root.horizontal ? i : 0)
            w.panelRequested.connect(pc => panelRequested(w, pc))
        }
    }
}
