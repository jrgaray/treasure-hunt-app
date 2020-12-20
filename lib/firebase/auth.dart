import 'package:firebase_auth/firebase_auth.dart';
import 'package:treasure_hunt/firebase/store.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future<void> signIn(email, password) async {
  await auth.signInWithEmailAndPassword(email: email, password: password);
}

Future<void> signOut() => auth.signOut();

Stream<User> streamSignIn() {
  return auth.authStateChanges();
}

Future<void> createUser(
    email, password, firstName, lastName, birthday, photo) async {
  final userCreds = await auth.createUserWithEmailAndPassword(
      email: email, password: password);
  User user = userCreds.user;
// final photoUrl = photo !=null ? await uploadPhotoToStorage(photo): null;
  // await  addUserInfoToFirestore(user.uid, email, )
}
