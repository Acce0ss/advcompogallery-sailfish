import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.0

Page {
  id: root

  SilicaListView {
    anchors.fill: parent
    header: PageHeader {
      title: qsTr("")
    }
    width: parent.width
    model: QmlSensors.sensorTypes()
    delegate: ListItem {
      Label {
        x: Theme.paddingLarge
        width: parent.width - 2*Theme.paddingLarge
        text: modelData
      }
    }
  }
}

