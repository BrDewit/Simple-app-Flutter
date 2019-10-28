import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

String version = "1.0.0";


var location = new Location();


void main() {
  runApp(MyApp());
}

// Main app class
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
          preferredSize: Size.fromHeight(48),
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

class MapTab extends StatefulWidget {
  @override
  MapTabState createState() => MapTabState();
}

class MapTabState extends State<MapTab> {
  static GoogleMapController _mapController;

  final GoogleMap googleMap = GoogleMap(
    mapType: MapType.normal,
    myLocationEnabled: true,
    initialCameraPosition: CameraPosition(
      target: LatLng(-33.852, 151.211),
      zoom: 11.0,
    ),
    onMapCreated: (GoogleMapController controller) async {
      _mapController = controller;
      LocationData currentLocation = await location.getLocation();

      var lat = currentLocation.latitude;
      var long = currentLocation.longitude;
      controller.moveCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
    },
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        googleMap,
        Align(
          alignment: Alignment.bottomCenter,
          child: RaisedButton(
            onPressed: () async {

              LocationData currentLocation = await location.getLocation();

              var lat = currentLocation.latitude;
              var long = currentLocation.longitude;

              print("lat = $lat, long = $long");
            },
            elevation: 5,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.blueAccent,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Start Recording",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
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
        Text(""),
        Text(""),
        Text(""),
        Text("Made by Bram Dewit")
      ],
    );
  }
}
