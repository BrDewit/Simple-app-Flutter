import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../sensors/RouteRecorder.dart';

class MyMap extends StatefulWidget {
  @override
  MyMapState createState() => MyMapState();
}

class MyMapState extends State<MyMap> {
  GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    // The map has to draw the updated route every time the routeRecorder adds a new position to the route
    // That is why the map is part of the 'builder' property of Consumer<RouteRecorder>
    return Consumer<RouteRecorder>(
      builder: (context, recorder, child) => GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(-33.852, 151.211),
          zoom: 17.0,
        ),

        // When the map is created, move it on the user's location
        onMapCreated: (GoogleMapController controller) async {
          _mapController = controller;
          // get the current location of the user
          LocationData currentLocation = await Location().getLocation();

          var lat = currentLocation.latitude;
          var long = currentLocation.longitude;

          // move the camera to the position of the user
          _mapController.moveCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
        },

        // The polylines indicate the routes the user has taken
        polylines: recorder.polylines,
      ),
    );
  }
}
