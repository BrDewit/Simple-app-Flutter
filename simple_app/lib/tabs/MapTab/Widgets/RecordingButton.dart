import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../sensors/RouteRecorder.dart';

class RecordingButton extends StatefulWidget {
  @override
  RecordingButtonState createState() => RecordingButtonState();
}

class RecordingButtonState extends State<RecordingButton> {
  @override
  Widget build(BuildContext context) {
    // The button starts the recording of a route so it needs the recordRoute function of the RouteRecorder
    RouteRecorder recorder = Provider.of(context, listen: false);

    return RaisedButton(
      child:
          Text(recorder.isRecording ? "Recording route..." : "Start Recording"),

      // callback function, called after a the button is pressed
      onPressed: () {
        recorder.recordRoute();
        setState(() {});
      },

      // Properties that change the look of the button
      elevation: 5,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: recorder.isRecording ? Colors.redAccent : Colors.blueAccent,
          width: 4,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      color: recorder.isRecording ? Colors.red : Colors.blue,
      textColor: Colors.white,
    );
  }
}
