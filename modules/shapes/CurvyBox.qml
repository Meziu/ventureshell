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
    property real protrusionPosition: 0      // X (top/bottom) or Y (left/right)
    property real protrusionLength: 0        // Requested length along the edge
    property real protrusionDepth: 0         // Extension depth outward

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

    // --- PROTRUSION CONTAINER (With 2 * cornerRadius Auto-Extension) ---
    readonly property var _protrusionBounds: {
        const edge = box.protrusionEdge;
        const w = box.width, h = box.height;
        const r = box.cornerRadius;
        const L = (edge === "top" || edge === "bottom") ? w : h;

        const active = box.protrusionActive && box.protrusionLength > 0 && box.protrusionDepth > 0;
        if (!active) return { x: 0, y: 0, w: 0, h: 0 };

        const margin = r * 2;
        let u0 = box.protrusionPosition;
        let u1 = box.protrusionPosition + box.protrusionLength;

        // Auto-extend if within the 2 * cornerRadius foot zone
        if (u0 < margin) u0 = 0;
        if (u1 > L - margin) u1 = L;

        const posEff = u0;
        const lenEff = Math.max(0, u1 - u0);
        const depth = box.protrusionDepth;

        switch (edge) {
            case "top":    return { x: posEff, y: -depth, w: lenEff, h: depth };
            case "bottom": return { x: posEff, y: h,      w: lenEff, h: depth };
            case "left":   return { x: -depth, y: posEff, w: depth,  h: lenEff };
            case "right":  return { x: w,      y: posEff, w: depth,  h: lenEff };
            default:       return { x: 0, y: 0, w: 0, h: 0 };
        }
    }

    Item {
        id: protrusionContainer
        visible: box.protrusionActive && box.protrusionDepth > 0 && box._protrusionBounds.w > 0
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
            corner(0, 0, [0, r], [r, 0], a.left, a.top),       // 0: TL
            corner(w, 0, [-r, 0], [0, r], a.top, a.right),     // 1: TR
            corner(w, h, [0, -r], [-r, 0], a.right, a.bottom), // 2: BR
            corner(0, h, [r, 0], [0, -r], a.bottom, a.left)    // 3: BL
        ];

        const edges = [
            { name: "top",    map: (u, v) => [u, -v],        len: w },
            { name: "right",  map: (u, v) => [w + v, u],     len: h },
            { name: "bottom", map: (u, v) => [w - u, h + v], len: w },
            { name: "left",   map: (u, v) => [-v, h - u],    len: h }
        ];

        const edgeNames = ["top", "right", "bottom", "left"];
        const activeIdx = (box.protrusionActive && box.protrusionLength > 0 && box.protrusionDepth > 0)
            ? edgeNames.indexOf(box.protrusionEdge)
            : -1;

        let startExtended = false;
        let endExtended = false;
        let suppressCorner = [false, false, false, false];

        if (activeIdx !== -1) {
            const e = edges[activeIdx];
            const L = e.len;
            const pos = box.protrusionPosition;
            const len = box.protrusionLength;
            const margin = r * 2;

            // Parametric start/end in clockwise direction
            let u0Raw = (activeIdx >= 2) ? (L - (pos + len)) : pos;
            let u1Raw = (activeIdx >= 2) ? (L - pos) : (pos + len);

            if (u0Raw < margin) {
                startExtended = true;
                suppressCorner[activeIdx] = true;
            }
            if (u1Raw > L - margin) {
                endExtended = true;
                suppressCorner[(activeIdx + 1) % 4] = true;
            }
        }

        // Start path at top-left corner
        let d = suppressCorner[0]
            ? `M ${pt(edges[0].map(0, activeIdx === 0 ? box.protrusionDepth - r : 0))} `
            : `M ${pt(corners[0].after)} `;

        edges.forEach((e, i) => {
            const L = e.len;
            const nextCornerIdx = (i + 1) % 4;
            const nextCorner = corners[nextCornerIdx];

            if (i === activeIdx) {
                const depth = box.protrusionDepth;
                const pos = box.protrusionPosition;
                const len = box.protrusionLength;
                const margin = r * 2;

                let u0 = (i >= 2) ? (L - (pos + len)) : pos;
                let u1 = (i >= 2) ? (L - pos) : (pos + len);

                if (startExtended) u0 = 0;
                if (endExtended) u1 = L;

                // --- 1. START OF PROTRUSION ---
                if (startExtended) {
                    d += `L ${pt(e.map(0, depth - r))} `;
                    d += `A ${r} ${r} 0 0 1 ${pt(e.map(r, depth))} `;
                } else {
                    d += `L ${pt(e.map(u0 - r, 0))} `;
                    d += `A ${r} ${r} 0 0 0 ${pt(e.map(u0, r))} `;
                    d += `L ${pt(e.map(u0, depth - r))} `;
                    d += `A ${r} ${r} 0 0 1 ${pt(e.map(u0 + r, depth))} `;
                }

                // --- 2. FRONT FACE ---
                d += `L ${pt(e.map(u1 - r, depth))} `;

                // --- 3. END OF PROTRUSION ---
                if (endExtended) {
                    d += `A ${r} ${r} 0 0 1 ${pt(e.map(L, depth - r))} `;
                    d += `L ${pt(e.map(L, 0))} `;
                } else {
                    d += `A ${r} ${r} 0 0 1 ${pt(e.map(u1, depth - r))} `;
                    d += `L ${pt(e.map(u1, r))} `;
                    d += `A ${r} ${r} 0 0 0 ${pt(e.map(u1 + r, 0))} `;
                    d += `L ${pt(nextCorner.before)} `;
                }
            } else {
                // Non-protruding edge
                if (suppressCorner[nextCornerIdx]) {
                    d += `L ${pt(e.map(L, 0))} `;
                } else {
                    d += `L ${pt(nextCorner.before)} `;
                }
            }

            // --- 4. CORNER RENDERING ---
            if (!suppressCorner[nextCornerIdx] && nextCorner.arc) {
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
