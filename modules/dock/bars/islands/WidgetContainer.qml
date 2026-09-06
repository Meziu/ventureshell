import QtQuick
import QtQuick.Layouts 1.3

import "../widgets"
import "../panels"

GridLayout {
    id: root
    anchors.fill: parent
    anchors.margins: 4
    clip: true

    default property list<Widget> widgets
    property Panel currentPanel: null//LauncherPanel { Layout.row: 1; Layout.column: 0; Layout.columnSpan: root.columns }

    property bool horizontal: true
    property real spacing: 10

    rows: root.horizontal ? 2 : widgets.length
    columns: root.horizontal ? widgets.length : 2

    rowSpacing: spacing
    columnSpacing: spacing

    children: [...widgets, currentPanel]

    property real requestedLength: {
        let sum = 0;

        for (let i = 0; i < widgets.length; i++) {
            if (widgets[i].requestedLength) {
                sum += widgets[i].requestedLength + spacing;
            }
        }

        if (currentPanel) {
            return Math.max(sum, currentPanel.requestedLength);
        } else {
            return sum;
        }
    }
    // Size requested beyond the bar size
    property real requestedAdditionalSize: currentPanel ? currentPanel.requestedSize + spacing : 0

    function placePanel(panel, widget) {
        if (root.horizontal) {
            panel.Layout.row = 1;
            panel.Layout.column = Qt.binding(() => panel.fillSpace ? 0 : widget.Layout.column);
            panel.Layout.columnSpan = Qt.binding(() => panel.fillSpace ? root.columns : 1);
        } else {
            panel.Layout.column = 1;
            panel.Layout.row = Qt.binding(() => panel.fillSpace ? 0 : widget.Layout.row);
            panel.Layout.rowSpan = Qt.binding(() => panel.fillSpace ? root.rows : 1);
        }
    }

    function showPanel(widget: Widget, panel: Panel) {
        if (!panel)
            return

        if (currentPanel === panel) {
            hidePanel()
            return
        }
        currentPanel = panel

        placePanel(currentPanel, widget)
    }

    function hidePanel() {
        if (currentPanel)
            currentPanel.parent = null
        currentPanel = null
    }

    onWidgetsChanged: syncWidgets()

    function syncWidgets() {
        for (let i = 0; i < widgets.length; i++) {
            const w = widgets[i]
            w.Layout.row = Qt.binding(() => root.horizontal ? 0 : i)
            w.Layout.column = Qt.binding(() => root.horizontal ? i : 0)
            w.panelRequested.connect(p => showPanel(w, p))
        }
    }
}
