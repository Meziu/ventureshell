pragma Singleton
import QtQuick

QtObject {
    readonly property url root: Qt.resolvedUrl("../../")
    readonly property url assets: root + "/assets"
}
