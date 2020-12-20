import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:treasure_hunt/screens/add_treasure_caches.dart';
import 'package:provider/provider.dart';
import 'package:treasure_hunt/screens/create_account_screen.dart';
import 'package:treasure_hunt/screens/edit_treasure_chart.dart';
import 'package:treasure_hunt/screens/root.dart';
import 'package:treasure_hunt/screens/login.dart';
import 'package:treasure_hunt/screens/treasure_hunt_search.dart';
import 'package:treasure_hunt/screens/treasure_hunt_create.dart';

class App extends StatelessWidget {
  static const String title = 'Treasure Hunt';
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    final routes = {
      EditTreasureChart.routeName: (context) => EditTreasureChart(),
      TreasureHuntCreate.routeName: (context) => TreasureHuntCreate(),
      TreasureHuntSearch.routeName: (context) => TreasureHuntSearch(),
      RootScreen.routeName: (context) => RootScreen(title: title),
      Login.routeName: (context) {
        return Login(
          title: title,
        );
      },
      AddTreasureCaches.routeName: (context) => AddTreasureCaches(),
      CreateAccountScreen.routeName: (context) => CreateAccountScreen(),
    };
    return MaterialApp(
        title: 'Hunt',
        theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: routes);
  }
}
