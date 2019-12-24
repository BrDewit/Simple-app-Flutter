import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tabs/MapTab/MapTab.dart';
import 'tabs/DataTab/DataTab.dart';
import './sensors/RouteRecorder.dart';

// Creates a Scaffold with 2 tabs
class MyTabView extends StatelessWidget {
  final List<Tab> myTabs = <Tab>[
    Tab(icon: Icon(Icons.map)),
    Tab(icon: Icon(Icons.list)),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => RouteRecorder(),
      child: DefaultTabController(
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
          body: TabBarView(
            children: <Widget>[
              MapTab(),
              DataTab(),
            ],
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }
}
