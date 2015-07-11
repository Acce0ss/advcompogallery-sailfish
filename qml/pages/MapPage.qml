import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.2
import QtLocation 5.0

import "../components"

Page {
  id: root

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

          text: switch ( modeSelector.currentItem.mode )
                {
                case modes.ownPosition:
                  return qsTr("Press the map to show/hide full map,"
                              + " own position is shown with uncertainty circle.");
                case modes.drawRoute:
                  return qsTr("Click on the map to define route points.");
                case modes.placeMarkers:
                  return qsTr("Click on the map to place marker. "
                              + "Bottom corner of the rectangle is placed on the coordinate.");
                case modes.markersNearby:
                  return qsTr("Color markers inside a 1500 m radius circle, centered at clicked point.");
                default:
                  return qsTr("Error, faulty mode");
                }
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
            MenuItem {
              text: qsTr("Own position")
              property int mode: modes.ownPosition
            }
            MenuItem {
              text: qsTr("Draw route")
              property int mode: modes.drawRoute
            }
            MenuItem {
              text: qsTr("Place markers")
              property int mode: modes.placeMarkers
            }
            MenuItem {
              text: qsTr("Nearby markers")
              property int mode: modes.markersNearby
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
        center: QtPositioning.coordinate( 60.45, 22.25)

        plugin: Plugin {
          name: "osm"
          PluginParameter{ name:  "mapping.cache.directory" ; value: "/tmp/qtmap" }
          PluginParameter{ name:  "mapping.cache.size" ; value: "200000" }
        }

        Component.onCompleted: {
          map.addMapItem(ownPosition);
          map.addMapItem(uncertaintyCircle);
          map.addMapItem(route);
        }

        MapQuickItem {
          id: ownPosition

          visible: modeSelector.currentItem.mode === modes.ownPosition

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

//          visible: modeSelector.currentItem.mode === modes.ownPosition

          center: positionSrc.position.coordinate

          radius: positionSrc.position.horizontalAccuracy

          color: "blue"
          opacity: 0.3

          border.color: "blue"
          border.width: 2
        }

        MapCircle {
          id: containingCircle

//          visible: modeSelector.currentItem.mode === modes.placesNearby

          radius: 1500

          color: "blue"
          opacity: 0.2
        }

        MapPolyline {
          id: route

//          visible: modeSelector.currentItem.mode === modes.drawRoute

          line.color: "blue"
          line.width: 3
        }

        MouseArea {
          anchors.fill: parent
          onClicked: {
            switch ( modeSelector.currentItem.mode )
            {
            case modes.ownPosition:
              drawer.open = !drawer.open;
              break;
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
      }
    }
  }

  function showMarkersNear(point)
  {
    containingCircle.center = map.toCoordinate(point);
    var circle = QtPositioning.circle(containingCircle.center, containingCircle.radius);
    places.forEach(function (e,i,l)
    {
      if(circle.contains(e.coordinate))
      {
        e.sourceItem.color = "green";
      }
      else
      {
        e.sourceItem.color = "red";
      }
    });
  }

  property var places: [];

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

    MapQuickItem {
      id: locationMarker

      anchorPoint.x: 0
      anchorPoint.y: 0

      sourceItem: Rectangle {

        id: markerItem

//        visible: modeSelector.currentItem.mode === modes.placeMarkers
//                 ||
//                 modeSelector.currentItem.mode === modes.placesNearby

        property int diagonal: Math.sqrt(Math.pow(width, 2)+Math.pow(height, 2))

        transformOrigin: Item.TopLeft

        rotation: 45+180

        color: "red"
        opacity: 0.7

        width: 40
        height: 40

        MouseArea {
          anchors.fill: parent
          onClicked: {
            map.removeMapItem(locationMarker);
            places.splice(places.indexOf(locationMarker), 1);
          }
        }

        Rectangle {
          x: -2.5
          y: -2.5
          radius: 5
          width: radius
          height: radius
          color: "black"
        }
      }
    }
  }
}
