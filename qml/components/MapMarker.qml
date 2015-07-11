import QtQuick 2.0
import QtLocation 5.0

MapQuickItem {
  id: locationMarker

  anchorPoint.x: 0
  anchorPoint.y: 0

  sourceItem: Rectangle {

    id: markerItem

    transformOrigin: Item.TopLeft

    rotation: 45+180

    color: "red"
    opacity: 0.7

    width: 40
    height: 40

    MouseArea {
      anchors.fill: parent
      onClicked: {
        map.removeMapItem(locationMarker);
        places.splice(places.indexOf(locationMarker), 1);
      }
    }

    Rectangle {
      x: -2.5
      y: -2.5
      radius: 5
      width: radius
      height: radius
      color: "black"
    }
  }
}
