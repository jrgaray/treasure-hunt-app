import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:treasure_hunt/firebase/store.dart';
import 'package:treasure_hunt/models/treasure_chart.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/models/treasure_user.dart';
import 'package:treasure_hunt/screens/add_treasure_caches.dart';
import 'package:treasure_hunt/screens/create_account_screen.dart';
import 'package:treasure_hunt/screens/edit_treasure_chart.dart';
import 'package:treasure_hunt/screens/root.dart';
import 'package:treasure_hunt/screens/login.dart';
import 'package:treasure_hunt/screens/treasure_hunt_search.dart';
import 'package:treasure_hunt/screens/treasure_hunt_create.dart';
import 'package:treasure_hunt/screens/treasure_hunt_status.dart';
import 'package:treasure_hunt/screens/view_treasure_hunt_map.dart';

class App extends HookWidget {
  static const String title = 'Treasure Hunt';
  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<User>();
    final routes = {
      AddTreasureCaches.routeName: (context) => AddTreasureCaches(),
      CreateAccountScreen.routeName: (context) => CreateAccountScreen(),
      EditTreasureChart.routeName: (context) => EditTreasureChart(),
      Login.routeName: (context) => Login(title: title),
      RootScreen.routeName: (context) => RootScreen(title: title),
      TreasureChartCreate.routeName: (context) => TreasureChartCreate(),
      TreasureHuntSearch.routeName: (context) => TreasureHuntSearch(),
      TreasureHuntStatus.routeName: (context) => TreasureHuntStatus(),
      ViewTreasureHuntMap.routeName: (context) => ViewTreasureHuntMap(),
    };
    return MultiProvider(
      providers: [
        // Stream for getting a Map of TreasureUsers.
        StreamProvider<Map<String, TreasureUser>>.value(
          catchError: (context, error) {
            print(error);
            return null;
          },
          value: getUsers(),
        ),
        // Stream for getting all the charts for a user to select and start from.
        StreamProvider<QuerySnapshot>.value(
          catchError: (context, error) {
            print(error);
            return null;
          },
          value: getAllCharts(),
        ),
        // Stream for getting the logged in user's data.
        StreamProvider<DocumentSnapshot>.value(
            catchError: (context, error) {
              print(error);
              return null;
            },
            value: streamData(authUser?.uid) ?? null),
        // Stream for grabbing the user's charts.
        StreamProvider<List<TreasureChart>>.value(
            catchError: (context, error) {
              print(error);
              return [];
            },
            value: userCharts(authUser?.uid) ?? null),
        // Stream for grabbing the user's hunts.
        StreamProvider<List<TreasureHunt>>.value(
            catchError: (context, error) {
              print(error);
              return [];
            },
            value: userHunts(authUser?.uid) ?? null),
      ],
      child: MaterialApp(
          title: 'Hunt',
          theme: ThemeData(
            textTheme: GoogleFonts.latoTextTheme(),
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          routes: routes),
    );
  }
}
