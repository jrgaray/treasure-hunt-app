import 'package:flutter/material.dart';
import 'package:treasure_hunt/screens/add_treasure_caches.dart';
import 'package:treasure_hunt/screens/edit_treasure_chart.dart';
import 'package:treasure_hunt/screens/root.dart';
import 'package:treasure_hunt/screens/login.dart';
import 'package:treasure_hunt/screens/treasure_hunt_search.dart';
import 'package:treasure_hunt/screens/new_treasure_chart.dart';

class App extends StatelessWidget {
  static const String title = 'Treasure Hunt';
  final routes = {
    EditTreasureChart.routeName: (context) => EditTreasureChart(),
    NewTreasureChart.routeName: (context) => NewTreasureChart(),
    TreasureHuntSearch.routeName: (context) => TreasureHuntSearch(),
    RootScreen.routeName: (context) => RootScreen(title: title),
    Login.routeName: (context) => Login(
          title: title,
        ),
    AddTreasureCaches.routeName: (context) => AddTreasureCaches(),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: routes);
  }
}
