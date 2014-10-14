import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
  id: root

  property int value: 0
  property int maxValue: 360

  property int center_x: width / 2
  property int center_y: width / 2

  // the original dimensions = 408x408
  property real _scaleRatio: valueCircle.width / 408

  function _xTranslation(value, bound) {
    // Use sine to map range of 0-bound to the X translation of a circular locus (-1 to 1)
    return Math.sin((value % bound) / bound * Math.PI * 2)
  }

  function _yTranslation(value, bound) {
    // Use cosine to map range of 0-bound to the Y translation of a circular locus (-1 to 1)
    return Math.cos((value % bound) / bound * Math.PI * 2)
  }

  function radiusForCoord(x, y) {
    // Return the distance from the mouse position to the center
    return Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2))
  }

  function angleForCoord(x, y) {
    // Return the angular position in degrees, rising anticlockwise from the positive X-axis
    var result = Math.atan(y / x) / (Math.PI * 2) * 360

    // Adjust for various quadrants
    if (x < 0)  {
      result += 180
    } else if (y < 0) {
      result += 360
    }
    return result
  }

  function remapAngle(value, bound) {
    // Return the angle in degrees mapped to the adjusted range 0 - (bound-1) and
    // translated to the clockwise from positive Y-axis orientation
    return Math.round(bound - (((value - 90) / 360) * bound)) % bound
  }

  Image {
    id: valueCircle
    anchors.centerIn: parent

    source: "image://Theme/timepicker"
    opacity: 0.1
  }

  onValueChanged: {

    var delta = (root.value - valueIndicator.value) % (root.maxValue);
    if ((delta > root.maxValue/2) || (delta < -root.maxValue/2)) {
      // We don't want to animate for more than a full cycle
      valueIndicator.animationEnabled = false;

      valueIndicator.value += (delta > 0 ? root.maxValue : -root.maxValue)
      delta = (root.value - valueIndicator.value) % (root.maxValue)

      valueIndicator.animationEnabled = true;
    }

    valueIndicator.value += delta;
  }

  GlassItem {
    id: valueIndicator

    x: 0+center_x
    y: 1+center_y

    falloffRadius: 0.22
    radius: 0.25
    anchors.centerIn: valueCircle
    color: Theme.highlightColor

    property int value: 0
    property bool animationEnabled: true

    transform: Translate {
      // The hours circle ends at 132px from the center
      x: _scaleRatio*168 * _xTranslation(valueIndicator.value, maxValue)
      y: -_scaleRatio*168 * _yTranslation(valueIndicator.value, maxValue)
    }

    Behavior on value {
      id: valueAnimation
      SmoothedAnimation { velocity: 80 }
      enabled: valueIndicator.animationEnabled
    }
  }
}
