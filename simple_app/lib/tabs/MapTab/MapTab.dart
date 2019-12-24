import 'package:flutter/material.dart';

import './Widgets/MyMap.dart';
import './Widgets/RecordingButton.dart';

// The body of the tab with the Google Map
// It contains a Google Map and a button to start recording the user's route
class MapTab extends StatefulWidget {
  @override
  MapTabState createState() => MapTabState();
}

class MapTabState extends State<MapTab> {
  // build function that builds the UI of the widget
  @override
  Widget build(BuildContext context) {
    // Build the view
    return Stack(
      children: <Widget>[
        MyMap(), // The Google Map
        Align(
          // The button on the map tab that starts the recording of the route
          child: RecordingButton(),
          alignment: Alignment.bottomCenter,
        ),
      ],
    );
  }
}
