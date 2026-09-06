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
    property int position: Bar.Top
    property bool horizontal: position === Bar.Top || position === Bar.Bottom
    property real minLength: 0
    property real maxLength: 600

    property real transitionTime: 100

    readonly property real length: Math.max(minLength, Math.min(widgetContainer.requestedLength + cornerRadius * 2, maxLength))

    width: horizontal ? length : size
    height: !horizontal ? length : size
    avoidCornersHorizontally: horizontal

    property WidgetContainer widgetContainer: WidgetContainer {
        horizontal: root.horizontal

        widgets: root.widgets
    }
    contentChildren: widgetContainer

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
