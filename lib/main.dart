import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:treasure_hunt/app.dart';
import 'package:treasure_hunt/firebase/auth.dart';
// TODO: Remove this once set on auth method.
// import 'package:treasure_hunt/state/user_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => UserState()),
        StreamProvider<User>.value(value: originalStreamSignIn())
      ],
      child: App(),
    ),
  );
}
