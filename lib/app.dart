import 'package:flutter/material.dart';
import 'package:treasure_hunt/screens/new_treasure_cache.dart';
import 'package:treasure_hunt/screens/root.dart';
import 'package:treasure_hunt/screens/login.dart';
import 'package:treasure_hunt/screens/treasure_hunt_search.dart';
import 'package:treasure_hunt/screens/chart_treasure.dart';

class App extends StatelessWidget {
  static const String title = 'Treasure Hunt';
  final routes = {
    ChartTreasure.routeName: (context) => ChartTreasure(),
    TreasureHuntSearch.routeName: (context) => TreasureHuntSearch(),
    RootScreen.routeName: (context) => RootScreen(title: title),
    Login.routeName: (context) => Login(
          title: title,
        ),
    NewTreasureCache.routeName: (context) => NewTreasureCache(),
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
