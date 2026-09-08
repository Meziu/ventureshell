pragma Singleton
import QtQuick

QtObject {
    enum Position {
        None = 0,
        Top = 1,
        Bottom = 2,
        Left = 4,
        Right = 8,
        TopLeft = 5,
        TopRight = 9,
        BottomLeft = 6,
        BottomRight = 10
    }

    function isValid(pos: int): bool {
        if (pos === Position.None)
            return false;

        const verticalConflict = (pos & Position.Top) && (pos & Position.Bottom);
        const horizontalConflict = (pos & Position.Left) && (pos & Position.Right);

        return !verticalConflict && !horizontalConflict;
    }

    function opposite(pos: int): int {
        if (isValid(pos)) {
            return ((pos & Position.Top) ? Position.Bottom : ((pos & Position.Bottom) ? Position.Top : Position.None)) | ((pos & Position.Left) ? Position.Right : ((pos & Position.Right) ? Position.Left : Position.None));
        } else {
            console.warn("Invalid position specified");
        }
    }

    // Non-diagonal
    function isSingle(pos: int): bool {
        if (isValid(pos)) {
            return pos === Position.Top || pos === Position.Bottom || pos === Position.Left || pos === Position.Right;
        } else {
            console.warn("Invalid position specified");
        }
    }

    function name(pos: int): string {
        if (isValid(pos) && isSingle(pos)) {
            if (pos === Position.Top) {
                return "top"
            } else if (pos === Position.Bottom) {
                return "bottom"
            } else if (pos === Position.Left) {
                return "left"
            } else if (pos === Position.Right) {
                return "right"
            }
        } else {
            console.warn("Invalid position specified");
        }
    }

    function isYAxis(pos: int): bool {
        if (isValid(pos) && isSingle(pos)) {
            return pos === Position.Top || pos === Position.Bottom
        } else {
            console.warn("Invalid position specified");
        }
    }
}
