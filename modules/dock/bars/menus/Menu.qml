import QtQuick
import QtQuick.Layouts

import "../widgets"

import QtQuick
import QtQuick.Layouts

import "../widgets"

Item {
    anchors.fill: parent
    implicitWidth: 140
    implicitHeight: 100
    clip: true

    property bool persistent: false

    signal exited()
}
