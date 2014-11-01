import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.1

import "../components"

Page {
  id: root

  Gyroscope {
    id: sensor
    alwaysOn: true
    active: activationSwitch.checked
    dataRate: 10 //frequency in Hertz

  }

  property bool readingReady: sensor.reading != null

  Column {
    width: parent.width
    PageHeader {
      title: qsTr("Rotational acceleration")
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

    Label {
      x: Theme.paddingLarge
      width: parent.width - 2*Theme.paddingLarge
      text: qsTr("around X-axis: %1<br>around Y-axis: %2<br>around Z-axis: %3")
      .arg(readingReady ? sensor.reading.x : 0)
      .arg(readingReady ? sensor.reading.y : 0)
      .arg(readingReady ? sensor.reading.z : 0)
    }


    AccelerationIndicator {
      id: ind
      x_pos: readingReady ? sensor.reading.y : 0
      y_pos: readingReady ? -sensor.reading.x : 0
      max_pos_abs: 300
    }

  }
}
