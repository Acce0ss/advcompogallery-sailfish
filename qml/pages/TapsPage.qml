import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.1

Page {
  id: root

  TapSensor {
    id: sensor
    alwaysOn: true
    active: activationSwitch.checked
    returnDoubleTapEvents: returnDoubleTapOnlySwitch.checked
    axesOrientationMode: Sensor.AutomaticOrientation
    onActiveChanged: {
      console.log("active vaihtu " + connectedToBackend + " " + reading.timestamp + " " + error)
    }
    onReadingChanged: {

      console.log("laa")

      switch (reading.tapDirection)
      {
      case TapReading.X_Pos:
        eventLabel.text = qsTr("From right");
        break;
      case TapReading.Y_Pos:
        eventLabel.text = qsTr("From up");
        break;
      case TapReading.Z_Pos:
        eventLabel.text = qsTr("From front");
        break;
      case TapReading.X_Neg:
        eventLabel.text = qsTr("From left");
        break;
      case TapReading.Y_Neg:
        eventLabel.text = qsTr("From down");
        break;
      case TapReading.Z_Neg:
        eventLabel.text = qsTr("From back");
        break;
      default:
        eventLabel.text = qsTr("Tap error")
      }
    }
  }

  Column {
    width: parent.width
    PageHeader {
      title: qsTr("Tapping")
    }

    SectionHeader {
      text: qsTr("Controls")
    }

    TextSwitch {
      id: activationSwitch
      text: qsTr("React to tapping")
      anchors.horizontalCenter: parent.horizontalCenter
      checked: true
    }

    TextSwitch {
      id: returnDoubleTapOnlySwitch
      anchors.horizontalCenter: parent.horizontalCenter
      text: qsTr("Act only on double taps")
      checked: true
    }

    SectionHeader {
      text: qsTr("Indicators")
    }

    Grid {
      id: indicators

      width: parent.width
      anchors.horizontalCenter: parent.horizontalCenter

      columns: 2
      rows: 2

      Repeater {
        model: 4
        delegate: GlassItem {

          width: 4*Theme.paddingLarge
          height: width
          falloffRadius: dimmed ? 0.15 : 0.25
          cache: false
        }
      }
    }
    Label {
      id: eventLabel
      anchors.horizontalCenter: parent.horizontalCenter
      width: parent.width-2*Theme.paddingLarge
      wrapMode: Text.Wrap
      text: qsTr("Try (double) tapping from left or right side")
    }
  }
}
