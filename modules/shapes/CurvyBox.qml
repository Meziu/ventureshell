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
    property real cornerMargins: cornerRadius / 2

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

    // Maps the raw distance `g` between a protrusion end and the nearest corner to the
    // distance actually drawn. Beyond 2r nothing changes. Inside the snap distance the
    // protrusion is flush with the edge (0). In between, the gap is remapped linearly so
    // that it is exactly 2*rad wide (room for the corner arc + the protrusion fillet, each
    // of radius rad), which shrinks both radii smoothly to 0 right where the snap happens.
    function _effectiveGap(g, snapDist, r) {
        if (g <= snapDist)
            return 0;
        const full = 2 * r;
        if (g >= full)
            return g;
        return full * (g - snapDist) / (full - snapDist);
    }

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

        const snap = box.snapProtrusionToEdges;
        const sClamped = Math.max(0, Math.min(L, sRaw));
        const eClamped = Math.max(0, Math.min(L, eRaw));
        const sEff = box._effectiveGap(sClamped, snap ? rSpace0 : 0, r);
        const eEff = L - box._effectiveGap(L - eClamped, snap ? rSpaceL : 0, r);
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
        const arcTo = c => `A ${c.radius} ${c.radius} 0 0 ${c.foot ? 0 : 1} ${pt(c.after)}`;

        // Corner routine (attached feet logic preserved), now with a per-corner radius
        // so that corners next to the protrusion can shrink independently.
        function buildCorners(cr) {
            function corner(cx, cy, bDir, aDir, beforeAttached, afterAttached, rr) {
                const beforeOffset = [bDir[0] * rr, bDir[1] * rr];
                const afterOffset = [aDir[0] * rr, aDir[1] * rr];

                if (beforeAttached && afterAttached)
                    return {
                        before: [cx, cy],
                        after: [cx, cy],
                        arc: false,
                        foot: false,
                        radius: 0
                    };

                if (!beforeAttached && !afterAttached)
                    return {
                        before: [cx + beforeOffset[0], cy + beforeOffset[1]],
                        after: [cx + afterOffset[0], cy + afterOffset[1]],
                        arc: true,
                        foot: false,
                        radius: rr
                    };

                if (!showFeet)
                    return {
                        before: [cx, cy],
                        after: [cx, cy],
                        arc: false,
                        foot: false,
                        radius: 0
                    };

                const bOff = beforeAttached ? [-beforeOffset[0], -beforeOffset[1]] : beforeOffset;
                const aOff = afterAttached ? [-afterOffset[0], -afterOffset[1]] : afterOffset;
                return {
                    before: [cx + bOff[0], cy + bOff[1]],
                    after: [cx + aOff[0], cy + aOff[1]],
                    arc: true,
                    foot: true,
                    radius: rr
                };
            }

            return [corner(0, 0, [0, 1], [1, 0], a.left, a.top, cr[0])       // 0: TL
                , corner(w, 0, [-1, 0], [0, 1], a.top, a.right, cr[1])       // 1: TR
                , corner(w, h, [0, -1], [-1, 0], a.right, a.bottom, cr[2])   // 2: BR
                , corner(0, h, [1, 0], [0, -1], a.bottom, a.left, cr[3])     // 3: BL
            ];
        }

        // First pass at full radius: only used to learn which corners are arcs.
        const cornerRadii = [r, r, r, r];
        let corners = buildCorners(cornerRadii);

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
        let rSpace0 = 0, rSpaceL = 0;

        // Effective protrusion span along its edge (raw coordinates, same as _protrusionBounds)
        let sEff = 0, eEff = 0;
        // Fillet radii where the protrusion meets the main box (raw start / end side)
        let rfRaw0 = 0, rfRawL = 0;

        if (activeIdx !== -1) {
            const e = edges[activeIdx];
            const L = e.len;

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

            if (expandStart) {
                const startCornerIdx = (activeIdx === 2) ? 3 : (activeIdx === 3 ? 0 : activeIdx);
                suppressCorner[startCornerIdx] = true;
            }
            if (expandEnd) {
                const endCornerIdx = (activeIdx === 2) ? 2 : (activeIdx === 3 ? 3 : activeIdx + 1);
                suppressCorner[endCornerIdx] = true;
            }

            const snap = box.snapProtrusionToEdges;
            const sClamped = Math.max(0, Math.min(L, sRaw));
            const eClamped = Math.max(0, Math.min(L, eRaw));
            sEff = box._effectiveGap(sClamped, snap ? rSpace0 : 0, r);
            eEff = L - box._effectiveGap(L - eClamped, snap ? rSpaceL : 0, r);

            // The remapped gap is exactly 2*rad wide, so the main corner arc and the
            // protrusion fillet (both radius rad) fill it completely and both reach
            // 0 at the moment the protrusion snaps flush with the edge.
            const radStart = Math.min(r, sEff / 2);
            const radEnd = Math.min(r, (L - eEff) / 2);
            cornerRadii[c0] = radStart;
            cornerRadii[cL] = radEnd;
            rfRaw0 = rSpace0 > 0 ? radStart : 0;
            rfRawL = rSpaceL > 0 ? radEnd : 0;

            corners = buildCorners(cornerRadii);
        }

        let startPt = corners[0].after;
        if (activeIdx === 0 && expandStart) {
            const rCap = Math.min(r, box.protrusionDepth, box.protrusionLength / 2);
            startPt = [0, -box.protrusionDepth + rCap];
        } else if (activeIdx === 3 && expandStart) {
            const rCap = Math.min(r, box.protrusionDepth, box.protrusionLength / 2);
            startPt = [-box.protrusionDepth + rCap, 0];
        }

        let d = `M ${pt(startPt)} `;

        edges.forEach((e, i) => {
            const L = e.len;
            const nextCornerIdx = (i + 1) % 4;
            const nextCorner = corners[nextCornerIdx];

            if (i === activeIdx) {
                const depth = box.protrusionDepth;
                const lenEff = Math.max(0, eEff - sEff);

                const uStartExpand = box.snapProtrusionToEdges && (i >= 2 ? expandEnd : expandStart);
                const uEndExpand = box.snapProtrusionToEdges && (i >= 2 ? expandStart : expandEnd);

                const u0 = (i >= 2) ? (L - eEff) : sEff;
                const u1 = (i >= 2) ? (L - sEff) : eEff;

                const maxRf0 = (i < 2) ? rfRaw0 : rfRawL;
                const maxRf1 = (i < 2) ? rfRawL : rfRaw0;

                const rf0 = uStartExpand ? 0 : Math.min(maxRf0, lenEff / 4, depth);
                const rf1 = uEndExpand ? 0 : Math.min(maxRf1, lenEff / 4, depth);
                const rProtCur = Math.max(0, Math.min(r, depth, lenEff / 2));

                if (uStartExpand) {
                    d += `L ${pt(e.map(u0, depth - rProtCur))} `;
                    d += `A ${rProtCur} ${rProtCur} 0 0 1 ${pt(e.map(u0 + rProtCur, depth))} `;
                } else {
                    d += `L ${pt(e.map(u0 - rf0, 0))} `;
                    if (rf0 > 0) {
                        d += `A ${rf0} ${rf0} 0 0 0 ${pt(e.map(u0, rf0))} `;
                    }
                    d += `L ${pt(e.map(u0, depth - rProtCur))} `;
                    d += `A ${rProtCur} ${rProtCur} 0 0 1 ${pt(e.map(u0 + rProtCur, depth))} `;
                }

                d += `L ${pt(e.map(u1 - rProtCur, depth))} `;

                if (uEndExpand) {
                    d += `A ${rProtCur} ${rProtCur} 0 0 1 ${pt(e.map(u1, depth - rProtCur))} `;
                    d += `L ${pt(e.map(u1, 0))} `;
                } else {
                    d += `A ${rProtCur} ${rProtCur} 0 0 1 ${pt(e.map(u1, depth - rProtCur))} `;
                    d += `L ${pt(e.map(u1, rf1))} `;
                    if (rf1 > 0) {
                        d += `A ${rf1} ${rf1} 0 0 0 ${pt(e.map(u1 + rf1, 0))} `;
                    }
                    d += `L ${pt(nextCorner.before)} `;
                }
            } else {
                if (suppressCorner[nextCornerIdx]) {
                    d += `L ${pt(e.map(L, 0))} `;
                } else {
                    d += `L ${pt(nextCorner.before)} `;
                }
            }

            if (!suppressCorner[nextCornerIdx] && nextCorner.arc && nextCorner.radius > 0) {
                d += `${arcTo(nextCorner)} `;
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
