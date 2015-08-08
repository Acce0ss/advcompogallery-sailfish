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

          text: modes.getDescription(modeSelector.currentItem.mode)
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
                text: modes.getMenuString(mode)
                property int mode: modelMode
              }
            }
          }
        }

        TextField {
          id: keywordField

          width: parent.width - 2*Theme.paddingSmall
          x: Theme.paddingSmall

          visible: modeSelector.currentItem.mode === modes.placesNearby
          enabled: !searchModel.isLoading

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
        opacity: searchModel.isLoading || routeModel.isLoading
                 ? 0.5 : 1.0

        property real baseHeight: root.height-controlsButton.height
        height: drawer.open ? (baseHeight)-drawer.backgroundSize : baseHeight

        Behavior on height {
          NumberAnimation { duration: 100 }
        }

        zoomLevel: 10
        center { latitude: 60.45; longitude: 22.25 }

        plugin: Plugin {
          id: mapPlugin
          name: "osm"

          Component.onCompleted: {
            if(mapPlugin.supportsRouting())
            {
              modes.addAvailableMode(modes.routing);
            }
            if(mapPlugin.supportsPlaces())
            {
              modes.addAvailableMode(modes.placesNearby);
            }
          }
        }

        MapItemView {

          model: routeModel
          delegate: Component {
            id: normalRoute
            MapRoute {

              visible: mapPlugin.name !== "osm"

              route: routeData

              line.color: "blue"
              line.width: 4
              smooth: true
              opacity: 0.9
            }
          }
        }

        MapItemView {
          model: routeModel
          delegate: Component {
            // Due to API change, OSM routing gives coordinates too large by a decade.
            // OSMRoute component internally fixed coordinates and draws the route using
            // MapPolyLine
            OSMRoute {
              visible: mapPlugin.name === "osm"
              route: routeData
            }
          }
        }

        MapItemView {
          model: searchModel
          delegate:  Component {
            PlaceMarker {
              name: place.name
              icon: place.icon
              coordinate: place.location.coordinate
            }
          }
        }

        MouseArea {
          anchors.fill: parent

          enabled: !routeModel.isLoading && !searchModel.isLoading

          onClicked: {
            switch ( modeSelector.currentItem.mode )
            {
            case modes.routing:
              addRoutePoint(Qt.point(mouse.x, mouse.y));
              break;
            case modes.placesNearby:
              showPlacesNear(Qt.point(mouse.x, mouse.y), keywordField.text)
              break;
            default:
              break;
            }
          }
        }
      }
    }
  }

  function showPlacesNear(point, keyword)
  {
    searchModel.searchArea = QtPositioning.circle(map.toCoordinate(point), 1500);
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
    plugin: Plugin {
      name: "nokia"
      //set the correct values and uncomment following lines to use places:
//      PluginParameter{ name: "app_id" ; value: "your_appid" }
//      PluginParameter{ name: "token" ; value: "your_token" }
      Component.onCompleted: {
        if(supportsPlaces() && appIdAndTokenGiven())
        {
          modes.addAvailableMode(modes.placesNearby);
        }
      }

      function appIdAndTokenGiven()
      {
        var appIdGiven = false;
        var tokenGiven = false;
        for(var i=0; i < parameters.length; i++)
        {
          if(parameters[i].name === "app_id")
          {
            appIdGiven = true;
          }
          else if(parameters[i].name === "token")
          {
            tokenGiven = true;
          }
        }

        return appIdGiven && tokenGiven;
      }
    }
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
  }

  BusyIndicator {
    id: busyInd

    size: BusyIndicatorSize.Large
    anchors.centerIn: parent

    running: searchModel.isLoading || routeModel.isLoading
  }
}
