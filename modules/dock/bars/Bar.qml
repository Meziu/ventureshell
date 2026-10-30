import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "islands"
import "../../config"
import "../../shapes"
import "../../services"

PanelWindow {
    id: root

    required property int position
    property real size: Config.options.bar.size
    property real cornerRadius: Config.options.bar.cornerRadius
    default property list<Island> islands

    signal popupOpened

    WlrLayershell.layer: WlrLayer.Top
    mask: Region {
        id: maskRegion
    }

    function hidePopups() {
        hidePopupsExcept(-1);
    }
    function hidePopupsExcept(except: int) {
        for (let i = 0; i < islands.length; i++) {
            if (i === except)
                continue;

            islands[i].hidePopup(false);
        }
    }

    Instantiator {
        model: root.islands
        delegate: Connections {
            required property Island modelData
            required property int index
            target: modelData

            function onRequiresFocusGrabChanged() {
                if (!modelData.requiresFocusGrab)
                    return;

                root.hidePopupsExcept(index); // this bar's other islands
                root.popupOpened();           // let the Dock handle the other bar
            }
        }
    }

    readonly property bool requiresFocusGrab: {
        for (let i = 0; i < islands.length; i++) {
            if (islands[i].requiresFocusGrab)
                return true;
        }
        return false;
    }

    Item {
        id: content
        anchors.fill: parent

        data: root.islands
    }

    Instantiator {
        id: maskInst
        model: root.islands
        delegate: Region {
            required property Island modelData
            item: modelData

            Region {
                // TODO: Swap out for the Loader of the protrusion content in Island
                item: modelData.protrusionContent
            }
        }

        property var created: []

        onObjectAdded: (index, object) => {
            created.push(object);
            maskRegion.regions.push(object);
        }
        onObjectRemoved: (index, object) => {
            const i = created.indexOf(object);
            if (i !== -1)
                created.splice(i, 1);

            maskRegion.regions.length = 0;
            for (const obj of created) {
                maskRegion.regions.push(obj);
            }
            object.destroy();
        }
    }

    anchors {
        top: position != Position.Bottom
        bottom: position != Position.Top
        left: position != Position.Right
        right: position != Position.Left
    }

    exclusiveZone: size
    exclusionMode: ExclusionMode.Normal

    color: "#00000000"
}
