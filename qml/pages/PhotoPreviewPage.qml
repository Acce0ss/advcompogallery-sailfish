import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
  id: root

  property alias source: preview.source



  Column {
    width: parent.width
    PageHeader {
      title: qsTr("Photo")
    }
    Image {
      x: Theme.paddingLarge
      width: parent.width - 2*Theme.paddingLarge
      //rotation: 90

      fillMode: Image.PreserveAspectFit

      id: preview
    }
  }
}
