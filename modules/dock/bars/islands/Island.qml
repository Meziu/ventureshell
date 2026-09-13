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
        const wPos = root.horizontal ? (widgetContainer.x + currentMenuWidget.x + currentMenuWidget.width / 2) : (widgetContainer.y + currentMenuWidget.y + currentMenuWidget.height / 2);

        const halfLen = root.menuMainLength / 2;
        return Math.max(halfLen, Math.min(wPos, root.length - halfLen));
    }

    // Calculates length expansion respecting attached/bounded edge constraints
    function calculateAdditionalLength(currentMenuWidget: Widget): real {
        if (!menuLoader.item || !currentMenuWidget)
            return 0;

        const baseLen = Math.max(widgetContainer.requestedLength, panelMainLength);

        let containerOffset = 0;
        if (root.horizontal) {
            if (root.isRight)
                containerOffset = baseLen - widgetContainer.width;
            else if (root.isHCenter)
                containerOffset = (baseLen - widgetContainer.width) / 2;
        } else {
            if (root.isBottom)
                containerOffset = baseLen - widgetContainer.height;
            else if (root.isVCenter)
                containerOffset = (baseLen - widgetContainer.height) / 2;
        }

        const localWPos = root.horizontal ? (currentMenuWidget.x + currentMenuWidget.width / 2) : (currentMenuWidget.y + currentMenuWidget.height / 2);
        const wPos = containerOffset + localWPos;

        const halfMenu = menuMainLength / 2;
        const cornerMargin = cornerRadius * 1.5;

        // Check edge attachment status
        const startAttached = root.horizontal ? (root.attached.left || root.isLeft) : (root.attached.top || root.isTop);
        const endAttached = root.horizontal ? (root.attached.right || root.isRight) : (root.attached.bottom || root.isBottom);

        const startDeficit = Math.max(0, (halfMenu + cornerMargin) - wPos);
        const endDeficit = Math.max(0, (wPos + halfMenu + cornerMargin) - baseLen);

        let added = 0;
        // Suppress expansion on attached/bounded sides; only accumulate overflow on unattached sides
        if (!startAttached)
            added += startDeficit;
        if (!endAttached)
            added += endDeficit;

        return added;
    }

    readonly property real additionalSize: panelCrossSize

    readonly property real baseMainLength: Math.max(widgetContainer.requestedLength, panelMainLength)

    readonly property real length: Math.max(minLength, Math.min(baseMainLength + additionalLength + cornerRadius * 2, maxLength))

    WidgetContainer {
        id: widgetContainer

        anchors {
            top: isTop || (!horizontal && widgetsFillIsland) ? parent.top : undefined
            bottom: isBottom || (!horizontal && widgetsFillIsland) ? parent.bottom : undefined
            left: isLeft || (horizontal && widgetsFillIsland) ? parent.left : undefined
            right: isRight || (horizontal && widgetsFillIsland) ? parent.right : undefined
            horizontalCenter: horizontal && isHCenter && (!widgetsFillIsland) ? parent.horizontalCenter : undefined
            verticalCenter: !horizontal && isVCenter && (!widgetsFillIsland) ? parent.verticalCenter : undefined
        }

        horizontal: root.horizontal
        widgets: root.widgets

        onPanelRequested: (widget, panelComponent) => {
            root.showPanel(widget, panelComponent);
        }

        onMenuRequested: (widget, menuComponent) => {
            root.showMenu(widget, menuComponent);
        }

        // TODO: Hacky calculations that have no actual roots in reality
        width: (horizontal ? requestedLength : size - cornerMargins * 4)
        height: (horizontal ? size : requestedLength - cornerMargins * 4) - anchors.margins * 2
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

    protrusionContent: Loader {
        id: menuLoader

        anchors.fill: parent

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

    // Common preparation helper enforcing mutual exclusivity
    function prepareContent(targetLoader: Loader, component: Component): bool {
        if (!component)
            return false;

        // Toggle off if requesting the component currently visible in this loader
        if (targetLoader.sourceComponent === component) {
            hideAdditionalContent();
            return false;
        }

        // Close the opposing content type
        if (targetLoader === panelLoader) {
            hideMenu();
        } else {
            hidePanel();
        }

        return true;
    }

    function showPanel(widget: Widget, panelComponent: Component) {
        if (!prepareContent(panelLoader, panelComponent))
            return;

        panelLoader.sourceComponent = panelComponent;
    }

    function showMenu(widget: Widget, menuComponent: Component) {
        if (!prepareContent(menuLoader, menuComponent))
            return;

        // Animate position only if transitioning from another menu
        animateProtrusionPosition = (menuLoader.item !== null);

        currentTargetCenter = Qt.binding(() => calculateTargetCenter(widget));
        additionalLength = Qt.binding(() => calculateAdditionalLength(widget));
        menuLoader.sourceComponent = menuComponent;
    }

    function hidePanel() {
        panelLoader.sourceComponent = undefined;
    }

    function hideMenu() {
        animateProtrusionPosition = false;
        menuLoader.sourceComponent = undefined;
    }

    function hideAdditionalContent() {
        hidePanel();
        hideMenu();
    }

    property bool popupOpen: menuLoader.sourceComponent || panelLoader.sourceComponent

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
