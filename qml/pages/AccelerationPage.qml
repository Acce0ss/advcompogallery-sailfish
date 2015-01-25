import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.2

import "../components"

Page {
  id: root

  Accelerometer {
    id: sensor
    alwaysOn: true
    active: activationSwitch.checked
    dataRate: 10 //frequency in Hertz

  }

  property bool readingReady: sensor.reading != null

  Column {
    id: content
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
    Label {
      x: Theme.paddingLarge
      width: parent.width - 2*Theme.paddingLarge
      text: qsTr("Visualize:")
    }
    Row {
      width: parent.width
      TextSwitch {
        width: parent.width / 3
        id: xSwitch
        text: "X"
      }
      TextSwitch {
        width: parent.width / 3
        id: ySwitch
        text: "Y"
      }
      TextSwitch {
        width: parent.width / 3
        id: zSwitch
        text: "Z"
      }
    }

    SectionHeader {
      text: qsTr("Indicators")
    }


    Label {
      x: Theme.paddingLarge
      width: parent.width - 2*Theme.paddingLarge
      text: qsTr("along X-axis: %1<br>along Y-axis: %2<br>along Z-axis: %3")
      .arg(readingReady ? sensor.reading.x : 0)
      .arg(readingReady ? sensor.reading.y : 0)
      .arg(readingReady ? sensor.reading.z : 0)
    }

  }
  AccelerationIndicator {
    id: ind
    anchors.bottom: parent.bottom
    height: parent.height-content.height
    x_pos: xSwitch.checked ? (readingReady ? -sensor.reading.x : 0) : 0
    y_pos: ySwitch.checked ? (readingReady ? sensor.reading.y : 0) : 0
    z_pos: zSwitch.checked ? (readingReady ? sensor.reading.z : 0) : 0
    max_pos_abs: 15
  }
}
