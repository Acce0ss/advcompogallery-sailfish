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


    property int angle: readingReady ? reading.azimuth : 0
    property real accuracy: readingReady ? reading.calibrationLevel : 0
  }

  property bool readingReady: sensor.reading != null

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
      x: Theme.paddingLarge
      width: parent.width-2*Theme.paddingLarge
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
      value: Math.abs(360-sensor.angle) //difference to north
      maxValue: 360
    }

  }
}
