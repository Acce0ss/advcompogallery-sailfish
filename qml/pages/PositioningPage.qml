import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.2

Page {
  id: root

  Column {
    width: parent.width
    PageHeader {
      title: qsTr("Positioning")
    }

    SectionHeader {
      text: qsTr("Available position sources")
    }

    Label {
      x: Theme.paddingLarge
      width: parent.width-2*Theme.paddingLarge
      wrapMode: Text.Wrap
      text: qsTr("Used positioning method: %1").arg(methodName)
      property string methodName: {
        switch(positionSrc.supportedPositioningMethods)
        {
        case PositionSource.SatellitePositioningMethods:
          //comments for translators:
          //:Positioning with satellites
          return qsTr("Satellite");
        case PositionSource.NoPositioningMethods:
          //:Positioning not available
          return qsTr("Not available");
        case PositionSource.NonSatellitePositioningMethods:
          //:Positioning with other than satellite methods
          return qsTr("Non-satellite");
        case PositionSource.AllPositioningMethods:
          //:Positioning with multiple sources
          return qsTr("Multiple");
        default:
          //:Positioning source error
          return qsTr("source error");
        }
      }
    }

    Label {
      id: positionLabel
      x: Theme.paddingLarge
      width: parent.width-2*Theme.paddingLarge
      wrapMode: Text.WordWrap
      text: qsTr("You're at %1 latitude, %2 longitude")
      .arg(positionSrc.position.coordinate.latitude)
      .arg(positionSrc.position.coordinate.longitude)
    }

    PositionSource {
      id: positionSrc
      updateInterval: 1000 //päivitysväli
      active: true //aloita päivittäminen heti
    }
  }
}
