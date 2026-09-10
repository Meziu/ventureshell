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

    readonly property bool isTop: (root.position & Position.Top) !== 0
    readonly property bool isBottom: (root.position & Position.Bottom) !== 0
    readonly property bool isLeft: (root.position & Position.Left) !== 0
    readonly property bool isRight: (root.position & Position.Right) !== 0
    readonly property bool isHCenter: !(root.position & Position.Left) && !(root.position & Position.Right)
    readonly property bool isVCenter: !(root.position & Position.Top) && !(root.position & Position.Bottom)

    property real transitionTime: 200

    protrusionSide: Position.opposite(Position.cardinal(position, horizontal))

    // Enables position behavior ONLY during menu-to-menu switching
    property bool animateProtrusionPosition: false

    // Orientation-aware dimension mapping for Panel and Menu
    readonly property real panelMainLength: panelLoader.item ? (horizontal ? panelLoader.item.requestedLength : panelLoader.item.requestedSize) : 0
    readonly property real panelCrossSize: panelLoader.item ? (horizontal ? panelLoader.item.requestedSize : panelLoader.item.requestedLength) : 0

    readonly property real menuMainLength: menuLoader.item ? (horizontal ? menuLoader.requestedLength : menuLoader.requestedSize) : 0
    readonly property real menuCrossSize: menuLoader.item ? (horizontal ? menuLoader.requestedSize : menuLoader.requestedLength) : 0

    property real currentTargetCenter: 0
    property real additionalLength: 0

    // Calculates ideal menu center point constrained within island bounds
    function calculateTargetCenter(currentMenuWidget: Widget): real {
        const wPos = root.horizontal
            ? (widgetContainer.x + currentMenuWidget.x + currentMenuWidget.width / 2)
            : (widgetContainer.y + currentMenuWidget.y + currentMenuWidget.height / 2);

        const halfLen = root.menuMainLength / 2;
        return Math.max(halfLen, Math.min(wPos, root.length - halfLen));
    }

    // Calculates baseline deficit to expand island length symmetrically without binding loops
    function calculateAdditionalLength(currentMenuWidget: Widget): real {
        if (!menuLoader.item || !currentMenuWidget) return 0;

        const baseLen = Math.max(widgetContainer.requestedLength, panelMainLength);

        let containerOffset = 0;
        if (root.horizontal) {
            if (root.isRight) containerOffset = baseLen - widgetContainer.width;
            else if (root.isHCenter) containerOffset = (baseLen - widgetContainer.width) / 2;
        } else {
            if (root.isBottom) containerOffset = baseLen - widgetContainer.height;
            else if (root.isVCenter) containerOffset = (baseLen - widgetContainer.height) / 2;
        }

        const localWPos = root.horizontal
            ? (currentMenuWidget.x + currentMenuWidget.width / 2)
            : (currentMenuWidget.y + currentMenuWidget.height / 2);
        const wPos = containerOffset + localWPos;

        const halfMenu = menuMainLength / 2;
        const startDeficit = Math.max(0, halfMenu - wPos);
        const endDeficit = Math.max(0, (wPos + halfMenu) - baseLen);

        return startDeficit + endDeficit;
    }

    readonly property real additionalSize: panelCrossSize

    readonly property real baseMainLength: Math.max(
        widgetContainer.requestedLength,
        panelMainLength
    )

    readonly property real length: Math.max(
        minLength,
        Math.min(
            baseMainLength + additionalLength + cornerRadius * 2,
            maxLength
        )
    )

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

        onMenuRequested: (widget, menuComponent) => {
            root.showMenu(widget, menuComponent);
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
                root.hidePanel();
            });
        }
    }

    function showPanel(widget: Widget, panelComponent: Component) {
        if (!panelComponent)
            return;

        if (panelLoader.sourceComponent === panelComponent) {
            hidePanel();
            return;
        }

        widgetContainer.state = "locked";

        panelLoader.sourceComponent = panelComponent;
    }

    function hidePanel() {
        panelLoader.sourceComponent = undefined;
    }

    protrusionContent: Loader {
        id: menuLoader

        anchors.fill: parent

        // Dynamically anchors the start coordinate relative to the currently animating length L(t)
        property real requestedPosition: {
            const currentLen = root.protrusionLength;
            const center = root.currentTargetCenter;

            return center - (currentLen / 2);
        }

        property real requestedLength: menuLoader.item ? menuLoader.item.implicitWidth : 0
        property real requestedSize: menuLoader.item ? menuLoader.item.implicitHeight : 0

        onLoaded: {
            menuLoader.item.exited.connect(() => {
                root.hideMenu();
            });
        }
    }

    function showMenu(widget: Widget, menuComponent: Component) {
        if (!menuComponent)
            return;

        if (menuLoader.sourceComponent === menuComponent) {
            hideMenu();
            return;
        }

        widgetContainer.state = "locked";

        // Animate position along edge only when switching between already open menus
        animateProtrusionPosition = (menuLoader.item !== null);

        currentTargetCenter = Qt.binding(() => calculateTargetCenter(widget))
        additionalLength = Qt.binding(() => calculateAdditionalLength(widget))
        menuLoader.sourceComponent = menuComponent;
    }

    function hideMenu() {
        animateProtrusionPosition = false;
        menuLoader.sourceComponent = undefined;
    }

    function hideAdditionalContent() {
        hidePanel();
        hideMenu();
    }

    width: horizontal ? length : size + additionalSize
    height: !horizontal ? length : size + additionalSize
    cornerMarginsHorizontal: horizontal

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
    Behavior on protrusionPosition {
        enabled: root.animateProtrusionPosition
        NumberAnimation {
            duration: transitionTime
            easing.type: Easing.OutCubic
        }
    }
    Behavior on protrusionLength {
        NumberAnimation {
            duration: transitionTime
            easing.type: Easing.OutCubic
        }
    }
    Behavior on protrusionDepth {
        NumberAnimation {
            duration: transitionTime
            easing.type: Easing.OutCubic
        }
    }
}
