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
                ElephantService.activate("desktopapplications", "kitty.desktop", "start", "", [])
            }
        }

        Repeater {
            model: root.results

            RowLayout {
                id: row
                required property var modelData
                Layout.preferredHeight: 48

                IconImage {
                    id: iconImg
                    implicitSize: 48
                    Layout.fillHeight: true
                    Layout.margins: 2

                    property string rawIcon: row.modelData["icon"] || ""

                    source: {
                        if (rawIcon === "") return "";
                        if (rawIcon.startsWith("/") || rawIcon.startsWith("file://") || rawIcon.startsWith("image://"))
                            return rawIcon;

                        return Quickshell.iconPath(rawIcon, rawIcon + "-symbolic");
                    }

                    visible: source !== ""
                }

                TextWidget {
                    horizontal: true
                    Layout.fillWidth: true
                    text: row.modelData["text"]
                    fontSize: 22
                }
            }
        }
    }
}
