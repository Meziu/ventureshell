import QtQuick

import "../menus"

TextWidget {
    id: root

    property string uninhibitedIcon: ""
    property string inhibitedIcon: ""

    text: uninhibitedIcon

    Component {
        id: menuComponent
        Menu {}
    }

    onClicked: {
        root.menuRequested(menuComponent)
    }
}
