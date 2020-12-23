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

class App extends HookWidget {
  static const String title = 'Treasure Hunt';
  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<User>();
    final routes = {
      EditTreasureChart.routeName: (context) => EditTreasureChart(),
      TreasureChartCreate.routeName: (context) => TreasureChartCreate(),
      TreasureHuntSearch.routeName: (context) => TreasureHuntSearch(),
      RootScreen.routeName: (context) => RootScreen(title: title),
      Login.routeName: (context) => Login(title: title),
      AddTreasureCaches.routeName: (context) => AddTreasureCaches(),
      CreateAccountScreen.routeName: (context) => CreateAccountScreen(),
    };
    return MultiProvider(
      providers: [
        StreamProvider<Map<String, TreasureUser>>.value(
          catchError: (context, error) {
            print(error);
            return null;
          },
          value: getUsers(),
        ),
        StreamProvider<QuerySnapshot>.value(
          catchError: (context, error) {
            print(error);
            return null;
          },
          value: getAllCharts(),
        ),
        StreamProvider<DocumentSnapshot>.value(
            catchError: (context, error) {
              print(error);
              return null;
            },
            value: streamData(authUser?.uid) ?? null),
        StreamProvider<List<TreasureChart>>.value(
            catchError: (context, error) {
              print(error);
              return [];
            },
            value: userCharts(authUser?.uid) ?? null),
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
