import QtQuick 2.0
import QtLocation 5.0
import QtPositioning 5.2

MapPolyline {

  property Route route

  line.color: "blue"
  line.width: 4
  smooth: true
  opacity: 0.9

  property int travelTime
  property real distance
  property var segments

  onRouteChanged: updateRoute()

  function updateRoute()
  {
    var rData = route;

    if(rData !== null)
    {
      travelTime = rData.travelTime;
      distance = rData.distance;

      rData.path.forEach(function (e,i,l){
        var nn = 1e6;
        var fixedLat = Math.round((e.latitude / 10)*nn)/nn;
        var fixedLon = Math.round((e.longitude / 10)*nn)/nn;
        addCoordinate(QtPositioning.coordinate(fixedLat, fixedLon));
      });

      segments = rData.segments;
    }
  }
}
