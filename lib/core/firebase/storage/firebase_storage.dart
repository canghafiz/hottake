import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final firebaseStorage = FirebaseStorage.instance;

Future<String> uploadImageToStorage({
  required String folderName,
  required String fileName,
  required File file,
}) async {
  var storageRef = firebaseStorage.ref("$folderName/$fileName");
  await storageRef.putFile(file);
  return storageRef.getDownloadURL();
}

Future<void> deleteImageFromStorage(String url) async {
  firebaseStorage.refFromURL(url).delete();
}
