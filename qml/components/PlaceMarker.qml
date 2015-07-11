import QtQuick 2.0
import QtLocation 5.0

MapQuickItem {
  id: locationMarker

  anchorPoint.x: markerItem.width / 2
  anchorPoint.y: markerItem.height

  property string name

  sourceItem: Text {
    id: markerItem

    color: "black"

    text: locationMarker.name

    Rectangle {

      x: locationMarker.anchorPoint.x
      y: locationMarker.anchorPoint.y

      transformOrigin: Item.TopLeft

      rotation: 45+180

      color: "red"
      opacity: 0.7

      width: 40
      height: 40
    }
  }
}
