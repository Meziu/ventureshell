import QtQuick
import QtQuick.Shapes

import "../assetloaders"
import "../gradients"

Shape {
    id: box

    required property Attach attached
    property real cornerRadius: 14
    property bool showFeet: true
    property bool avoidCornersHorizontally: true

    // --- PROTRUSION PROPERTIES ---
    property bool protrusionActive: false
    property string protrusionEdge: "bottom" // "top" | "bottom" | "left" | "right"
    property real protrusionPosition: 0      // X offset (top/bottom) or Y offset (left/right)
    property real protrusionLength: 0        // Length along the edge
    property real protrusionDepth: 0         // Distance extending outward

    Behavior on protrusionPosition { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
    Behavior on protrusionLength   { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
    Behavior on protrusionDepth    { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }

    default property alias content: contentItem.data
    readonly property alias contentChildren: contentItem.children
    property alias protrusionContent: protrusionContentItem.data

    Item {
        id: contentItem
        anchors {
            fill: parent
            topMargin: !avoidCornersHorizontally && !attached.top ? box.cornerRadius/8 : 0
            bottomMargin: !avoidCornersHorizontally && !attached.bottom ? box.cornerRadius/8 : 0
            leftMargin: avoidCornersHorizontally && !attached.left ? box.cornerRadius/8 : 0
            rightMargin: avoidCornersHorizontally && !attached.right ? box.cornerRadius/8 : 0
        }
    }
    readonly property alias contentItem: contentItem

    readonly property var _protrusionBounds: ({
        "top":    { x: box.protrusionPosition, y: -box.protrusionDepth, w: box.protrusionLength, h: box.protrusionDepth },
        "bottom": { x: box.protrusionPosition, y: box.height,           w: box.protrusionLength, h: box.protrusionDepth },
        "left":   { x: -box.protrusionDepth,   y: box.protrusionPosition, w: box.protrusionDepth,  h: box.protrusionLength },
        "right":  { x: box.width,              y: box.protrusionPosition, w: box.protrusionDepth,  h: box.protrusionLength }
    })[box.protrusionEdge] ?? { x: 0, y: 0, w: 0, h: 0 }

    Item {
        id: protrusionContainer
        visible: box.protrusionActive && box.protrusionDepth > 0 && box.protrusionLength > 0
        x: box._protrusionBounds.x
        y: box._protrusionBounds.y
        width: box._protrusionBounds.w
        height: box._protrusionBounds.h

        Item {
            id: protrusionContentItem
            anchors {
                fill: parent
                margins: box.cornerRadius / 2
            }
        }
    }
    readonly property alias protrusionContentItem: protrusionContentItem

    readonly property color fillColor: OuterWildsFont.backgroundColor
    readonly property color borderColor: Qt.rgba(250 / 255, 179 / 255, 135 / 255, 0.28)
    readonly property ShapeGradient gradient: null

    preferredRendererType: Shape.CurveRenderer

    function outlinePath() {
        const w = width, h = height, r = cornerRadius, a = attached;
        const pt = p => `${p[0]} ${p[1]}`;
        const arcTo = (p, foot) => `A ${r} ${r} 0 0 ${foot ? 0 : 1} ${pt(p)}`;

        function corner(cx, cy, beforeOffset, afterOffset, beforeAttached, afterAttached) {
            if (beforeAttached && afterAttached)
                return { before: [cx, cy], after: [cx, cy], arc: false, foot: false };

            if (!beforeAttached && !afterAttached)
                return {
                    before: [cx + beforeOffset[0], cy + beforeOffset[1]],
                    after: [cx + afterOffset[0], cy + afterOffset[1]],
                    arc: true, foot: false
                };

            if (!showFeet)
                return { before: [cx, cy], after: [cx, cy], arc: false, foot: false };

            const bOff = beforeAttached ? [-beforeOffset[0], -beforeOffset[1]] : beforeOffset;
            const aOff = afterAttached ? [-afterOffset[0], -afterOffset[1]] : afterOffset;
            return {
                before: [cx + bOff[0], cy + bOff[1]],
                after: [cx + aOff[0], cy + aOff[1]],
                arc: true, foot: true
            };
        }

        const corners = [
            corner(0, 0, [0, r], [r, 0], a.left, a.top),      // TL
            corner(w, 0, [-r, 0], [0, r], a.top, a.right),    // TR
            corner(w, h, [0, -r], [-r, 0], a.right, a.bottom), // BR
            corner(0, h, [r, 0], [0, -r], a.bottom, a.left)   // BL
        ];

        const activeEdge = (box.protrusionActive && box.protrusionLength > 0 && box.protrusionDepth > 0)
            ? box.protrusionEdge
            : null;

        const pos = box.protrusionPosition;
        const len = box.protrusionLength;

        // Local-to-global spatial transformers for clockwise edge traversal
        // u = distance along edge in traversal direction, v = outward depth
        const edges = [
            { name: "top",    map: (u, v) => [u, -v],      uRange: [pos, pos + len] },
            { name: "right",  map: (u, v) => [w + v, u],   uRange: [pos, pos + len] },
            { name: "bottom", map: (u, v) => [w - u, h + v], uRange: [w - (pos + len), w - pos] },
            { name: "left",   map: (u, v) => [-v, h - u],  uRange: [h - (pos + len), h - pos] }
        ];

        let d = `M ${pt(corners[0].after)} `;

        edges.forEach((e, i) => {
            if (e.name === activeEdge) {
                const [u0, u1] = e.uRange;
                const depth = box.protrusionDepth;

                // Single unified parametric path sequence for any edge
                d += `L ${pt(e.map(u0 - r, 0))} `;
                d += `A ${r} ${r} 0 0 0 ${pt(e.map(u0, r))} `;
                d += `L ${pt(e.map(u0, depth - r))} `;
                d += `A ${r} ${r} 0 0 1 ${pt(e.map(u0 + r, depth))} `;
                d += `L ${pt(e.map(u1 - r, depth))} `;
                d += `A ${r} ${r} 0 0 1 ${pt(e.map(u1, depth - r))} `;
                d += `L ${pt(e.map(u1, r))} `;
                d += `A ${r} ${r} 0 0 0 ${pt(e.map(u1 + r, 0))} `;
            }

            const nextCorner = corners[(i + 1) % 4];
            d += `L ${pt(nextCorner.before)} `;
            if (nextCorner.arc) {
                d += `${arcTo(nextCorner.after, nextCorner.foot)} `;
            }
        });

        d += "Z";
        return d;
    }

    ShapePath {
        strokeColor: box.borderColor
        fillColor: box.fillColor
        strokeWidth: 1
        fillGradient: box.gradient

        PathSvg {
            path: box.outlinePath()
        }
    }
}
