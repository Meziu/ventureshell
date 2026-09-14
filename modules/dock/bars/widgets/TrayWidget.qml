import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

import "../menus"

Widget {
    id: root

    requestedLength: container.requestedLength

    WidgetContainer {
        id: container
        anchors.fill: parent
        horizontal: root.horizontal
        margins: 2
        spacing: 4

        Repeater {
            model: SystemTray.items

            IconWidget {
                id: iconWidget
                required property SystemTrayItem modelData

                source: modelData.icon
                iconSize: 20

                onClicked: modelData.activate()

                // Secondary click triggers the menu anchor
                onAltClicked: {
                    if (modelData.hasMenu) {
                        root.menuRequested(menuComponent);
                    }
                }

                Component {
                    id: menuComponent

                    Menu {
                        id: menu

                        property SystemTrayItem trayItem: iconWidget.modelData

                        QsMenuOpener {
                            id: opener
                            menu: menu.trayItem ? menu.trayItem.menu : null
                        }

                        implicitWidth: Math.max(160, contentLayout.implicitWidth)
                        implicitHeight: Math.max(40, contentLayout.implicitHeight)

                        ColumnLayout {
                            id: contentLayout
                            anchors.fill: parent
                            anchors.margins: 4

                            Repeater {
                                model: opener.children

                                RowLayout {
                                    Layout.preferredHeight: modelData.isSeparator ? 0 : -1
                                    Layout.topMargin: 2
                                    Layout.bottomMargin: 2
                                    spacing: 4

                                    IconImage {
                                        source: modelData.icon
                                        implicitWidth: 16
                                        implicitHeight: 16
                                        visible: modelData.icon !== ""
                                    }

                                    TextWidget {
                                        Layout.fillWidth: true

                                        text: modelData.text
                                        fontSize: 12
                                        horizontalAlignment: Text.AlignLeft

                                        clickable: !modelData.isSeparator && modelData.enabled

                                        onClicked: modelData.triggered()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.fill: container
        anchors.margins: -2
        opacity: 0.15
        radius: height / 2
    }
}
