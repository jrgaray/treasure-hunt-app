import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseStorage storage = FirebaseStorage.instance;

Future<String> uploadFile(String path, File file) async {
  print("in storage");
  final ref = storage.ref(path);
  await ref.putFile(file);
  return ref.getDownloadURL();
}
