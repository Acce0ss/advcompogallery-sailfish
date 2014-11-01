import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
  id: root
  x: Theme.paddingLarge
  width: parent.width - 2*Theme.paddingLarge
  height: width

  property real max_pos_abs: 15
  property real x_pos: 0
  property real y_pos: 0

  function get_x_coord(x_val, width)
  {
    var d_x = (root.width / 2) * (x_val / root.max_pos_abs);
    var base_x = root.width / 2 - width / 2;
    return base_x + d_x;
  }

  function get_y_coord(y_val, height)
  {
    var d_y = (root.height / 2) * (y_val / root.max_pos_abs);
    var base_y = root.height / 2 - height / 2;
    return base_y + d_y;
  }

  Rectangle {
    id: indicator

    x: get_x_coord(x_pos, width)
    y: get_y_coord(y_pos, height)

    Behavior on x { SmoothedAnimation { velocity: 2000 } }
    Behavior on y { SmoothedAnimation { velocity: 2000 } }

    color: "red"
    width: parent.width / 10
    height: width
  }

}
