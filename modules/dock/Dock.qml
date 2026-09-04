import QtQuick
import Quickshell

import "bars"

Item {
    Variants {
        model: Quickshell.screens

        VerticalBar {
            required property var modelData

            screen: modelData
        }
    }

    Variants {
        model: Quickshell.screens

        HorizontalBar {
            required property var modelData

            screen: modelData
        }
    }
}
