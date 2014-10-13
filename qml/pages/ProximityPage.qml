import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSensors 5.0

Page {
  id: root

  ProximitySensor {
    id: sensor
    alwaysOn: true
    active: activationSwitch.checked

  }

  Column {
    height: parent.height
    width: parent.width

    PageHeader {
      id: pageTitle
      title: qsTr("Proximity")
    }

    SectionHeader {
      text: qsTr("Controls")
    }

    TextSwitch {
      id: activationSwitch
      text: qsTr("Detecting proximity")
      anchors.horizontalCenter: parent.horizontalCenter
      checked: false
    }

    SectionHeader {
      text: qsTr("Indicators")
    }

    Label {
      id: descriptionLabel
      x: Theme.paddingLarge
      width: parent.width-2*Theme.paddingLarge
      wrapMode: Text.Wrap
      text: qsTr("The indicator will dim when something comes close")
    }

    GlassItem {
      anchors.horizontalCenter: parent.horizontalCenter
      width: 10*Theme.paddingLarge
      height: width

      dimmed: sensor.reading != null ? sensor.reading.near : false
      falloffRadius: dimmed ? 0.15 : 0.25
      cache: false
    }
  }
}
