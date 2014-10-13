import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.1

Page {
  id: root

  Accelerometer {
    id: sensor
    alwaysOn: true
    active: activationSwitch.checked
    dataRate: 10 //frequency in Hertz

    // set to cancel out earths gravity -> apparently not supported?
    // accelerationMode: Accelerometer.User
  }

  property bool readingReady: sensor.reading != null

  Column {
    width: parent.width
    PageHeader {
      title: qsTr("Acceleration including gravity")
    }

    SectionHeader {
      text: qsTr("Controls")
    }

    TextSwitch {
      id: activationSwitch
      text: qsTr("Measuring")
      anchors.horizontalCenter: parent.horizontalCenter
      checked: true
    }

    SectionHeader {
      text: qsTr("Indicators")
    }

    Row {
      width: parent.width
      height: Theme.itemSizeLarge

      Label {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width /3
        text: qsTr("X: %1").arg(readingReady ? sensor.reading.x : 0)
      }
      Label {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width /3
        text: qsTr("Y: %1").arg(readingReady ? sensor.reading.y : 0)
      }
      Label {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width /3
        text: qsTr("Z: %1").arg(readingReady ? sensor.reading.z : 0)
      }
    }

    Label {
      x: Theme.paddingLarge
      width: parent.width-2*Theme.paddingLarge
      wrapMode: Text.Wrap
      text: qsTr("").arg("methodName")
    }

  }
}
