import QtQuick

import "../menus"
import "../../../services"

TextWidget {
    property string uninhibitedIcon: ""
    property string inhibitedIcon: ""

    text: IdleInhibitorService.inhibit ? inhibitedIcon : uninhibitedIcon

    onClicked: altClicked()
    onAltClicked: IdleInhibitorService.toggle()
}
