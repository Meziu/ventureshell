import QtQuick

/*
  Eases an item's `rotation` toward its new value instead of snapping
  to it. Used for the clock-driven orbits (hour, weekday, day-of-month,
  month) whose target angle jumps discretely every time the underlying
  clock value ticks over.

  Usage:
      rotation: someExpressionDerivedFromTheClock
      SmoothRotation on rotation {}
*/
Behavior {
    PropertyAnimation {
        easing.type: Easing.InOutQuad
    }
}
