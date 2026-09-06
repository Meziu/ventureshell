import QtQuick
import QtQuick.Layouts

import "../widgets"
import "../panels"

GridLayout {
    id: root
    anchors.fill: parent
    anchors.margins: 4
    clip: true

    default property list<Widget> widgets
    property Panel currentPanel: null

    property bool horizontal: true
    property real spacing: 10

    rows: root.horizontal ? 2 : widgets.length
    columns: root.horizontal ? widgets.length : 2

    rowSpacing: spacing
    columnSpacing: spacing

    property real requestedLength: {
        let sum = 0;

        for (let i = 0; i < widgets.length; i++) {
            if (widgets[i].requestedLength) {
                sum += widgets[i].requestedLength + spacing;
            }
        }

        return sum;
    }

    // Size requested beyond the bar size
    property real requestedAdditionalSize: currentPanel ? currentPanel.requestedSize : 0

    function placePanel(panel, widget) {
        panel.Layout.rowSpan = Qt.binding(() => panel.fillSpace ? root.rows : 1)
        panel.Layout.columnSpan = Qt.binding(() => panel.fillSpace ? root.columns : 1)

        panel.Layout.row = Qt.binding(() => horizontal ? 1 : widget.Layout.row)
        panel.Layout.column = Qt.binding(() => horizontal ? widget.Layout.column : 1)
    }

    function showPanel(widget: Widget, panel: Panel) {
        if (!panel) return;

        if (currentPanel === panel) {
            hidePanel();
            return;
        }
        if (currentPanel) currentPanel.parent = null;

        currentPanel = panel;
        currentPanel.parent = root;
        placePanel(currentPanel, widget); // reuses the anchor-based placement from before
    }

    function hidePanel() {
        if (currentPanel) currentPanel.parent = null;
        currentPanel = null;
    }

    onWidgetsChanged: syncWidgets()
    Component.onCompleted: syncWidgets()

    function syncWidgets() {
        for (let i = 0; i < widgets.length; i++) {
            const w = widgets[i];
            w.parent = root;
            w.Layout.row = Qt.binding(() => root.horizontal ? 0 : i);
            w.Layout.column = Qt.binding(() => root.horizontal ? i : 0);
            w.panelRequested.connect((p) => showPanel(w, p));
        }
    }
}
