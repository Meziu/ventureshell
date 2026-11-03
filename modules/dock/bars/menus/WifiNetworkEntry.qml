import QtQuick
import QtQuick.Controls as Ctls
import QtQuick.Layouts

import "../../../assetloaders"
import "../../../theme"
import "../../../services"
import "../widgets"

ColumnLayout {
    id: root

    required property var modelData   // WifiNetwork

    property bool askingPassword: false

    Layout.fillWidth: true
    spacing: 2

    Connections {
        target: root.modelData

        function onConnectionFailed(reason) {
            console.log("wifi connect failed:", root.modelData.name, reason)
            if (NetworkService.needsPassword(reason))
                root.askingPassword = true
        }

        function onConnectedChanged() {
            if (root.modelData.connected)
                root.askingPassword = false
        }
    }

    TextWidget {
        Layout.fillWidth: true
        text: (root.modelData.connected ? "✓ " : "   ")
              + NetworkService.networkLabel(root.modelData)
        fontSize: 12
        horizontalAlignment: Text.AlignLeft
        elide: Text.ElideRight

        onClicked: NetworkService.connectToNetwork(root.modelData)
    }

    Ctls.TextField {
        id: passwordField

        visible: root.askingPassword
        Layout.fillWidth: true
        Layout.preferredHeight: 36

        background: Rectangle {
            color: "black"
            opacity: 0.4
            radius: 8
        }

        echoMode: TextInput.Password
        font: OuterWildsFont.uiWithSize(12)
        padding: 8
        color: Theme.text.lightColor
        verticalAlignment: Text.AlignVCenter
        placeholderText: "Password for " + root.modelData.name
        placeholderTextColor: Theme.text.placeholderColor
        selectByMouse: true

        onVisibleChanged: {
            if (visible) forceActiveFocus()
            else text = ""
        }

        onAccepted: {
            NetworkService.connectToNetworkWithPassword(root.modelData, text)
            root.askingPassword = false   // reopens itself if it fails again
        }

        Keys.onEscapePressed: root.askingPassword = false
    }
}
