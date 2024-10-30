import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:social/components/model/usermodel.dart';
import 'package:social/components/providers/fb_providers.dart';
import 'package:social/core/failure.dart';
import "package:social/core/firebase_constants.dart";
import 'package:social/core/typdef.dart';

final userProfileServiceProvider = Provider((ref) {
  return UserProfileService(firestore: ref.watch(firestoreProvider));
});

class UserProfileService {
  final FirebaseFirestore _firestore;
  UserProfileService({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.userCollection);

  FutureVoid editUserProfile(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
