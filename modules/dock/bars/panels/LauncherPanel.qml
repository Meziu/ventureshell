import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

import "../../../assetloaders"
import "../../../services"
import "../widgets"

Panel {
    id: root

    fillSpace: true
    implicitWidth: 500
    implicitHeight: column.implicitHeight

    property list<var> results
    property int currentIndex: 0
    property int resultLimit: 5

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

        const provider = item["provider"];
        const identifier = item["identifier"];
        const actions = item["actions"];
        const query = searchField.text;

        if (identifier === "" || provider === "" || actions === []) return;

        // The first one is executed with a simple enter, should find some other way
        ElephantService.activate(provider, identifier, actions[0], query, []);
        root.exited()
    }

    ColumnLayout {
        id: column
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        TextField {
            id: searchField

            Layout.preferredHeight: 60
            Layout.fillWidth: true

            background: Rectangle {
                anchors.fill: parent

                color: "black"
                opacity: 0.4
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
            }

            onTextEdited: {
                ElephantService.query(["desktopapplications","calc"], searchField.text, root.resultLimit, r => root.results = r);
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
                Layout.fillHeight: false
                Layout.preferredHeight: 48

                radius: 8
                color: index === root.currentIndex ? Qt.rgba(1, 1, 1, 0.15) : Qt.rgba(0, 0, 0, 0.15)

                RowLayout {
                    id: row
                    anchors.fill: parent

                    IconWidget {
                        id: iconImg
                        Layout.fillHeight: true
                        Layout.margins: 2
                        visible: source !== ""

                        source: delegateRoot.modelData["icon"] || ""
                        iconSize: 64
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
