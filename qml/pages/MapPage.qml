import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.2
import QtLocation 5.0

import "../components"

Page {
  id: root

  property var places: [];

  backNavigation: drawer.open

  MapModes {
    id: modes
  }

  PositionSource {
    id: positionSrc
    updateInterval: 1000
    active: true
  }

  Drawer {
    id: drawer
    anchors.fill: parent

    open: false

    dock: root.isPortrait ? Dock.Top : Dock.Left

    background: SilicaFlickable {
      anchors.fill: parent
      contentHeight: controls.height

      VerticalScrollDecorator {}

      Column {
        id: controls
        width: parent.width
        PageHeader {
          title: qsTr("Using maps")
        }
        SectionHeader {
          text: qsTr("Guide")
        }

        Label {
          width: parent.width-Theme.paddingMedium*2
          x: Theme.paddingMedium
          anchors.horizontalCenter: parent.horizontalCenter

          wrapMode: Text.WordWrap

          text: modes.getDescription( modeSelector.currentItem.mode )

        }

        SectionHeader {
          text: qsTr("Controls")
        }

        ComboBox {
          id: modeSelector

          anchors.horizontalCenter: parent.horizontalCenter

          label: qsTr("Mode: ")
          description: qsTr("Functionality mode for the map")

          menu: ContextMenu {
            Repeater {
              model: modes.availableModes

              MenuItem {
                text: modes.getMenuString(modelMode)
                property int mode: modelMode
              }
            }
          }
        }

        Button {
          id: clearButton
          anchors.horizontalCenter: parent.horizontalCenter
          text: qsTr("Clear all items in map")
          onClicked: {

            map.clearMapItems();
            map.addMapItem(ownPosition);
            map.addMapItem(uncertaintyCircle);
            map.addMapItem(route);
          }
        }

        Button {
          id: clearRouteButton
          anchors.horizontalCenter: parent.horizontalCenter
          text: qsTr("Clear Route")
          onClicked: {
            route.path = [];
          }
        }

        Button {
          id: centerButton
          anchors.horizontalCenter: parent.horizontalCenter
          text: qsTr("Center map to my position")
          onClicked: map.center = positionSrc.position.coordinate
        }
      }
    }

    Column {
      id: mapContent
      width: parent.width

      Button {
        id: controlsButton
        anchors.horizontalCenter: parent.horizontalCenter
        text: drawer.open ? qsTr("Close controls") : qsTr("Open controls")
        onClicked: {

          drawer.open = !drawer.open;
        }
      }

      Map {
        id: map
        width: parent.width
        property real baseHeight: root.height-controlsButton.height
        height: drawer.open ? (baseHeight)-drawer.backgroundSize : baseHeight

        Behavior on height {
          NumberAnimation { duration: 200 }
        }

        zoomLevel: 10

        plugin: Plugin {
          name: "osm"
        }

        MapQuickItem {
          id: ownPosition

          anchorPoint.x: positionCircle.width / 2
          anchorPoint.y: positionCircle.width / 2

          coordinate: positionSrc.position.coordinate

          sourceItem: Rectangle {
            id: positionCircle
            width: 6
            height: width
            radius: width
            color: "blue"
          }
        }

        MapCircle {
          id: uncertaintyCircle

          center: positionSrc.position.coordinate

          radius: positionSrc.position.horizontalAccuracy

          color: "blue"
          opacity: 0.3

          border.color: "blue"
          border.width: 2
        }

        MapCircle {
          id: containingCircle

          radius: 1500

          color: "blue"
          opacity: 0.2
        }

        MapPolyline {
          id: route

          line.color: "blue"
          line.width: 3
        }

        MouseArea {
          anchors.fill: parent
          onClicked: {
            switch ( modeSelector.currentItem.mode )
            {
            case modes.drawRoute:
              addRoutePoint(Qt.point(mouse.x, mouse.y));
              break;
            case modes.placeMarkers:
              addMarker(Qt.point(mouse.x, mouse.y));
              break;
            case modes.markersNearby:
              showMarkersNear(Qt.point(mouse.x, mouse.y))
              break;
            default:
              break;
            }
          }
        }
        Component.onCompleted: {

          center = QtPositioning.coordinate(60.45, 22.25);

          modes.addAvailableMode(modes.drawRoute);
          modes.addAvailableMode(modes.placeMarkers);
          modes.addAvailableMode(modes.markersNearby);

          map.addMapItem(ownPosition);
          map.addMapItem(uncertaintyCircle);
          map.addMapItem(route);
        }
      }
    }
  }

  function showMarkersNear(point)
  {
    containingCircle.center = map.toCoordinate(point);
    var circle = QtPositioning.circle(containingCircle.center, containingCircle.radius);
    places.forEach(function (place,index,originalList)
    {
      if(circle.contains(place.coordinate))
      {
        place.sourceItem.color = "green";
      }
      else
      {
        place.sourceItem.color = "red";
      }
    });
  }

  function addRoutePoint(point)
  {
    route.addCoordinate(map.toCoordinate(point));
  }

  function addMarker(point)
  {
    var marker = locationMarkerComponent.createObject(map, {coordinate: map.toCoordinate(point)});
    map.addMapItem(marker);
    places.push(marker);
  }

  Component {
    id: locationMarkerComponent
    MapMarker {

    }

  }
}
