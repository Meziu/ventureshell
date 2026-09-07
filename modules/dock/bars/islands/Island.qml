import QtQuick
import Quickshell

import "../../../shapes"
import "../widgets"
import "../panels"
import ".."

CurvyBox {
    id: root

    default property list<Widget> widgets

    required property real size
    required property ShellScreen screen
    required property int position
    required property bool horizontal
    property real minLength: 0
    property real maxLength: 1000

    property real transitionTime: 300

    readonly property real length: Math.max(minLength, Math.min(Math.max(widgetContainer.requestedLength, currentPanel ? currentPanel.requestedLength : 0) + cornerRadius * 2, maxLength))
    readonly property real additionalSize: currentPanel ? currentPanel.requestedSize : 0

    property WidgetContainer widgetContainer: WidgetContainer {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        anchors.margins: 4

        states: State {
            name: "halfSize"
            AnchorChanges {
                target: widgetContainer

                anchors.top: parent && (!horizontal || root.position & Bar.Top) ? parent.top : undefined
                anchors.bottom: parent && (!horizontal || root.position & Bar.Bottom) ? parent.bottom : undefined
                anchors.left: parent && (root.position & Bar.Left) ? parent.left : undefined
                anchors.right: parent && (root.position & Bar.Right) ? parent.right : undefined
                anchors.horizontalCenter: parent && horizontal ? parent.horizontalCenter : undefined
            }
        }
        function setAnchoring() {
            if (widgetContainer.parent) {
                widgetContainer.state = "halfSize"
            }
        }

        horizontal: root.horizontal

        widgets: root.widgets

        onPanelRequested: (panel, widget) => {
            root.showPanel(panel, widget);
        }

        Component.onCompleted: setAnchoring()
    }
    property Panel currentPanel: null

    function placePanel(panel, widget) {
        if (root.horizontal) {
            // extend to the top if the bar is on the bottom
            // TODO: set anchors based on the widgetContainer
            panel.anchors.top = root.position & Bar.Bottom ? panel.parent.top : undefined;
            panel.anchors.bottom = root.position & Bar.Top ? panel.parent.bottom : undefined;
            panel.anchors.left = panel.fillSpace || root.position & Bar.Left ? panel.parent.left : undefined;
            panel.anchors.right = panel.fillSpace || root.position & Bar.Right ? panel.parent.right : undefined;
            panel.anchors.margins = 4
        } else {
            panel.anchors.top = panel.fillSpace || root.position & Bar.Top ? panel.parent.top : undefined;
            panel.anchors.bottom = panel.fillSpace || root.position & Bar.Bottom ? panel.parent.bottom : undefined;
            panel.anchors.left = root.position & Bar.Right ? panel.parent.left : undefined;
            panel.anchors.right = root.position & Bar.Left ? panel.parent.right : undefined;
            panel.anchors.margins = 4
        }
    }

    function showPanel(widget: Widget, panel: Panel) {
        if (!panel)
            return;
        if (currentPanel === panel) {
            hidePanel();
            return;
        }
        currentPanel = panel;

        placePanel(currentPanel, widget);
    }

    function hidePanel() {
        currentPanel = null;
    }

    width: horizontal ? length : size + additionalSize
    height: !horizontal ? length : size + additionalSize
    avoidCornersHorizontally: horizontal
    contentChildren: [widgetContainer, currentPanel]

    Behavior on width {
        NumberAnimation {
            duration: transitionTime
            easing.type: Easing.OutCubic
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: transitionTime
            easing.type: Easing.OutCubic
        }
    }
}
