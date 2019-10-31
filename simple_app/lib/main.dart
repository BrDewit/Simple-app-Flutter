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
        appBar: PreferredSize( //PreferredSize widget allows to change the size of the child widget
          preferredSize: Size.fromHeight(48), //height is just enough for the 2 tabs
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
  static GoogleMapController _mapController;
  var location = new Location();
  Set<Polyline> _polylines = Set();
  int _lineId = 0;

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
            LocationData currentLocation = await location.getLocation();

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
          child: RaisedButton(
            // callback function, called after a the button is pressed
            onPressed: () async {
              LocationData currentLocation = await location.getLocation();

              var lat = currentLocation.latitude;
              var lng = currentLocation.longitude;
              var positions = <LatLng>[LatLng(lat, lng)];

              setState(() {
                _polylines.add(
                    Polyline(
                      polylineId: PolylineId("$_lineId"),
                      visible: true,
                      color: Colors.red,
                      width: 4,
                      points: positions,
                    )
                );
              });

              _lineId++;
            },

            // Look of the button
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
}

class DataTab extends StatefulWidget {
  @override
  DataTabState createState() => DataTabState();
}

class DataTabState extends State<DataTab> {
  @override
  Widget build(BuildContext context) {
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
