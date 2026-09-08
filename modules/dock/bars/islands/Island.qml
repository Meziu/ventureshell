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
    required property bool widgetsFillIsland
    property real minLength: 0
    property real maxLength: 1000

    readonly property bool isTop: (root.position & Bar.Top) !== 0
    readonly property bool isBottom: (root.position & Bar.Bottom) !== 0
    readonly property bool isLeft: (root.position & Bar.Left) !== 0
    readonly property bool isRight: (root.position & Bar.Right) !== 0
    readonly property bool isHCenter: !(root.position & Bar.Left) && !(root.position & Bar.Right)
    readonly property bool isVCenter: !(root.position & Bar.Top) && !(root.position & Bar.Bottom)

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

        horizontal: root.horizontal
        widgets: root.widgets

        onPanelRequested: (widget, panelComponent) => {
            root.showPanel(widget, panelComponent);
        }

        states: [
            State {
                name: "filled"
                AnchorChanges {
                    target: widgetContainer

                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right
                    }
                }
            },
            State {
                name: "locked"
                AnchorChanges {
                    target: widgetContainer

                    anchors.top: isTop || (!horizontal && widgetsFillIsland) ? parent.top : undefined
                    anchors.bottom: isBottom || (!horizontal && widgetsFillIsland) ? parent.bottom : undefined
                    anchors.left: isLeft || (horizontal && widgetsFillIsland) ? parent.left : undefined
                    anchors.right: isRight || (horizontal && widgetsFillIsland) ? parent.right : undefined
                    anchors.horizontalCenter: horizontal && isHCenter && (!widgetsFillIsland) ? parent.horizontalCenter : undefined
                    anchors.verticalCenter: !horizontal && isVCenter && (!widgetsFillIsland) ? parent.verticalCenter : undefined
                }
            }
        ]
    }
    property alias widgetContainer: widgetContainer

    /* Debug Rectangle
    Rectangle {
        anchors.fill: widgetContainer

        opacity: 0.1
    }*/

    Loader {
        id: panelLoader

        readonly property bool fillSpace: item && item.fillSpace

        anchors {
            margins: 4

            top: root.horizontal ? (isBottom ? parent.top : widgetContainer.bottom) : ((fillSpace || isTop) ? parent.top : undefined)
            bottom: root.horizontal ? (isTop ? parent.bottom : widgetContainer.top) : ((fillSpace || isBottom) ? parent.bottom : undefined)
            left: !root.horizontal ? (isRight ? parent.left : widgetContainer.right) : ((fillSpace || isLeft) ? parent.left : undefined)
            right: !root.horizontal ? (isLeft ? parent.right : widgetContainer.left) : ((fillSpace || isRight) ? parent.right : undefined)
        }

        onLoaded: {
            panelLoader.item.exited.connect(() => {
                root.hidePanel()
            })
        }
    }

    function showPanel(widget: Widget, panelComponent: Component) {
        if (!panelComponent)
            return;

        if (panelLoader.sourceComponent === panelComponent) {
            hidePanel();
            return;
        }

        widgetContainer.state = "locked"

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
