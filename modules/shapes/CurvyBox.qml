import QtQuick
import QtQuick.Shapes

import "../assetloaders"
import "../gradients"

Shape {
    id: box

    required property Attach attached
    property real cornerRadius: 14
    property bool showFeet: true
    property bool cornerMarginsHorizontal: true
    property real cornerMargins: cornerRadius / 8

    property bool snapProtrusionToEdges: true

    property bool protrusionActive: protrusionContent !== null
    property int protrusionSide: Position.Bottom

    // Automatically calculate the required inner padding based on corner radius
    readonly property real protrusionMargin: Math.max(0, Math.min(box.cornerRadius, box.width / 2, box.height / 2)) / 2

    property real protrusionPosition: protrusionActive ? Math.max(protrusionContent.requestedPosition, 0) : 0

    // Helper properties to check the actual requested size from the inner Item (the Loader)
    readonly property real _rawReqLength: protrusionActive ? (Position.isYAxis(protrusionSide) ? protrusionContent.requestedLength : protrusionContent.requestedSize) : 0
    readonly property real _rawReqDepth: protrusionActive ? (Position.isYAxis(protrusionSide) ? protrusionContent.requestedSize : protrusionContent.requestedLength) : 0

    // Expand boundaries ONLY if the content actually has size. Otherwise, keep it collapsed at 0.
    property real protrusionLength: (_rawReqLength > 0 && _rawReqDepth > 0) ? (_rawReqLength + protrusionMargin * 2) : 0
    property real protrusionDepth: (_rawReqLength > 0 && _rawReqDepth > 0) ? (_rawReqDepth + protrusionMargin * 2) : 0

    default property alias content: contentItem.data
    readonly property alias contentChildren: contentItem.children
    property Item protrusionContent: null

    Item {
        id: contentItem
        anchors {
            fill: parent
            topMargin: !cornerMarginsHorizontal && !attached.top ? box.cornerMargins : 0
            bottomMargin: !cornerMarginsHorizontal && !attached.bottom ? box.cornerMargins : 0
            leftMargin: cornerMarginsHorizontal && !attached.left ? box.cornerMargins : 0
            rightMargin: cornerMarginsHorizontal && !attached.right ? box.cornerMargins : 0
        }
    }
    readonly property alias contentItem: contentItem

    readonly property var _protrusionBounds: {
        const edge = box.protrusionSide;
        const w = box.width, h = box.height;
        const r = Math.max(0, Math.min(box.cornerRadius, w / 2, h / 2));
        const L = Position.isYAxis(edge) ? w : h;

        const active = box.protrusionActive && box.protrusionLength > 0 && box.protrusionDepth > 0;
        if (!active)
            return {
                x: 0,
                y: 0,
                w: 0,
                h: 0
            };

        const sRaw = box.protrusionPosition;
        const eRaw = box.protrusionPosition + box.protrusionLength;
        const depth = box.protrusionDepth;

        const a = box.attached;
        const cornerArc = [!a.left && !a.top, !a.top && !a.right, !a.right && !a.bottom, !a.bottom && !a.left];
        let c0 = 0, cL = 0;
        switch (edge) {
        case Position.Top:
            c0 = 0;
            cL = 1;
            break;
        case Position.Right:
            c0 = 1;
            cL = 2;
            break;
        case Position.Bottom:
            c0 = 3;
            cL = 2;
            break;
        case Position.Left:
            c0 = 0;
            cL = 3;
            break;
        }
        const rSpace0 = cornerArc[c0] ? r : 0;
        const rSpaceL = cornerArc[cL] ? r : 0;

        const expandStart = box.snapProtrusionToEdges && (sRaw <= rSpace0);
        const expandEnd = box.snapProtrusionToEdges && (eRaw >= L - rSpaceL);

        const sEff = expandStart ? 0 : Math.max(0, Math.min(L, sRaw));
        const eEff = expandEnd ? L : Math.max(0, Math.min(L, eRaw));
        const lenEff = Math.max(0, eEff - sEff);

        switch (edge) {
        case Position.Top:
            return {
                x: sEff,
                y: -depth,
                w: lenEff,
                h: depth
            };
        case Position.Bottom:
            return {
                x: sEff,
                y: h,
                w: lenEff,
                h: depth
            };
        case Position.Left:
            return {
                x: -depth,
                y: sEff,
                w: depth,
                h: lenEff
            };
        case Position.Right:
            return {
                x: w,
                y: sEff,
                w: depth,
                h: lenEff
            };
        default:
            return {
                x: 0,
                y: 0,
                w: 0,
                h: 0
            };
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
                margins: box.protrusionMargin
            }

            data: protrusionContent
        }
    }

    readonly property color fillColor: OuterWildsFont.backgroundColor
    readonly property color borderColor: Qt.rgba(250 / 255, 179 / 255, 135 / 255, 0.28)
    readonly property ShapeGradient gradient: null

    preferredRendererType: Shape.CurveRenderer

    function outlinePath() {
        const w = width, h = height, a = attached;
        const pt = p => `${p[0]} ${p[1]}`;

        const r = Math.max(0, Math.min(box.cornerRadius, w / 2, h / 2));
        const arcTo = (p, foot) => `A ${r} ${r} 0 0 ${foot ? 0 : 1} ${pt(p)}`;

        function corner(cx, cy, beforeOffset, afterOffset, beforeAttached, afterAttached) {
            if (beforeAttached && afterAttached)
                return {
                    before: [cx, cy],
                    after: [cx, cy],
                    arc: false,
                    foot: false
                };

            if (!beforeAttached && !afterAttached)
                return {
                    before: [cx + beforeOffset[0], cy + beforeOffset[1]],
                    after: [cx + afterOffset[0], cy + afterOffset[1]],
                    arc: true,
                    foot: false
                };

            if (!showFeet)
                return {
                    before: [cx, cy],
                    after: [cx, cy],
                    arc: false,
                    foot: false
                };

            const bOff = beforeAttached ? [-beforeOffset[0], -beforeOffset[1]] : beforeOffset;
            const aOff = afterAttached ? [-afterOffset[0], -afterOffset[1]] : afterOffset;
            return {
                before: [cx + bOff[0], cy + bOff[1]],
                after: [cx + aOff[0], cy + aOff[1]],
                arc: true,
                foot: true
            };
        }

        const corners = [corner(0, 0, [0, r], [r, 0], a.left, a.top)        // 0: TL
            , corner(w, 0, [-r, 0], [0, r], a.top, a.right)      // 1: TR
            , corner(w, h, [0, -r], [-r, 0], a.right, a.bottom) // 2: BR
            , corner(0, h, [r, 0], [0, -r], a.bottom, a.left)    // 3: BL
        ];

        const edges = [
            {
                name: "top",
                map: (u, v) => [u, -v],
                len: w
            },
            {
                name: "right",
                map: (u, v) => [w + v, u],
                len: h
            },
            {
                name: "bottom",
                map: (u, v) => [w - u, h + v],
                len: w
            },
            {
                name: "left",
                map: (u, v) => [-v, h - u],
                len: h
            }
        ];

        const edgeNames = ["top", "right", "bottom", "left"];
        const activeIdx = (box.protrusionActive && box.protrusionLength > 0 && box.protrusionDepth > 0) ? edgeNames.indexOf(Position.name(box.protrusionSide)) : -1;

        let suppressCorner = [false, false, false, false];
        let expandStart = false;
        let expandEnd = false;
        let rProt = r;
        let rSpace0 = 0, rSpaceL = 0;

        if (activeIdx !== -1) {
            const e = edges[activeIdx];
            const L = e.len;
            const depth = box.protrusionDepth;

            const sRaw = box.protrusionPosition;
            const eRaw = box.protrusionPosition + box.protrusionLength;

            let c0 = 0, cL = 0;
            if (activeIdx === 0) {
                c0 = 0;
                cL = 1;
            } else if (activeIdx === 1) {
                c0 = 1;
                cL = 2;
            } else if (activeIdx === 2) {
                c0 = 3;
                cL = 2;
            } else if (activeIdx === 3) {
                c0 = 0;
                cL = 3;
            }

            rSpace0 = corners[c0].arc ? r : 0;
            rSpaceL = corners[cL].arc ? r : 0;

            expandStart = box.snapProtrusionToEdges && (sRaw <= rSpace0);
            expandEnd = box.snapProtrusionToEdges && (eRaw >= L - rSpaceL);

            const sEff = expandStart ? 0 : Math.max(0, Math.min(L, sRaw));
            const eEff = expandEnd ? L : Math.max(0, Math.min(L, eRaw));
            const lenEff = Math.max(0, eEff - sEff);

            rProt = Math.max(0, Math.min(r, depth, lenEff / 2));

            if (expandStart) {
                const startCornerIdx = (activeIdx === 2) ? 3 : (activeIdx === 3 ? 0 : activeIdx);
                suppressCorner[startCornerIdx] = true;
            }
            if (expandEnd) {
                const endCornerIdx = (activeIdx === 2) ? 2 : (activeIdx === 3 ? 3 : activeIdx + 1);
                suppressCorner[endCornerIdx] = true;
            }
        }

        let startPt = corners[0].after;
        if (activeIdx === 0 && expandStart) {
            startPt = [0, -box.protrusionDepth + rProt];
        } else if (activeIdx === 3 && expandStart) {
            startPt = [-box.protrusionDepth + rProt, 0];
        }

        let d = `M ${pt(startPt)} `;

        edges.forEach((e, i) => {
            const L = e.len;
            const nextCornerIdx = (i + 1) % 4;
            const nextCorner = corners[nextCornerIdx];

            if (i === activeIdx) {
                const depth = box.protrusionDepth;
                const sRaw = box.protrusionPosition;
                const eRaw = box.protrusionPosition + box.protrusionLength;

                const sEff = expandStart ? 0 : Math.max(0, Math.min(L, sRaw));
                const eEff = expandEnd ? L : Math.max(0, Math.min(L, eRaw));

                const uStartExpand = box.snapProtrusionToEdges && (i >= 2 ? expandEnd : expandStart);
                const uEndExpand = box.snapProtrusionToEdges && (i >= 2 ? expandStart : expandEnd);

                const u0 = (i >= 2) ? (L - eEff) : sEff;
                const u1 = (i >= 2) ? (L - sEff) : eEff;

                let u0_space = (i < 2) ? (u0 - rSpace0) : (u0 - rSpaceL);
                let u1_space = (i < 2) ? (L - rSpaceL - u1) : (L - rSpace0 - u1);

                const rf0 = Math.max(0, Math.min(rProt, u0_space));
                const rf1 = Math.max(0, Math.min(rProt, u1_space));

                if (uStartExpand) {
                    d += `L ${pt(e.map(u0, depth - rProt))} `;
                    d += `A ${rProt} ${rProt} 0 0 1 ${pt(e.map(u0 + rProt, depth))} `;
                } else {
                    d += `L ${pt(e.map(u0 - rf0, 0))} `;
                    d += `A ${rf0} ${rf0} 0 0 0 ${pt(e.map(u0, rf0))} `;
                    d += `L ${pt(e.map(u0, depth - rProt))} `;
                    d += `A ${rProt} ${rProt} 0 0 1 ${pt(e.map(u0 + rProt, depth))} `;
                }

                d += `L ${pt(e.map(u1 - rProt, depth))} `;

                if (uEndExpand) {
                    d += `A ${rProt} ${rProt} 0 0 1 ${pt(e.map(u1, depth - rProt))} `;
                    d += `L ${pt(e.map(u1, 0))} `;
                } else {
                    d += `A ${rProt} ${rProt} 0 0 1 ${pt(e.map(u1, depth - rProt))} `;
                    d += `L ${pt(e.map(u1, rf1))} `;
                    d += `A ${rf1} ${rf1} 0 0 0 ${pt(e.map(u1 + rf1, 0))} `;
                    d += `L ${pt(nextCorner.before)} `;
                }
            } else {
                if (suppressCorner[nextCornerIdx]) {
                    d += `L ${pt(e.map(L, 0))} `;
                } else {
                    d += `L ${pt(nextCorner.before)} `;
                }
            }

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
