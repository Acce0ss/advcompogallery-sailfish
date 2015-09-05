import QtQuick 2.0
import QtLocation 5.0

MapQuickItem {
  id: locationMarker

  anchorPoint.x: markerItem.width / 2
  anchorPoint.y: markerItem.height

  property string name
  property Icon icon

  sourceItem: Image {
    id: markerItem

    source: icon !== null ? icon.url(32) : ""

    Text {
        anchors.top: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: locationMarker.name

        color: "black"
    }
  }
}
