import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets

import "../../../assetloaders"
import "../../../services"
import "../widgets"

Panel {
    id: root

    fillSpace: true
    requestedLength: 500
    requestedSize: column.implicitHeight + verticalMargin * 2

    property real verticalMargin: 5
    property list<var> results
    property int currentIndex: 0

    // Reset selection whenever the result set changes so we never point
    // past the end of the new list (and so a fresh search starts at the top).
    onResultsChanged: root.currentIndex = 0

    function clampIndex(i) {
        if (root.results.length === 0) return 0;
        return Math.max(0, Math.min(i, root.results.length - 1));
    }

    function executeSelected() {
        if (root.results.length === 0) return;

        const item = root.results[root.currentIndex];
        if (!item) return;

        const provider = item["provider"] || "desktopapplications";
        const identifier = item["identifier"] || "";

        if (identifier === "") return;

        ElephantService.activate(provider, identifier, "start", "", []);
        root.exited()
    }

    ColumnLayout {
        id: column
        anchors.fill: parent
        anchors.topMargin: root.verticalMargin
        anchors.bottomMargin: root.verticalMargin

        TextField {
            id: searchField

            Layout.preferredHeight: 60
            Layout.fillWidth: true

            background: Rectangle {
                anchors.fill: parent

                color: OuterWildsFont.darkColor
                opacity: 0.7
                radius: 16
            }

            font: OuterWildsFont.uiWithSize(18)
            padding: 10
            color: OuterWildsFont.lightColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft

            placeholderText: "Search..."
            placeholderTextColor: "gray"

            selectByMouse: true
            cursorVisible: false

            focus: true

            Component.onCompleted: {
                forceActiveFocus();
                ElephantService.queryProviders();
            }

            onTextEdited: {
                ElephantService.query(["desktopapplications"], searchField.text, 5, r => root.results = r);
            }

            onAccepted: {
                root.executeSelected();
            }

            Keys.onPressed: event => {
                if (event.key === Qt.Key_Down) {
                    root.currentIndex = root.clampIndex(root.currentIndex + 1);
                    event.accepted = true;
                } else if (event.key === Qt.Key_Up) {
                    root.currentIndex = root.clampIndex(root.currentIndex - 1);
                    event.accepted = true;
                }
            }
        }

        Repeater {
            model: root.results

            Rectangle {
                id: delegateRoot
                required property var modelData
                required property int index

                Layout.fillWidth: true
                Layout.preferredHeight: 48

                radius: 8
                color: index === root.currentIndex ? Qt.rgba(1, 1, 1, 0.12) : "transparent"

                RowLayout {
                    id: row
                    anchors.fill: parent

                    Image {
                        id: iconImg
                        sourceSize.width: 64
                        sourceSize.height: 64
                        Layout.fillHeight: true
                        Layout.margins: 2

                        fillMode: Image.PreserveAspectFit

                        property string rawIcon: delegateRoot.modelData["icon"] || ""

                        source: {
                            if (rawIcon === "") return "";
                            if (rawIcon.startsWith("/") || rawIcon.startsWith("file:") || rawIcon.startsWith("image:"))
                                return rawIcon;

                            return Quickshell.iconPath(rawIcon, rawIcon + "-symbolic");
                        }

                        visible: source !== ""
                    }

                    TextWidget {
                        horizontal: true
                        Layout.fillWidth: true
                        text: delegateRoot.modelData["text"]
                        fontSize: 22
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: root.currentIndex = delegateRoot.index
                    onClicked: {
                        root.currentIndex = delegateRoot.index;
                        root.executeSelected();
                    }
                }
            }
        }
    }
}
