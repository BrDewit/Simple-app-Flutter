import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

// The body of the data tab
// the requirements for this tab are that it displays some random text/data in a scrollable view
class DataTab extends StatefulWidget {
  @override
  DataTabState createState() => DataTabState();
}


class DataTabState extends State<DataTab> {
  String version;

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();
    getVersion();
  }

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