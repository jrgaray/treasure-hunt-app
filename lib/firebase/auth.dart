import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:treasure_hunt/firebase/storage.dart';
import 'package:treasure_hunt/firebase/store.dart';
import 'package:treasure_hunt/models/treasure_user.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future<void> signIn(email, password) async {
  final userCreds =
      await auth.signInWithEmailAndPassword(email: email, password: password);
  // userCreds.user.uid
}

Future<void> signOut() => auth.signOut();

Stream<User> streamSignIn() {
  return auth.authStateChanges();
}

Future<void> createUser(String email, String password, String firstName,
    String lastName, DateTime birthday, File photo) async {
  final userCreds = await auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  User user = userCreds.user;
  final photoUrl = await uploadFile("avatarUrls/${user.uid}", photo);
  await addUserDataToStore(
    uid: user.uid,
    email: email,
    firstName: firstName,
    lastName: lastName,
    birthday: birthday,
    avatarUrl: photoUrl,
  );
}
