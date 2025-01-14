import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:path/path.dart' as p;

class Storageservice {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Storageservice() {}

  Future<String?> uploadUserpfp(
      {required File file, required String uid}) async {
    Reference fileref = _firebaseStorage
        .ref('users/pfps')
        .child('$uid${p.extension(file.path)}');

    UploadTask Task = fileref.putFile(file);
    return Task.then((p) {
      if (p.state == TaskState.success) {
        return fileref.getDownloadURL();
      }
    });
  }

  Future<String?> uploadimagTOchat(
      {required File file, required String chatID}) async {
    Reference fileref = _firebaseStorage
        .ref('chats/$chatID')
        .child('${DateTime.now().toIso8601String()}${p.extension(file.path)}');
    UploadTask task = fileref.putFile(file);
    return task.then((p) {
      if (p.state == TaskState.success) {
        return fileref.getDownloadURL();
      }
    });
  }
}
