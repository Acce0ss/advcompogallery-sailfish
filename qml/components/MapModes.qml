import QtQuick 2.0

QtObject {
  id: root

  property int ownPosition: 1
  property int drawRoute: 2
  property int placeMarkers: 3
  property int markersNearby: 4

  property int routing: 5
  property int placesNearby: 6

  function getDescription(mode)
  {
    switch ( mode )
    {
    case root.ownPosition:
      return qsTr("Own position is shown with uncertainty circle.");
    case root.drawRoute:
      return qsTr("Click on the map to define route points.");
    case root.placeMarkers:
      return qsTr("Click on the map to place marker. "
                  + "Bottom corner of the rectangle is placed on the coordinate.");
    case root.markersNearby:
      return qsTr("Color markers inside a 1500 m radius circle, centered at clicked point.");
    case root.routing:
      return qsTr("Click waypoints on the map to find route between. "
                  + "Clear all waypoints with button");
    case root.placesNearby:
      return qsTr("Places markers to places within 500 m from touch point,"
                  + " by searching with keyword.");
    default:
      return qsTr("Error, faulty mode");
    }
  }

  function getMenuString(mode)
  {
    switch (mode)
    {
    case root.ownPosition:
      return  qsTr("Own position");
    case root.drawRoute:
      return qsTr("Draw route");
    case root.placeMarkers:
      return qsTr("Place markers");
    case root.markersNearby:
      return qsTr("Nearby markers");
    case root.routing:
      return qsTr("Find route");
    case root.placesNearby:
      return qsTr("Nearby places");
    default:
      return qsTr("Error, faulty mode");
    }
  }

  property ListModel availableModes: ListModel {  }

  function addAvailableMode(mode)
  {
    availableModes.append({"modelMode": mode});
  }
}
