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
        anchors.margins: 4
        anchors.fill: parent

        /*anchors.top: root.horizontal ? (isBottom ? parent.top : widgetContainer.bottom) : ((fillSpace || isTop) ? parent.top : undefined)
        anchors.bottom: root.horizontal ? (isTop ? parent.bottom : widgetContainer.top) : ((fillSpace || isBottom) ? parent.bottom : undefined)
        anchors.left: !root.horizontal ? (isRight ? parent.left : widgetContainer.right) : ((fillSpace || isLeft) ? parent.left : undefined)
        anchors.right: !root.horizontal ? (isLeft ? parent.right : widgetContainer.left) : ((fillSpace || isRight) ? parent.right : undefined)*/

        horizontal: root.horizontal
        widgets: root.widgets

        onPanelRequested: (widget, panelComponent) => {
            root.showPanel(widget, panelComponent);
        }

        Component.onCompleted: {
            width = parent.width - (anchors.margins * 2);
            height = parent.height - (anchors.margins * 2);
        }
    }
    property alias widgetContainer: widgetContainer

    Loader {
        id: panelLoader

        readonly property bool isTop: (root.position & Bar.Top) !== 0
        readonly property bool isBottom: (root.position & Bar.Bottom) !== 0
        readonly property bool isLeft: (root.position & Bar.Left) !== 0
        readonly property bool isRight: (root.position & Bar.Right) !== 0

        readonly property bool fillSpace: item && item.fillSpace

        anchors {
            margins: 4

            top: root.horizontal ? (isBottom ? parent.top : widgetContainer.bottom) : ((fillSpace || isTop) ? parent.top : undefined)
            bottom: root.horizontal ? (isTop ? parent.bottom : widgetContainer.top) : ((fillSpace || isBottom) ? parent.bottom : undefined)
            left: !root.horizontal ? (isRight ? parent.left : widgetContainer.right) : ((fillSpace || isLeft) ? parent.left : undefined)
            right: !root.horizontal ? (isLeft ? parent.right : widgetContainer.left) : ((fillSpace || isRight) ? parent.right : undefined)
        }
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
