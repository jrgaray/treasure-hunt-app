import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:treasure_hunt/firebase/storage.dart';
import 'package:treasure_hunt/firebase/store.dart';

FirebaseAuth auth = FirebaseAuth.instance;

// Signs user into the app.
Future<UserCredential> signIn(email, password) async =>
    await auth.signInWithEmailAndPassword(email: email, password: password);

// Signs user out of the app.
Future<void> signOut() => auth.signOut();

// Stream of the user state.
Stream<User> originalStreamSignIn() {
  return auth.authStateChanges();
}

// Creates user in Firebase Auth, uploads image to Firebase Storage, and
// adds user data to Firebase Firestore.
Future<void> createUser(
  String email,
  String password,
  String firstName,
  String lastName,
  DateTime birthday,
  File photo,
) async {
  final userCreds = await auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );

  User user = userCreds.user;

  assert(user != null);
  assert(await user.getIdToken() != null);

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
