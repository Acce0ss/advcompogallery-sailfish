import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.2
import QtLocation 5.0

import "../components"

Page {
  id: root

  backNavigation: drawer.open

  property bool pluginSupportsRouting: false
  property bool pluginSupportsPlaces: false

  MapModes {
    id: modes
  }

  Drawer {
    id: drawer
    anchors.fill: parent

    open: true

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
                case modes.routing:
                  return qsTr("Click waypoints on the map to find route between. "
                              + "Clear all waypoints with button");
                case modes.placesNearby:
                  return qsTr("Places markers to places within 500 m from map center,"
                              + " by searching with keyword.");
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
              enabled: root.pluginSupportsPlaces
              text: qsTr("Nearby places")
              property int mode: modes.placesNearby
            }
            MenuItem {
              enabled: root.pluginSupportsRouting
              text: qsTr("Find route")
              property int mode: modes.routing
            }
          }
        }

        TextField {
          id: keywordField

          width: parent.width - 2*Theme.paddingSmall
          x: Theme.paddingSmall

          enabled: modeSelector.currentItem.mode === modes.placesNearby
                   &&
                   !searchModel.isLoading

          label: qsTr("Search places nearby (click map to search)")
          placeholderText: label
        }
        Button {
          anchors.horizontalCenter: parent.horizontalCenter
          text: qsTr("Clear all waypoints")
          onClicked: {

            routeQuery.clearWaypoints()

          }
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
          NumberAnimation { duration: 100 }
        }

        zoomLevel: 10
        center: QtPositioning.coordinate( 60.45, 22.25)

        plugin: Plugin {
          id: mapPlugin
          name: "osm"
          PluginParameter{ name:  "mapping.cache.directory" ; value: "/tmp/qtmap" }
          PluginParameter{ name:  "mapping.cache.size" ; value: "200000" }
          PluginParameter{ name: "routing.host"; value: "http://router.project-osrm.org/viaroute" }

          Component.onCompleted: {
            console.log("supports geoding: " + mapPlugin.supportsGeocoding())
            console.log("supports places: " + mapPlugin.supportsPlaces())
            console.log("supports mapping: " + mapPlugin.supportsMapping())
            console.log("supports routing: " + mapPlugin.supportsRouting())

            root.pluginSupportsPlaces = mapPlugin.supportsPlaces();
            root.pluginSupportsRouting = mapPlugin.supportsRouting();
          }
        }

        MapItemView {
          model: routeModel
          delegate: Component {
            MapRoute {
              route: routeData

              line.color: "blue"
              line.width: 4
              smooth: true
              opacity: 0.9

              Component.onCompleted: {

                //Work around for bug in osm plugin:
                if(mapPlugin.name === "osm")
                {
                  routeData.path.forEach(function (e,i,l){
                    l[i].latitude = e.latitude / 10;
                    l[i].longitude = e.longitude / 10;
                  });
                }
              }
            }
          }
        }

        MapItemView {
          model: searchModel
          delegate: locationMarkerComponent
        }

        MouseArea {
          anchors.fill: parent

          enabled: !routeModel.isLoading

          onClicked: {
            switch ( modeSelector.currentItem.mode )
            {
            case modes.routing:
              addRoutePoint(Qt.point(mouse.x, mouse.y));
              break;
            case modes.placesNearby:
              showPlacesNear(map.center, keywordField.text)
              break;
            default:
              break;
            }
          }
        }

        BusyIndicator {
          id: busyInd

          anchors.centerIn: parent

          running: searchModel.isLoading || routeModel.isLoading

        }
      }
    }
  }

  function showPlacesNear(coord, keyword)
  {
    searchModel.searchArea = QtPositioning.circle(coord, 1500);
    searchModel.searchTerm = keyword;
    searchModel.update();
  }

  function addRoutePoint(point)
  {
    routeQuery.addWaypoint(map.toCoordinate(point));
    if(routeQuery.waypoints.length >= 2)
    {
      routeModel.update();
    }
  }

  PlaceSearchModel {
    id: searchModel
    plugin: mapPlugin

    property bool isLoading: status === PlaceSearchModel.Loading

  }

  RouteQuery {
    id: routeQuery
  }

  RouteModel {
    id: routeModel

    plugin: mapPlugin

    query: routeQuery

    property bool isLoading: status === RouteModel.Loading

    autoUpdate: false
    onErrorChanged: {
      console.log("routing error: " + errorString)
    }
  }

  Component {
    id: locationMarkerComponent

    MapQuickItem {
      id: locationMarker

      anchorPoint.x: 0
      anchorPoint.y: 0

      coordinate: place.location.coordinate

      property string name: title

      sourceItem: Rectangle {

        id: markerItem

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

        Label {
          x: 0
          y: parent.height

          rotation: 45 + 90

          color: "black"

          text: locationMarker.name
        }
      }
    }
  }
}
