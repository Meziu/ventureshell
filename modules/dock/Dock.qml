import QtQuick
import Quickshell

import "bars"

Item {
    Variants {
        model: Quickshell.screens

        Item {
            required property var modelData

            VerticalBar {
                screen: modelData
            }

            HorizontalBar {
                screen: modelData
            }
        }
    }
}
