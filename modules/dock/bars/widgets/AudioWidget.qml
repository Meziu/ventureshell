import QtQuick

import "../menus"
import "../../../services"

TextWidget {
    property list<string> audioIcons: ["", "", "", ""]

    text: audioIcons[2]
}
