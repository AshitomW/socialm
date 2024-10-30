import 'package:firebase_storage/firebase_storage.dart';
import "package:social/components/providers/fb_providers.dart";
import 'package:social/core/typdef.dart';
import "package:fpdart/fpdart.dart";
import "package:social/core/failure.dart";
import "dart:io";
import "package:flutter_riverpod/flutter_riverpod.dart";

final firebaseStorageProvider = Provider(
  (ref) => StorageRepository(
    firebaseStorage: ref.watch(storageProvider),
  ),
);

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile(
      {required String path, required String id, required File? file}) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      UploadTask uploadTask = ref.putFile(file!);
      final snapshot = await uploadTask;
      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
