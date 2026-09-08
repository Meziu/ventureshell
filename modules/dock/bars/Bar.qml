import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "islands"
import "../../config"
import "../../shapes"

PanelWindow {
    id: root

    required property int position
    property real barSize: Config.options.bar.size
    property real barCornerRadius: Config.options.bar.cornerRadius
    default property alias data: content.data

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    mask: Region {
        id: maskRegion
    }

    Item {
        id: content
        anchors.fill: parent
    }

    Instantiator {
        id: maskInst
        model: content.children
        delegate: Region {
            required property QtObject modelData
            item: modelData
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
            // regions only reliably supports append/truncate,
            // so rebuild rather than trying to splice out the middle
            maskRegion.regions.length = 0;
            for (const obj of created)
                maskRegion.regions.push(obj);
            object.destroy();
        }
    }

    anchors {
        top: position != Position.Bottom
        bottom: position != Position.Top
        left: position != Position.Right
        right: position != Position.Left
    }

    exclusiveZone: barSize
    exclusionMode: ExclusionMode.Normal

    color: "#00000000"
}
