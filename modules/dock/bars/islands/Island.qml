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

    WidgetContainer {
        id: widgetContainer
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

                anchors.top: (!horizontal || root.position & Bar.Top) ? parent.top : undefined
                anchors.bottom: (!horizontal || root.position & Bar.Bottom) ? parent.bottom : undefined
                anchors.left: (root.position & Bar.Left) ? parent.left : undefined
                anchors.right: (root.position & Bar.Right) ? parent.right : undefined
                anchors.horizontalCenter: horizontal ? parent.horizontalCenter : undefined
            }
        }
        function setAnchoring() {
            if (widgetContainer.parent) {
                widgetContainer.state = "halfSize"
            }
        }

        horizontal: root.horizontal

        widgets: root.widgets

        onPanelRequested: (widget, panel) => {
            root.showPanel(widget, panel);
        }

        Component.onCompleted: setAnchoring()
    }
    property alias widgetContainer: widgetContainer
    property Panel currentPanel: null

    function placePanel(panel, widget) {
        panel.anchors.margins = 4

        if (root.horizontal) {
            // extend to the top if the bar is on the bottom
            panel.anchors.top = root.position & Bar.Bottom ? panel.parent.top : (root.position & Bar.Top ? widgetContainer.bottom : undefined);
            panel.anchors.bottom = root.position & Bar.Top ? panel.parent.bottom : (root.position & Bar.Bottom ? widgetContainer.top : undefined);
            panel.anchors.left = panel.fillSpace || root.position & Bar.Left ? panel.parent.left : undefined;
            panel.anchors.right = panel.fillSpace || root.position & Bar.Right ? panel.parent.right : undefined;
        } else {
            panel.anchors.top = panel.fillSpace || root.position & Bar.Top ? panel.parent.top : undefined;
            panel.anchors.bottom = panel.fillSpace || root.position & Bar.Bottom ? panel.parent.bottom : undefined;
            panel.anchors.left = root.position & Bar.Right ? panel.parent.left : (root.position & Bar.Left ? widgetContainer.right : undefined);
            panel.anchors.right = root.position & Bar.Left ? panel.parent.right : (root.position & Bar.Right ? widgetContainer.left : undefined);
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

        currentPanel.parent = root.contentItem

        placePanel(currentPanel, widget);
    }

    function hidePanel() {
        currentPanel.parent = null
        currentPanel = null;
    }

    width: horizontal ? length : size + additionalSize
    height: !horizontal ? length : size + additionalSize
    avoidCornersHorizontally: horizontal


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
