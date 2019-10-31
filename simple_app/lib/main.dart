import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:package_info/package_info.dart';

// Version number of the app
String version;

// main gets called when the app opens
void main() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  version = packageInfo.version;
  runApp(MyApp());
}

// App widget, the root of the widget tree, is a MaterialApp
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyTabView(),
    );
  }
}

// Creates a Scaffold with 2 tabs
class MyTabView extends StatelessWidget {
  final List<Tab> myTabs = <Tab>[
    Tab(icon: Icon(Icons.map)),
    Tab(icon: Icon(Icons.list)),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          //PreferredSize widget allows to change the size of the child widget
          preferredSize:
              Size.fromHeight(48), //height is just enough for the 2 tabs
          child: AppBar(
            bottom: TabBar(
              tabs: myTabs,
            ),
          ),
        ),
        body: TabBarView(children: <Widget>[
          MapTab(),
          DataTab(),
        ]),
      ),
    );
  }
}

// The body of the tab with the GoogleMap
class MapTab extends StatefulWidget {
  @override
  MapTabState createState() => MapTabState();
}

class MapTabState extends State<MapTab> {
  GoogleMapController _mapController;

  // The polylines are the routes the user has taken
  Set<Polyline> _polylines = Set();
  int _lineId = 0;
  // the polyline of the current route
  Polyline route;

  // A timer that, when started, records the route of the user and draws it on the map
  final tickdelay = Duration(seconds: 1);
  Timer _recordCycle;

  //
  bool isRecording = false;
  // starts/stops the process of drawing the route of the user
  void _recordButtonPressed() {
    if(isRecording) {
      _recordCycle.cancel();
      setState(() {
        isRecording = false;
      });
    } else {
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
      _polylines.add(route);

      _lineId++;

      _recordCycle = Timer.periodic(tickdelay, (Timer timer) async {
        // a location object to be able to access the user location
        Location location = new Location();
        LocationData currentLocation = await location.getLocation();

        var lat = currentLocation.latitude;
        var lng = currentLocation.longitude;

        // add the current location to the points of the polyline
        setState(() {
          route.points.add(LatLng(lat, lng));
        });
      });

      setState(() {
        isRecording = true;
      });
    }
  }

  // build function that builds the UI of the widget
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(-33.852, 151.211),
            zoom: 15.0,
          ),
          onMapCreated: (GoogleMapController controller) async {
            _mapController = controller;
            // get the current location of the user
            LocationData currentLocation = await Location().getLocation();

            var lat = currentLocation.latitude;
            var long = currentLocation.longitude;

            // move the camera to the position of the user
            _mapController
                .moveCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
          },
          polylines: _polylines,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          // The button on the map tab that starts the recording of the route
          child: RaisedButton(
            // callback function, called after a the button is pressed
            onPressed: _recordButtonPressed,

            // Properties that change the look of the button
            elevation: 5,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.blueAccent,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.blue,
            textColor: Colors.white,
            child: Text("Start Recording"),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _recordCycle.cancel();
    super.dispose();
  }
}

// The body of the data tab
class DataTab extends StatefulWidget {
  @override
  DataTabState createState() => DataTabState();
}

class DataTabState extends State<DataTab> {
  @override
  Widget build(BuildContext context) {
    // a scrollable list
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        Text("Version $version"),
        Divider(),
        Text("This is an app to test Flutter's ease of use."),
        Text("\n \n \n"),
        Text("Made by Bram Dewit")
      ],
    );
  }
}
