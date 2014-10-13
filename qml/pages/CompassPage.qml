import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.0

Page {
  id: root

  Column {
    width: parent.width
    PageHeader {
      title: qsTr("Accelerometer")
    }

    SectionHeader {
      text: qsTr("Available position sources")
    }

    Label {
      x: Theme.paddingLarge
      width: parent.width-2*Theme.paddingLarge
      wrapMode: Text.Wrap
      text: qsTr("Used positioning method: %1").arg(methodName)
    }
  }
}
