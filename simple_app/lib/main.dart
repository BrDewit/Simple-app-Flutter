import 'package:flutter/material.dart';

import './MyTabView.dart';

// main gets called when the app opens
void main() async {
  runApp(MyApp());
}

// App widget, the root of the widget tree, is a MaterialApp
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple App',
      
      home: MyTabView(),

      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
    );
  }
}
