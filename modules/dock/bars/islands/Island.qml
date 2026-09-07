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

    readonly property real length: Math.max(minLength, Math.min(Math.max(widgetContainer.requestedLength, panelLoader.item ? panelLoader.item.requestedLength : 0) + cornerRadius * 2, maxLength))
    readonly property real additionalSize: panelLoader.item ? panelLoader.item.requestedSize : 0

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

        onPanelRequested: (widget, panelComponent) => {
            root.showPanel(widget, panelComponent);
        }

        Component.onCompleted: setAnchoring()
    }
    property alias widgetContainer: widgetContainer

    Loader {
        id: panelLoader

        anchors.margins: 4

        anchors.top: root.position & Bar.Bottom ? parent.top : (root.position & Bar.Top ? widgetContainer.bottom : undefined);
        anchors.bottom: root.position & Bar.Top ? parent.bottom : (root.position & Bar.Bottom ? widgetContainer.top : undefined);
        anchors.left: item && item.fillSpace || root.position & Bar.Left ? parent.left : undefined;
        anchors.right: item && item.fillSpace || root.position & Bar.Right ? parent.right : undefined;

        // vertical
        // anchors.top = panel.fillSpace || root.position & Bar.Top ? panel.parent.top : undefined;
        // anchors.bottom = panel.fillSpace || root.position & Bar.Bottom ? panel.parent.bottom : undefined;
        // anchors.left = root.position & Bar.Right ? panel.parent.left : (root.position & Bar.Left ? widgetContainer.right : undefined);
        // anchors.right = root.position & Bar.Left ? panel.parent.right : (root.position & Bar.Right ? widgetContainer.left : undefined);
    }

    function showPanel(widget: Widget, panelComponent: Component) {
        if (!panelComponent)
            return;

        if (panelLoader.sourceComponent === panelComponent) {
            hidePanel();
            return;
        }

        panelLoader.sourceComponent = panelComponent;
    }

    function hidePanel() {
        panelLoader.sourceComponent = undefined;
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
