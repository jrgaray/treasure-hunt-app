import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:treasure_hunt/app.dart';
import 'package:treasure_hunt/firebase/auth.dart';
import 'package:treasure_hunt/firebase/store.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/models/treasure_search.dart';
import 'package:treasure_hunt/state/user_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserState()),
        StreamProvider<List<TreasureHunt>>.value(value: chartStream()),
        StreamProvider<List<TreasureSearch>>.value(value: huntStream()),
        StreamProvider<User>.value(value: streamSignIn())
      ],
      child: App(),
    ),
  );
}
