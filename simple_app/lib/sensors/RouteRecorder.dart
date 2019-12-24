import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';


// The RouteRecorder manages recording the user's route
class RouteRecorder extends ChangeNotifier {
  // The following variables are used to draw the user's route on the map
  // The polylines are the routes the user has taken
  Set<Polyline> polylines = Set();
  int _lineId = 0;
  // the polyline of the current route
  Polyline route;

  // A timer that, when started, records the route of the user and draws it on the map
  // The timer is started when the 'Start Recording' button is pressed (when _recordButtonPressed is called)
  final tickdelay = Duration(seconds: 1);
  Timer _recordCycle;

  // a boolean that tracks whether the app is recording the user's route or not
  bool isRecording = false;

  // starts/stops the process of drawing the route of the user
  void recordRoute() {
    if (isRecording) {
      _recordCycle.cancel();
      isRecording = false;
    } else {
      // The points of the current polyline
      var positions = List<LatLng>();

      // Add a new polyline to the map
      // This will draw the route of the user
      route = Polyline(
        polylineId: PolylineId("$_lineId"),
        visible: true,
        color: Colors.red,
        width: 4,
        points: positions,
      );
      polylines.add(route);

      // Increase lineId so the next line will have a different Id that this one
      _lineId++;

      // Start a timer that adds the current user location to the polyline every 'tickdelay' amount of time
      _recordCycle = Timer.periodic(tickdelay, (Timer timer) async {
        // a location object to be able to access the user location
        Location location = new Location();
        LocationData currentLocation = await location.getLocation();

        var lat = currentLocation.latitude;
        var lng = currentLocation.longitude;

        // add the current location to the points of the polyline
        route.points.add(LatLng(lat, lng));
        notifyListeners();
      });

      isRecording = true;
    }
  }
}