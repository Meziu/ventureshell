import QtQuick

import "../menus"

TextWidget {
    property string uninhibitedIcon: ""
    property string inhibitedIcon: ""

    text: uninhibitedIcon

    Component {
        id: menuComponent
        Menu {}
    }

    onClicked: {
        menuRequested(menuComponent)
    }
}
