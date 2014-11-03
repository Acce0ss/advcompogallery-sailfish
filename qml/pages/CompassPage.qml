import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.1

import "../components"

Page {
  id: root

  Compass {
    id: sensor
    alwaysOn: true
    active: activationSwitch.checked
    dataRate: 25


    property int angle: reading != null ? reading.azimuth : 0
    property real accuracy: reading != null ? reading.calibrationLevel : 0
  }

  Column {

    width: parent.width
    PageHeader {
      title: qsTr("Compass")
    }

    SectionHeader {
      text: qsTr("Controls")
    }

    TextSwitch {
      id: activationSwitch
      text: qsTr("Running")
      anchors.horizontalCenter: parent.horizontalCenter
      checked: true
    }

    SectionHeader {
      text: qsTr("Indicators")
    }

    Label {
      wrapMode: Text.Wrap
      text: qsTr("Angle: %1").arg(sensor.angle)
    }/*
    ProgressBar {
      width: parent.width

      maximumValue: 1
      minimumValue: 0
      label: qsTr("calibration level")
      valueText: value
      value: sensor.accuracy
    }*/

  }
  Item {
    anchors.bottom: root.bottom
    anchors.left: root.left
    width: parent.width
    height: 500

    CircleIndicator {
      anchors.centerIn: parent
      value: sensor.angle
      maxValue: 360
    }

  }
}
