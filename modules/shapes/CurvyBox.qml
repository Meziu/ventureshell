import QtQuick
import QtQuick.Shapes

Shape {
    id: box

    required property Attach attached
    property real cornerRadius: 14
    property bool showFeet: true // haha, feet

    readonly property color gradStart: Qt.rgba(250 / 255, 179 / 255, 135 / 255, 0.16)
    readonly property color gradEnd: Qt.rgba(250 / 255, 179 / 255, 135 / 255, 0.05)
    readonly property color borderCol: Qt.rgba(250 / 255, 179 / 255, 135 / 255, 0.28)

    preferredRendererType: Shape.CurveRenderer

    // Walks the outline clockwise (top -> right -> bottom -> left). At each
    // of the four corners there are only ever three possible treatments,
    // decided purely from `attached`:
    //  - both adjacent sides attached   -> a plain sharp corner
    //  - neither adjacent side attached -> an ordinary rounded corner
    //  - exactly one side attached      -> the attached edge overshoots the
    //    corner by cornerRadius, the other edge stops cornerRadius short of
    //    it, and a quarter-circle centered on the original corner joins the
    //    two - the box "flares" outward instead of meeting the flat
    //    attached edge with a hard corner (this is what used to be a
    //    separate CurvyFoot). Falls back to a sharp corner when showFeet is
    //    false.
    function outlinePath() {
        const w = width;
        const h = height;
        const r = cornerRadius;
        const a = attached;

        // cx,cy: the corner's own coordinate.
        // beforeOffset/afterOffset: [dx,dy] offset from the corner of the
        // ordinary rounded-corner touch points on the incoming ("before")
        // and outgoing ("after") edge, walking clockwise.
        // beforeAttached/afterAttached: whether each of those edges is attached.
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

        const corners = [corner(0, 0, [0, r], [r, 0], a.left, a.top) // top-left
            , corner(w, 0, [-r, 0], [0, r], a.top, a.right) // top-right
            , corner(w, h, [0, -r], [-r, 0], a.right, a.bottom) // bottom-right
            , corner(0, h, [r, 0], [0, -r], a.bottom, a.left) // bottom-left
        ];

        const pt = p => `${p[0]} ${p[1]}`;
        // Plain rounded corners: sweep 1 (concave, hugs the corner).
        // Foot corners: sweep 0 (convex, flares outward) — the opposite solution
        // of the same two-point/radius pair.
        const arcTo = (p, foot) => `A ${r} ${r} 0 0 ${foot ? 0 : 1} ${pt(p)}`;

        let d = `M ${pt(corners[0].after)} `;
        for (let i = 0; i < corners.length; i++) {
            const next = corners[(i + 1) % corners.length];
            d += `L ${pt(next.before)} `;
            if (next.arc)
                d += `${arcTo(next.after, next.foot)} `;
        }
        d += "Z";

        return d;
    }

    ShapePath {
        strokeColor: box.borderCol
        strokeWidth: 1

        fillGradient: LinearGradient {
            x1: 0
            y1: 0
            x2: box.width
            y2: box.height

            GradientStop {
                position: 0.0
                color: box.gradStart
            }
            GradientStop {
                position: 1.0
                color: box.gradEnd
            }
        }

        PathSvg {
            path: box.outlinePath()
        }
    }
}
