import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:treasure_hunt/app.dart';
import 'package:treasure_hunt/firebase/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    StreamProvider<User>.value(
      child: App(),
      value: originalStreamSignIn(),
    ),
  );
}
